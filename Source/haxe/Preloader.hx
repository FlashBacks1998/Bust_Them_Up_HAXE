package;


import haxe.Timer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.ProgressEvent;
import openfl.Lib;
import openfl.Assets;
import openfl.events.EventDispatcher;

import openfl.text.TextField;
import openfl.text.TextFormat;

import thread.*;

class Preloader extends Sprite {
    private var moveon:Bool = false;
    private var assetsToPreload = [
        "swf-Intro",
        "swf-MainMenuReal",
        "swf-MissionSelect",
    ]; 
    private var progress:PseudoAtomic<Int> = new PseudoAtomic<Int>(0);

    public function new () { 
        super ();
        
        addEventListener (Event.COMPLETE, onComplete);
        addEventListener (ProgressEvent.PROGRESS, onProgress); 
    }
     
    private function update (percent:Float):Void {
        trace("progress", "update", percent);

        graphics.clear ();
        graphics.beginFill (0x1F9DB2);
        graphics.drawRect (0, 0, stage.stageWidth * percent, stage.stageHeight);
    }
     
    private function onComplete(event:Event):Void {
        trace("progress", "complete");

        update(1);
        
        event.preventDefault(); 

        update(0);

        for (asset in assetsToPreload) {
            trace("loading...", asset);

            var future = Assets.loadLibrary(asset);

            future.onComplete(function (_) {
                var newProgress = progress.get() + 1;
                progress.set(newProgress);
                trace("loaded", Lib.getTimer(), asset, newProgress);
                dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, newProgress, assetsToPreload.length));

                if(newProgress >= assetsToPreload.length) 
                    dispatchEvent (new Event (Event.UNLOAD));
            });

            future.onProgress(function (x,y) {
                trace(x,y);
            });

            future.onError(function(error) {
                trace("Error loading asset:", asset, error);
            });
        }
    }
     
    private function onProgress (event:ProgressEvent):Void {
		trace(Lib.getTimer(), "progress",  event.bytesLoaded, event.bytesTotal);

        if (event.bytesTotal <= 0)
            update (0);    
        else 
            update (event.bytesLoaded / event.bytesTotal); 
    }
}
