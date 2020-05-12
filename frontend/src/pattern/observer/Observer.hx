package pattern.observer;

interface Observer {
    public function update(sender: Observable, ?data: Any): Void;
}