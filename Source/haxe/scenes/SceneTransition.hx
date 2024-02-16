package scenes;
 
import math.Algorithm;
import openfl.Lib;
import openfl.events.Event;
import openfl.display.Sprite;

class SceneTransition extends Sprite {
    public var sOld:Sprite;
    public var sNew:Sprite;

    public var startTime = 0.0;
    public var transitioned = false;
    public var reverseTransition = false;

    public function new (sOld:Sprite, sNew:Sprite) {
        super();

        this.sOld = sOld;
        this.sNew = sNew;

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    }

    public function onAddedToStage(_) {
        Lib.current.stage.frameRate = 1000;
        startTime = Lib.getTimer();
        
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    public function onRemovedFromStage(_) {
        // Cleanup and remove event listeners
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        
        // Remove all variables
        sOld = null;
        sNew = null;
    }

    public function onEnterFrame(_) {  
        final endTime = 1.5;
        var elapsed = Math.min(((Lib.getTimer()) - startTime) / 100, endTime);
        var percent = Math.sin(elapsed);

        if (transitioned) {
            percent = 1 - percent; // Reverse the percentage for upward transition
        }

        graphics.clear ();
        graphics.beginFill (0x1F9DB2);
        graphics.drawRect (0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight * percent);

        if (elapsed == endTime && transitioned == false) { 
            trace("parrent", parent);
            // Once reverse animation is complete, perform necessary actions
            sOld.parent.addChild(sNew);
            sOld.parent.setChildIndex(sNew, 0);
            sOld.parent.removeChild(sOld);

            transitioned = true; 
        } else if (elapsed == endTime && transitioned == true)
        {
            if(parent != null)
            parent.removeChild(this);
        }
    }
}
