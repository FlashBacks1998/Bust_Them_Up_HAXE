package scenes;

import haxe.ui.Toolkit;
import uicomponents.UiDebugComponent;
import openfl.display.Sprite;

class SceneHaxeUITest extends Sprite { 

    public function new() {
        super(); 

        Toolkit.init();

        addChild(new UiDebugComponent());
    } 
}
