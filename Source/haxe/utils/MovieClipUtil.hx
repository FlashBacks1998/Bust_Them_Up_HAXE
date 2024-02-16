package utils;
 
import openfl.Lib;
import openfl.events.TimerEvent;
import openfl.events.Event;
import openfl.utils.Timer;
import openfl.display.MovieClip;
import openfl.display.SimpleButton;

class MovieClipUtil {
    public static var DEFAULT_FPS = 30;
    public static var timers:Array<Timer> = [];

    public static function findButton(container: openfl.display.DisplayObjectContainer, instanceName:String = ""): SimpleButton {
        var button: SimpleButton = null;

        //trace("findButton", container, instanceName);

        for (i in 0...container.numChildren) {	//faster than for each
            var child = container.getChildAt(i);
            //trace(child, child.name, instanceName);
            if (child is SimpleButton && child.name == instanceName) {
                button = cast(child, SimpleButton);
                break;
            } /*else if (child is openfl.display.DisplayObjectContainer) {
                button = findButton(cast(child, openfl.display.DisplayObjectContainer), instanceName); //recursion
                if (button != null) {
                    break;
                }
            }*/

            try{
                button = findButton(cast(child, openfl.display.DisplayObjectContainer), instanceName); //recursion
                if (button != null) {
                    break;
                }
            }catch (e:Dynamic) {
                // Do nothing, continue with the loop
            }
        }
        return button;
    }

    public static function findMovieClip(container: openfl.display.DisplayObjectContainer, instanceName:String = ""): MovieClip {
        var mc: MovieClip = null;

        //trace("findMovieClip", container, instanceName);

        for (i in 0...container.numChildren) {	//faster than for each
            var child = container.getChildAt(i);
            //trace(child, child.name, instanceName);
            if (child is MovieClip && child.name == instanceName) {
                mc = cast(child, MovieClip);
                break;
            }/* else if (child is openfl.display.DisplayObjectContainer ) {
                mc = findMovieClip(cast(child, openfl.display.DisplayObjectContainer), instanceName); //recursion
                if (mc != null) {
                    break;
                }
            }*/

            try{
                mc = findMovieClip(cast(child, openfl.display.DisplayObjectContainer), instanceName); //recursion
                if (mc != null) {
                    break;
                }
            }catch (e:Dynamic) {
                // Do nothing, continue with the loop
            }
        }
        return mc;
    }

    public static function refineMovieclip(mc:MovieClip, ?options:{?fps:Int, ?startingFrame:Int, ?repeat:Bool}) {
        final fps:Int = options?.fps != null ? options.fps : DEFAULT_FPS;                           // The fps to set the MovieClip
        
        //1.5 if the fps is -1 dont setup timer
        if(fps<=0) 
            return mc;
        
        final startingFrame:Int = options?.startingFrame != null ? options.startingFrame : 1;       // The starting frame
        final frameDuration:Int = Std.int(1000 / fps);
        final timer:Timer = new Timer(frameDuration);                                               // Create the timer
        final repeat:Bool = options?.repeat != null ? options.repeat : false;

        //Step 1: go to the first frame
        mc.gotoAndStop(startingFrame);

        //Setp 2: define the timer function
        var timeStart = Lib.getTimer();
        var timerTick = function (e:TimerEvent):Void {
            final duration = Lib.getTimer() - timeStart;
            final position = Std.int(duration / frameDuration);
            final frame = repeat ? (position % mc.totalFrames) : Math.min(position, mc.totalFrames);
            
            mc.gotoAndStop(frame + 1);
            //trace(mc.currentFrame, frame, );
        }

        //Step 3: add start timer code to first frame
        mc.addEventListener(Event.ADDED_TO_STAGE, function (e:Event):Void {
            timeStart = Lib.getTimer();
            timer.addEventListener(TimerEvent.TIMER, timerTick);
            timer.start();
        });

        //Step 4: push the timer
        timers.push(timer);                                                                         // Prevent neko trash collection
 
        return mc;
    }

    /*
    public static function setFps(mc:MovieClip, ?options:{?fps:Int, ?loop:Bool, ?reset:Bool, ?indefinite:Bool, ?callback:Void->Void, ?callbacks:Array<{func:Void->Void, frame:Int}>}) {
        // Get the options
        final fps:Int = options?.fps != null ? options.fps : DEFAULT_FPS;
        final loop:Bool = options?.loop != null ? options.loop : true; 
        final callbakcs:Array<{func:Void->Void, frame:Int}> = options?.callbacks != null ? options.callbacks : [];
        final reset:Bool = options?.reset != null ? options.reset : false;
        final timer:Timer = new Timer(1000 / fps);
        final indefinite:Bool = options?.indefinite != null ? options.indefinite : false;
        final frameDuration:Int = Std.int(1000 / fps);
        var timeStart:Int = 0;

        timers.push(timer); // Prevent neko trash collection

        var timerSetup = function ():Void {
            mc.gotoAndStop(1);
        }

        var timerStop = function (e:Event = null):Void {
            timer.stop();
            //TODO: Better way to remove the timer
            //timer = null;
        }

        var timerTick = function (e:TimerEvent):Void {
            var frame = 0;

            if (mc.currentFrame >= mc.totalFrames) {
                //if (callback != null) callback();
                if (loop) {
                    mc.gotoAndStop(1);
                } else {
                    timerStop();
                }
            } else {
                final duration = Lib.getTimer() - timeStart;
                final position = Std.int(duration / frameDuration);
                frame = position % mc.totalFrames;
                
                mc.gotoAndStop(frame + 1);
                trace(mc.currentFrame, frame, );
            }
            
            //TODO: Mabey use EventDispatcher instead of callbacks
            for (callback in callbakcs) 
                {
                    trace("callback", frame, callback.frame, callback.func);

                    if (frame == callback.frame) 
                        callback.func();
                }

        }

        var timerStart = function (e:Event):Void {
            timeStart = Lib.getTimer();
            timer.addEventListener(TimerEvent.TIMER, timerTick);
            timer.start();
        }

        timerSetup();

        mc.addEventListener(Event.ADDED_TO_STAGE, timerStart);
        if (!indefinite) mc.addEventListener(Event.REMOVED_FROM_STAGE, timerStop);

        return mc;
    }
    */

}