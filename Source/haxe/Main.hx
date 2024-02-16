package;

import scenes.SceneTest01;
import scenes.SceneTransition;
import openfl.display.Sprite;
import openfl.display.SimpleButton;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Assets;
import openfl.Lib;

import utils.MovieClipUtil;
import scenes.SceneEvent;
import scenes.SceneIntro;
import scenes.SceneMainMenueSelect;
import scenes.SceneMissionSelect;
import scenes.ScenePractice;
import scenes.SceneHaxeUITest;

class Main extends Sprite {
    var currentScene:Sprite;

    public function new() {
        super();
           
        currentScene = new SceneIntro( );
        addChild(currentScene);
        
        addEventListener(SceneEvent.CONTINUE, onNextScene);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }
    
    private function onEnterFrame(_) {
        
    }

    private function onNextScene(event:SceneEvent):Void {
        trace("next scene", event.nextScene);

        //removeChild(currentScene);
        currentScene = event.nextScene;
        addChild(currentScene);
    }
}
