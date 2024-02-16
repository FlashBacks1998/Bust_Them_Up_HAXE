package uicomponents;

import openfl.events.MouseEvent;
import openfl.events.Event;
import haxe.ui.core.Component;
import haxe.ui.containers.Box;
import haxe.ui.components.TextField;
import openfl.geom.Vector3D;
import Std;

@:build(haxe.ui.ComponentBuilder.build("Assets/UI/entity-debug-default-tab.xml"))
class UiDebugDefaultComponent extends Box {
    private var inputPositionX:TextField;
    private var inputPositionY:TextField;
    private var inputPositionZ:TextField;
    private var inputVelocityX:TextField;
    private var inputVelocityY:TextField;
    private var inputVelocityZ:TextField;
    private var inputHealth:TextField;

    private var vPosition:Vector3D = null;
    private var vVelocity:Vector3D = null;

    public function new() {
        super();

        // Initialize text fields
        inputPositionX = cast(findComponent("input-default-positionx"), TextField);
        inputPositionY = cast(findComponent("input-default-positiony"), TextField);
        inputPositionZ = cast(findComponent("input-default-positionz"), TextField);
        inputVelocityX = cast(findComponent("input-default-velocityx"), TextField);
        inputVelocityY = cast(findComponent("input-default-velocityy"), TextField);
        inputVelocityZ = cast(findComponent("input-default-velocityz"), TextField);
        inputHealth = cast(findComponent("input-default-health"), TextField);
        
        // Add event listeners to each text field
        inputPositionX.addEventListener(MouseEvent.MOUSE_OVER, onComponentMouseIn); 
        inputPositionY.addEventListener(MouseEvent.MOUSE_OVER, onComponentMouseIn); 
        inputPositionZ.addEventListener(MouseEvent.MOUSE_OVER, onComponentMouseIn); 
        inputVelocityX.addEventListener(MouseEvent.MOUSE_OVER, onComponentMouseIn); 
        inputVelocityY.addEventListener(MouseEvent.MOUSE_OVER, onComponentMouseIn); 
        inputVelocityZ.addEventListener(MouseEvent.MOUSE_OVER, onComponentMouseIn); 
        inputHealth.addEventListener(MouseEvent.MOUSE_OVER, onComponentMouseIn); 
        
        inputPositionX.addEventListener(MouseEvent.CLICK, onComponentMouseIn); 
        inputPositionY.addEventListener(MouseEvent.CLICK, onComponentMouseIn); 
        inputPositionZ.addEventListener(MouseEvent.CLICK, onComponentMouseIn); 
        inputVelocityX.addEventListener(MouseEvent.CLICK, onComponentMouseIn); 
        inputVelocityY.addEventListener(MouseEvent.CLICK, onComponentMouseIn); 
        inputVelocityZ.addEventListener(MouseEvent.CLICK, onComponentMouseIn); 
        inputHealth.addEventListener(MouseEvent.CLICK, onComponentMouseIn); 

        inputPositionX.addEventListener(Event.CHANGE, onTextFieldPositionChange); 
        inputPositionY.addEventListener(Event.CHANGE, onTextFieldPositionChange); 
        inputPositionZ.addEventListener(Event.CHANGE, onTextFieldPositionChange); 
        inputVelocityX.addEventListener(Event.CHANGE, onTextFieldVelocityChange); 
        inputVelocityY.addEventListener(Event.CHANGE, onTextFieldVelocityChange); 
        inputVelocityZ.addEventListener(Event.CHANGE, onTextFieldVelocityChange); 
        
        trace("UiDebugDefaultComponent", inputPositionX, inputPositionY, inputPositionZ, inputVelocityX, inputVelocityY, inputVelocityZ, inputHealth);
    }
    
    private function onComponentMouseIn(event:Event):Void {
        var textField = cast(event.currentTarget, TextField);
        textField.focus = true;
    }

    private function onTextFieldPositionChange(event:Event) {
        var x = Std.parseFloat(inputPositionX.text);
        var y = Std.parseFloat(inputPositionY.text);
        var z = Std.parseFloat(inputPositionZ.text);

        vPosition.x = (Math.isNaN(x)) ? vPosition.x : x;
        vPosition.y = (Math.isNaN(x)) ? vPosition.x : y;
        vPosition.z = (Math.isNaN(x)) ? vPosition.x : z;
        setPosition(vPosition);
    }
    
    private function onTextFieldVelocityChange(event:Event) {
        var x = Std.parseFloat(inputVelocityX.text);
        var y = Std.parseFloat(inputVelocityY.text);
        var z = Std.parseFloat(inputVelocityZ.text);

        vVelocity.x = (Math.isNaN(x)) ? vVelocity.x : x;
        vVelocity.y = (Math.isNaN(x)) ? vVelocity.x : y;
        vVelocity.z = (Math.isNaN(x)) ? vVelocity.x : z;
        setPosition(vVelocity);
    }

    public function setIcon(icon:Dynamic) {
        this.icon = icon;
    }

    public function setTitle(title:String) {
        this.text = title;
        trace("TITLE", this.text, title);
    }

    // Set position values
    public function setPosition(pos:Vector3D):Void {
        vPosition = pos;
 
        if (!inputPositionX.focus) inputPositionX.text = Std.string(Math.round(pos.x * 1000) / 1000);
        if (!inputPositionY.focus) inputPositionY.text = Std.string(Math.round(pos.y * 1000) / 1000);
        if (!inputPositionZ.focus) inputPositionZ.text = Std.string(Math.round(pos.z * 1000) / 1000);
    }

    // Set velocity values
    public function setVelocity(vel:Vector3D):Void {
        vVelocity = vel;

        if (!inputVelocityX.focus) inputVelocityX.text = Std.string(Math.round(vel.x * 1000) / 1000);
        if (!inputVelocityY.focus) inputVelocityY.text = Std.string(Math.round(vel.y * 1000) / 1000);
        if (!inputVelocityZ.focus) inputVelocityZ.text = Std.string(Math.round(vel.z * 1000) / 1000);
    }

    // Get position values
    public function getPosition():Vector3D {
        var posX:Float = Std.parseFloat(inputPositionX.text);
        var posY:Float = Std.parseFloat(inputPositionY.text);
        var posZ:Float = Std.parseFloat(inputPositionZ.text);
        return new Vector3D(posX, posY, posZ);
    }

    // Get velocity values
    public function getVelocity():Vector3D {
        var velX:Float = Std.parseFloat(inputVelocityX.text);
        var velY:Float = Std.parseFloat(inputVelocityY.text);
        var velZ:Float = Std.parseFloat(inputVelocityZ.text);
        return new Vector3D(velX, velY, velZ);
    }
}
