package input;

import openfl.events.EventDispatcher;
import openfl.events.Event;
import openfl.geom.Point;

class InputState {
    public var moveDirection: Point = new Point();
    public var attackKeyPressed: Bool = false;
    public var jumpKeyPressed: Bool = false;

    public function new() { }
}

class InputChangeEvent extends Event {
    public static inline var UPDATE:String  = "INPUTCHANGEEVNET_UPDATE";
    public static inline var MOVE:String    = "INPUTCHANGEEVNET_MOVE";
    public static inline var ATTACK:String  = "INPUTCHANGEEVNET_ATTACK";
    public static inline var JUMP:String    = "INPUTCHANGEEVNET_JUMP";

    public var state:InputState = null;

    public function new(type:String, state:InputState) {
        super(type, false, false);
        
        this.state = state;
    }
}

interface IInput{
    // Returns an integer representing the direction (p for the reference direction)
    function getMoveDirection(d:Point): Void;

    // Returns true if the attack button is pressed, false otherwise
    function isAttack(): Int;

    // Returns true if the jump button is pressed, false otherwise
    function isJump(): Bool;

    function getDispatcher():EventDispatcher;
} 
