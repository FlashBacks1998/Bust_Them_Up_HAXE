package input;

import openfl.display.DisplayObjectContainer;
import input.IInput.InputChangeEvent;
import openfl.events.EventDispatcher;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.ui.Keyboard;
import openfl.Lib;

import input.IInput.InputState;

class InputKeyboard extends EventDispatcher implements IInput {
    private var bLeft = false;
    private var bRight = false;
    private var bUp = false;
    private var bDown = false;
    public var state:InputState = new InputState();

    public function new(stage:DisplayObjectContainer) {
        super();

        Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
    }

    private function onKeyDown(event: KeyboardEvent): Void {
        switch (event.keyCode) {
            case Keyboard.W:
                bUp = true;
                //break;
            case Keyboard.A:
                bLeft = true;
                //break;
            case Keyboard.S:
                bDown = true;
                //break;
            case Keyboard.D:
                bRight = true;
                //break;
            case Keyboard.SPACE:
                state.jumpKeyPressed = true;
                //break;
        }
    
        state.moveDirection.setTo(0, 0);
        if (bUp) state.moveDirection.y --;
        if (bDown) state.moveDirection.y ++;
        if (bLeft) state.moveDirection.x --;
        if (bRight) state.moveDirection.x ++;
        
        var total = Math.abs(state.moveDirection.x) + Math.abs(state.moveDirection.y);
        if (total != 0) {
            state.moveDirection.x /= total;
            state.moveDirection.y /= total;
        }
    
        dispatchChangeEvent(InputChangeEvent.UPDATE, state);
    }
    
    private function onKeyUp(event: KeyboardEvent): Void {
        switch (event.keyCode) {
            case Keyboard.W:
                bUp = false;
                //break;
            case Keyboard.A:
                bLeft = false;
                //break;
            case Keyboard.S:
                bDown = false;
                //break;
            case Keyboard.D:
                bRight = false;
                //break;
            case Keyboard.SPACE:
                state.jumpKeyPressed = false;
                //break;
        }
        
        state.moveDirection.setTo(0, 0);
        if (bUp) state.moveDirection.y --;
        if (bDown) state.moveDirection.y ++;
        if (bLeft) state.moveDirection.x --;
        if (bRight) state.moveDirection.x ++;
    
        var total = Math.abs(state.moveDirection.x) + Math.abs(state.moveDirection.y);
        if (total != 0) {
            state.moveDirection.x /= total;
            state.moveDirection.y /= total;
        }
    
        dispatchChangeEvent(InputChangeEvent.UPDATE, state);
    }    

    private function onMouseDown(event: MouseEvent): Void {
        if (event.type == MouseEvent.MOUSE_DOWN) {
            state.attackKeyPressed = true;
        }
        
        dispatchChangeEvent(InputChangeEvent.UPDATE, state);
    }
    
    private function onMouseUp(event: MouseEvent): Void {
        if (event.type == MouseEvent.MOUSE_UP) {
            state.attackKeyPressed = false;
        }
        
        //trace("UP", event.type, MouseEvent.MOUSE_UP);

        dispatchChangeEvent(InputChangeEvent.UPDATE, state);
    }

    private function dispatchChangeEvent(type:String, state:InputState):Void {
        var event:InputChangeEvent = new InputChangeEvent(type, state);
        dispatchEvent(event);
    }

    public function getMoveDirection(d: Point): Void {
        /*
        var total = Math.abs(state.moveDirection.x) + Math.abs(state.moveDirection.y);
        d.x = state.moveDirection.x / total;
        d.y = state.moveDirection.y / total;

        d.x = (Math.isNaN(d.x)) ? 0 : d.x;
        d.y = (Math.isNaN(d.y)) ? 0 : d.y;
        */

        d.setTo(state.moveDirection.x, state.moveDirection.y);
    }

    public function isAttack(): Int {
        return (state.attackKeyPressed) ? 1 : 0;
    }

    public function isJump(): Bool {
        return state.jumpKeyPressed;
    }

    public function getDispatcher():EventDispatcher {
        return this;
    }
}
