package scenes;

import openfl.display.Sprite;
import openfl.events.Event;

class SceneEvent extends Event {
    public static inline var CONTINUE:String = "continue";

    public var nextScene:Sprite;

    public function new(type:String, nextScene:Sprite ) {
        super(type, false, false);
        this.nextScene = nextScene;
    }

    override public function clone():Event {
        return new SceneEvent(type, nextScene);
    }
}
