package logic;

import core.pattern.observer.Observable;

using core.pattern.observer.ObservableExtender;

class Score implements Observable {

    private static var instance: Score = null;

    public static function getInstance() {
        if (instance == null)
            instance = new Score();

        return instance;
    }

    private function new() {
    }

    public var score(default, null): Int = 0;

    public function addScore(amount: Int): Void {
        score += amount;
        this.notify();
    }
        
}