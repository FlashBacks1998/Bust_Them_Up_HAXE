package luahx;
 
typedef LuaVariable = {
    var name:String;
    var value:Dynamic;
}

class LuaInstance {
    public var variables:Array<LuaVariable> = [];       //Variables
    public var logic:Array<Dynamic> = [];               //Logic

    public function new(luacode:String) {
        logic=parseLua(luacode);
    }

    public function execute() {
        for (expr in logic)
            expr();
    }

    public function getVar(name:String):Dynamic {
        for (variable in variables) {
            //////trace("FIND", "'" + variable.name + "'", "'" + name + "'", (variable.name == name) ? 't' : 'f');
            if (variable.name == name) {
                return variable.value;
            }
        }
        // Return null if the variable is not found
        return null;
    }

    /* v1, works with test001
    public function parseVariableLogic(logic:String):Dynamic {
        //TODO: return the logic or whatever the code was
        //NOTE: the variable names are not just `a` and `b` actually get the logic
        //ex, if logic = "10" return 10
        //ex, if logic = "15" return 5
        //ex, if logic = "a % 10"; find the value `a` in variables, then mod it by 10
        //ex, if logic = "b - 10"; find the value `b` in variables, then subtract it by 10
        //ex, if logic = "b - atest"; find the value `b` in variables, then get `atest`, then subtract a from b
        //ex, if logic = "a - b / a"; find the value `a` in variables, then get `a`, then subtract `a` from `b. Then with the total divide by `a`

        //////trace("VAR LOGIC", logic);

        // Check if the logic is a number
        var num:Float = Std.parseFloat(logic);
        if (!Math.isNaN(num)) {
            var rounded:Float = Math.floor(num);
            if (rounded == num) {
                return Std.int(num); // Return as an integer
            } else {
                return num; // Return as a float
            }
        }        

        var tokens = logic.split(' ');
        var todo:Dynamic = null;
        var total:Dynamic = null;

        //for(token in tokens)
        var i:Int = 0;
        while(i < tokens.length)
        {
            var token = tokens[i];

            //////trace("token", token);

            if(token == '')  {
                i++;
                continue;
            }
            if(token == null) {
                //////trace("VAR", "WARNING: the token is null???");
                i++;
                continue;
            }

            if(token == '+' || token == '-' || token == '/' || token == "*" || token == "%" || token == "^")
            {
                todo = token;
                i++;
                continue;
            }

            var v:Dynamic = null;
 
            // Check if the token is a string
            if (token.charAt(0) == '\'' || token.charAt(0) == '"') {
                var s = token.charAt(0);
                var fullstring = "";
                token = token.substring(1, token.length);
            
                //////trace("S start", token, fullstring, s);

                while (i < tokens.length) { 
                    //////trace("S loop", token, fullstring, s);

                    if (token.charAt(token.length - 1) == s) {
                        fullstring += ' ' + token.substring(0, token.length - 1); 
                        break;
                    }
                    else {
                        fullstring += ' ' + token;
                        i++;
                        token = tokens[i];
                    }
                }
                
                //////trace("S ENB", token, fullstring, s);

                v = fullstring;
            }

            //Else get the variable from the map
            else
            {
                //////trace("V IS VAR");
                v = getVar(token);
            }

            //////trace("Checking conditions...");
            if(todo != "" && v == null)
                throw "LUA: Variable '" + token + "' not found with nothing todo"; // Throw an error message 

            //////trace("SWITCH");
            switch todo {
                    case '+':
                        total += v;
                        todo = "";
                    case '-':
                        total -= v;
                        todo = "";
                    case '/':
                        total /= v;
                        todo = "";
                    case '*':
                        total *= v;
                        todo = "";
                    case '^': 
                        total = Math.pow(total, v);
                        todo = "";
                    case '%':
                        total %= v;
                        todo = "";
                    case null:
                        total = v;
                    default:
                        throw "LUA: unknown logic '" + todo + "' not found"; // Throw an error message 
            }
            
            i++;
        }

        return total;
    }

    public function parseVariable(tokens:Array<String>, i:Int):LuaVariable {
        var variable:LuaVariable = { name: "", value: null };
    
        i++;
    
        // Get the variable name 
        while (i < tokens.length && tokens[i] == "") {
            i++;
            //////trace("EMPTY", tokens[i]);
        }
        variable.name = tokens[i];
        //////trace("NAME", tokens[i], variable.name);
    
        // Find the `=` (if it exists) 
        while (i < tokens.length && tokens[i] != "=") {
            i++;
            //////trace("EMPTY");
        }
    
        if (tokens[i] == '=') {
            var value:String = tokens.slice(i + 1).join(" ");
            variable.value = value;
        } else {
            variable.value = null;
        }
    
        //////trace("NEW VAR", variable.name, variable.value);

        return variable;
    }    

    public function parse(luacode:String) {
        var lines = luacode.split('\r\n').filter(function(element:String) return element != null && element != "");


        var il:Int = 0;
        //for (line in luacode.split('\r\n')){
        while (il<lines.length) {
            var line = lines[il];
            var tokens = line.split(' ');
            //tokens = tokens.filter(function(element:String) return element != null && element != "");


            var i:Int = 0;
            while (i < tokens.length && tokens[i] == "") {
                i++; 
            } 

            var getFunctionCode = function () {

            }

            //Switch statement
            switch tokens[i] {
                case "local":                                   // Save the variable with the given name and value to `variables` 
                    //Get the var name
                    while (i < tokens.length && tokens[i] == "") i++;     
                
                    if (tokens[i] == null) {
                        throw "LUA: The line `" + line + "` is not valid! `local` was used but no name was given!";
                    }
                    if (tokens[i] == "function"){               //We want to save a function
                        //TODO: create a new functon to variales
                    }
                    else {
                        var v = parseVariable(tokens, i);       //We want to save a variable
                        logic.push(function() {
                            variables.push({ name: v.name, value: parseVariableLogic(v.value) });

                            //for(variable in variables)
                                ////trace("VAR", variable.name, variable.value);
                        });
                    }
                
                case "function":
                    //TOOD: create a new function to variables

                default:
                    //TODO: handle logic
            }

            il++;
        }
    }*/

    //Assuming syntax is `local varname = value`
    public function parseVariableGetLogic(luaLine:String):Void->Dynamic  {
        var sides = luaLine.split('=').filter(function(element:String) return element != null && element != "");

        ///---If there is no rhs there is no value logic to the variable---
        if(sides.length == 1)
            return function () { return null; };

        ///---Get the variable value---

        //Step 1; Check if the logic is a number
        var num:Float = Std.parseFloat(sides[1]);
        if (!Math.isNaN(num)) {
            var rounded:Float = Math.floor(num);
            if (rounded == num) {
                //return Std.int(num); // Return as an integer
                var raw = Std.int(num);
                return function () {return raw;}
            } else {
                return function () {return num;}
            }
        }        

        //Step 2; parse the logic
        var rhsTokens = sides[1].split(' ').filter(function(element:String) return element != null && element != ""); 
 
        var total:Dynamic = null;
        var todo:String = null;
        var logic:Array<Dynamic> = [];
        for(token in rhsTokens) {
            //trace("parseVariableGetLogic",  "TOKEN", token); 

            //Check if we are at a math logic
            if(token == '+' || token == "-" || token == '*' || token == '/' || token == "*" || token == '^' || token == '%')
            {
                todo = token;
                continue;
            }

            //Check if we have a todo
            if(todo == 'done')
                throw "LUA: the line `" + luaLine + "` is invalid! The logic is missing a todo";

            //Now parse the logic
            switch todo {
                case null:
                    var vname = token; //clone the variale name

                    logic.push(function () {
                        //Get the variable we want to add onto
                        var rhsv:Dynamic = getVar(vname);
                        var rhsvClone:Dynamic = rhsv;

                        //Check if var is valid
                        if(rhsv == null)
                            throw "LUA: the line `" + luaLine + "` is invalid! The the variale `" + rhsv + "` is missin or null!";

                        total = rhsvClone;
                    });

                    todo = 'done';
                
                case '+':
                    var vname = token; //clone the variale name

                    logic.push(function () {
                        //Get the variable we want to add onto
                        var rhsv:Dynamic = getVar(vname);
                        var rhsvClone:Dynamic = rhsv;

                        //Check if var is valid
                        if(rhsv == null)
                            throw "LUA: the line `" + luaLine + "` is invalid! The the variale `" + rhsv + "` is missin or null!";
                        total += rhsvClone;
                    });

                    todo = 'done';
                    
                case '-':
                    var vname = token; //clone the variale name

                    logic.push(function () {
                        //Get the variable we want to add onto
                        var rhsv:Dynamic = getVar(vname);
                        var rhsvClone:Dynamic = rhsv;

                        //Check if var is valid
                        if(rhsv == null)
                            throw "LUA: the line `" + luaLine + "` is invalid! The the variale `" + rhsv + "` is missin or null!";
                        total -= rhsvClone;
                    });

                    todo = 'done';
                    
                case '*':
                    var vname = token; //clone the variale name

                    logic.push(function () {
                        //Get the variable we want to add onto
                        var rhsv:Dynamic = getVar(vname);
                        var rhsvClone:Dynamic = rhsv;

                        //Check if var is valid
                        if(rhsv == null)
                            throw "LUA: the line `" + luaLine + "` is invalid! The the variale `" + rhsv + "` is missin or null!";
                        total *= rhsvClone;
                    });

                    todo = 'done';
                    
                case '/':
                    var vname = token; //clone the variale name

                    logic.push(function () {
                        //Get the variable we want to add onto
                        var rhsv:Dynamic = getVar(vname);
                        var rhsvClone:Dynamic = rhsv;

                        //Check if var is valid
                        if(rhsv == null)
                            throw "LUA: the line `" + luaLine + "` is invalid! The the variale `" + rhsv + "` is missin or null!";
                        total /= rhsvClone;
                    });

                    todo = 'done';

                case '%':
                    var vname = token; //clone the variale name

                    logic.push(function () {
                        //Get the variable we want to add onto
                        var rhsv:Dynamic = getVar(vname);
                        var rhsvClone:Dynamic = rhsv;

                        //Check if var is valid
                        if(rhsv == null)
                            throw "LUA: the line `" + luaLine + "` is invalid! The the variale `" + rhsv + "` is missin or null!";
                        total %= rhsvClone;
                    });

                    
                case '^':
                    var vname = token; //clone the variale name

                    logic.push(function () {
                        //Get the variable we want to add onto
                        var rhsv:Dynamic = getVar(vname);
                        var rhsvClone:Dynamic = rhsv;

                        //Check if var is valid
                        if(rhsv == null)
                            throw "LUA: the line `" + luaLine + "` is invalid! The the variale `" + rhsv + "` is missin or null!";
                        total = Math.pow(total,rhsvClone);
                    });

                    todo = 'done';
                    
                default:
                    //trace("Unsupported operation: " + todo);
            }
        }

        return function () {
            total = null;
            for(expr in logic)
                expr();

            return total;
        }
    }

    public function parseLua(luaCode:String):Array<Dynamic> {
        var lines = luaCode.split('\r\n').filter(function(element:String) return element != null && element != "");

        var linesIndex:Int = 0;
        var logic:Array<Dynamic> = [];

        while (linesIndex<lines.length) {
            var line = lines[linesIndex];
            var tokens = line.split(' ').filter(function(element:String) return element != null && element != "");

        
            //trace("LUA Parsing", linesIndex, line, tokens);

            switch (tokens[0]) {
                case "local":
                    //NOTE: variableLogic is a function 
                    var variableLogic = parseVariableGetLogic(line);

                    logic.push(function () {
                        var value = variableLogic();
                        //trace("new var", tokens[1], value);
                        variables.push({name:tokens[1], value: value});

                        //for (varr in variables)
                            //trace(varr.name, varr.value);
                    });

                case "function":
                    

                default:
                    
            }

            linesIndex++;
        }

        return logic;
    }
}
