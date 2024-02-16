package math;

class Algorithm {
    public static function calculateSpringConstant(start:Float, end:Float, constant:Float):Float {
        var dist = end-start;
        var force = dist * constant;
        return force;
    }

    public static function clamp(x:Dynamic, min:Dynamic, max:Dynamic):Dynamic {
        return (x < min) ? min : (x > max) ? max : x;
    }
}