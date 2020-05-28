package core.pattern.observer;

class ObservableExtender {
    static private var observalbes: Map<Observable, Array<Observer>> = new Map();

    static public function addObserver(obj: Observable, observer: Observer) {
        if (!observalbes.exists(obj))
            observalbes[obj] = new Array<Observer>();

        observalbes[obj].push(observer);
    }

    static public function notify(obj: Observable, ?data: Any) {
        if (observalbes.exists(obj))
            for (obs in observalbes[obj])
                obs.update(obj, data);
    }

    static public function removeObserver(obj: Observable, observer: Observer): Bool {
        if (observalbes.exists(obj)) {
            return observalbes[obj].remove(observer);
        }

        return false;
    }
}