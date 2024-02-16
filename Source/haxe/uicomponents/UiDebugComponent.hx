package uicomponents;

import haxe.ui.components.Button;
import haxe.ui.components.CheckBox;
import haxe.ui.core.Component;
import haxe.ui.containers.Box;
import haxe.ui.containers.VBox;
import haxe.ui.containers.TabView;
import haxe.ui.events.MouseEvent;

@:build(haxe.ui.ComponentBuilder.build("Assets/UI/entity-debug-container.xml"))
class UiDebugComponent extends VBox {
    var tvMain:TabView = null;
    var boxSpawnList:Box = null;
    var checkboxHitboxVisible = null;

    public function new() {
        super();

        trace("new", "UiDebugComponent");
        tvMain = cast(findComponent("tvMain"), TabView);
        boxSpawnList = cast(findComponent("stage-spawn-buttons"), Box);
        checkboxHitboxVisible = cast(findComponent("options-visible"), CheckBox);
        trace(tvMain); 
        cast(findComponent("options-visible"), CheckBox).focus = false;
        checkboxHitboxVisible.focus = false; 
    }

    //Function to add a new enemy button to the tabs
    public function addButtonToSpawnEntity(label:String, callback:MouseEvent -> Void):Button {
        // Create a new Button
        var button = new Button();
        button.text = label;
    
        // On button click, execute the provided callback
        button.onClick = callback;
    
        // Add the button to the current component (UiDebugComponent)
        boxSpawnList.addComponent(button);
    
        // Return the created button
        return button;
    }

    //Function to add a new box to the tabs
    public function addTab(box) {
        tvMain.addComponent(box);
    }
}