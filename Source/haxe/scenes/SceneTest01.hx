package scenes;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.events.Event;
import openfl.Lib;
import luahx.LuaInstance;
 
class SceneTest01 extends Sprite { 

    public function new() {
        super(); 

        var luaCode:String = "
        local a = 10 
        local b = 5 
        local sum = a + b 
        local difference = a - b 
        local product = a * b 
        local quotient = a / b 
        local exponent = a ^ b 
        local remainder = a % b
        local hugeform = a + b - a * b / a ^ b % a
    ";

        var test:LuaInstance  = new LuaInstance (luaCode);
        var start = Lib.getTimer();
        test.execute();
        var executionTime = Lib.getTimer() - start;
        trace("LUA EXEC TIME", executionTime);

        // Create a TextField to display execution time
        var timeLabel:TextField = new TextField();
        timeLabel.width = 400;
        timeLabel.height = 400;
        timeLabel.text = "Execution Time: " + executionTime + " ms";
        timeLabel.x = 16;
        timeLabel.y = 16;

        // Add the TextField to the stage
        addChild(timeLabel);

        for(variable in test.variables)
            timeLabel.text += "\n" + "VAR " + variable.name + "," + variable.value;
    } 
}
