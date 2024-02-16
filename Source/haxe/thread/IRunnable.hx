package thread;

//SRC https://bitsofinfo.wordpress.com/2008/09/22/threads-in-as3-flex-actionscript/

/**
 * An IRunnable is to be used with PseudoThread which
 * will call an IRunnable's process() method repeatedly
 * until a timeout is reached or the isComplete() method returns
 * true.
 * 
 * @see PseudoThread
 */
interface IRunnable {
     
    /**
     * Called repeatedly by PseudoThread until
     * a timeout is reached or isComplete() returns true.
     * Implementors should implement their functioning
     * code that does actual work within this method
     */
    public function process(): Void;
     
    /**
     * Called by PseudoThread after each successful call
     * to process(). Once this returns true, the thread will
     * stop.
     *
     * @return  boolean true/false if the work is done and no further
     *          calls to process() should be made
     */
    public function isComplete(): Bool;
     
    /**
     * Returns an int which represents the total
     * amount of "work" to be done.
     * 
     * @return  Int total amount of work to be done
     */
    public function getTotal(): Int;
     
    /**
     * Returns an int which represents the total amount
     * of work processed so far out of the overall total
     * returned by getTotal()
     * 
     * @return  Int total amount of work processed so far
     */
    public function getProgress(): Int;
}
