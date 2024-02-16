package sprites;

import openfl.events.Event;
import utils.MovieClipUtil;
import openfl.display.MovieClip;
import lime.utils.AssetLibrary;
import openfl.Assets;
import openfl.display.Sprite;

class SpriteHealth extends Sprite {
    var mcHeadsUpDisplay:MovieClip;
    var mcHealthBarInfill:MovieClip;
    var mcSpecialBarInfill:MovieClip;

    public function new() {
        super();

        //Load the library
        if (Assets.hasLibrary("swf-HeadsUpDisplay")) trace("WARNING: swf-HeadsUpDisplay has not been loaded yet, may take a while...");
        Assets.loadLibrary("swf-HeadsUpDisplay").onComplete(function (asset:AssetLibrary) {
            //Get the assets
            mcHeadsUpDisplay = Assets.getMovieClip("swf-HeadsUpDisplay:HeadsUpDisplay");
            mcHealthBarInfill = MovieClipUtil.findMovieClip(mcHeadsUpDisplay, "mcHealthBarInfill");
            mcSpecialBarInfill = MovieClipUtil.findMovieClip(mcHeadsUpDisplay, "mcSpecialBarInfill");

            addChild(mcHeadsUpDisplay);

            dispatchEvent(new Event(Event.COMPLETE));
        });
    }
}