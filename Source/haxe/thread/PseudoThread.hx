package thread;

import haxe.Exception;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.ProgressEvent;
import openfl.utils.Timer;
import openfl.events.TimerEvent; // Add this import statement


/**
 * Dispatched when the thread's work is done
 */
@:eventType("openfl.events.Event.COMPLETE")
class ThreadComplete extends Event {}

/**
 * Dispatched when the thread encounters an error or if the Thread times out
 */
@:eventType("openfl.events.ErrorEvent.ERROR")
class ThreadError extends ErrorEvent {
    public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "") {
        super(type, bubbles, cancelable, text);
    }
}

/**
 * Dispatched when the thread's work makes progress
 */
@:eventType("openfl.events.ProgressEvent.PROGRESS")
class ThreadProgress extends ProgressEvent {
    public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, bytesLoaded:Int = 0, bytesTotal:Int = 0) {
        super(type, bubbles, cancelable, bytesLoaded, bytesTotal);
    }
}

/**
 * This class simulates a thread in Haxe
 */
class PseudoThread extends EventDispatcher {
     
    // the timer which is the core of our PseudoThread
    private var intTimer:Timer = null;
     
    // total times we have ran
    private var totalTimesRan:Int = 0;
     
    // default max runtimes is forever
    private var maxRunTimes:Int = 0;
     
    // the IRunnable we are processing
    private var runnable:IRunnable = null;
     
    // a unique name for me
    private var myName:String;
 
         
     
    /**
     * Constructor. 
     * 
     * @param   runnable            The IRunnable that this thread will process. The IRunnable's process()
     *                              method will be called repeatably by this thread.
     * 
     * @param   threadName          a name identifier
     * 
     * @param   msDelay             delay between each thread "execution" call of IRunnable.process(), in milliseconds
     * 
     * @param   msTimeout           the max amount of time this PseudoThread should run before it will 
     *                              stop processing and dispatch an ErrorEvent. If no timeout is specified
     *                              the process will run until the IRunnable reports that it is complete.
     */
    public function new(runnable:IRunnable, threadName:String, msDelay:Int = 200, msTimeout:Int = -1) {
        super();
        
        this.myName = threadName;
        this.runnable = runnable;

        if (msTimeout != -1) {
            if (msTimeout < msDelay) {
                throw new Exception("PseudoThread cannot be constructed with a timeoutMS that is less than the delayMS");
            }
            maxRunTimes = Math.ceil(msTimeout / msDelay);
        }

        this.intTimer = new Timer(msDelay, maxRunTimes);
        this.intTimer.addEventListener(TimerEvent.TIMER, processor);
    }
     
    /** 
     * Destroys this and deregisters from the Timer event
     */
    public function destroy():Void {
        this.intTimer.stop();
        this.intTimer.removeEventListener(TimerEvent.TIMER, processor);
        this.runnable = null;
        this.intTimer = null;
    }

    /**
     * Called each time our internal Timer executes. Here we call the runnable's process() function 
     * and then check the IRunnable's state to see if we are done. If we are done we dispatch a complete
     * event. If progress is made we dispatch progress, lastly on error, this will destroy itself 
     * and dispatch an ErrorEvent.
     * 
     * Note that an ErrorEvent will be thrown if a timeout was specified and we have reached it without
     * the IRunnable reporting isComplete() within the timeout period.
     * 
     * @throws ErrorEvent when the process() method encounters an error or if the timeout is reached.
     * @param   e TimerEvent
     */
    private function processor(e:TimerEvent):Void {
        try {
            this.runnable.process();
            this.totalTimesRan++;
             
        } catch (e:Dynamic) {
            destroy();
            this.dispatchEvent(new ThreadError(ErrorEvent.ERROR, false, false, "PsuedoThread [" + this.myName + "] encountered an error while calling the IRunnable.process() method: " + e.message));
            return;
        }
         
        if (runnable.isComplete()) {
            this.dispatchEvent(new ThreadComplete(Event.COMPLETE, false, false));
            destroy();
        } else {
             
            if (this.maxRunTimes != 0 && this.maxRunTimes == this.totalTimesRan) {
                destroy();
                this.dispatchEvent(new ThreadError(ErrorEvent.ERROR, false, false, "PsuedoThread [" + this.myName + "] timeout exceeded before IRunnable reported complete"));
                return;
                 
            } else {
                this.dispatchEvent(new ThreadProgress(ProgressEvent.PROGRESS, false, false, runnable.getProgress(), runnable.getTotal()));
            }
        }
    }

    /**
     * This method should be called when the thread is to start running and calling
     * it's IRunnable's process() method until work is finished.
     */
    public function start():Void {
        this.intTimer.start(); 
    }
}