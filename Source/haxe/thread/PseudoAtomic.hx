package thread;

class PseudoAtomic<T> {
    private var value:T;
    private var lock:Bool = false;

    public function new(initialValue:T) {
        value = initialValue;
    }

    public function get():T {
        return value;
    }

    public function set(newValue:T):T {
        plock();
        var oldValue = value;
        value = newValue;
        punlock();
        return oldValue;
    }

    public function getAndSet(newValue:T):T {
        plock();
        var oldValue = value;
        value = newValue;
        punlock();
        return oldValue;
    }

    private function plock():Void {
        while (true) {
            if (!lock) {
                lock = true;
                return;
            }
        }
    }

    private function punlock():Void {
        lock = false;
    }
}
