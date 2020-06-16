package core.models;

import core.pattern.observer.Observable;

using core.pattern.observer.ObservableExtender;

class Block implements Observable {
    
    public var x(default, null): Int;
    public var y(default, null): Int;

    public function new(x: Int = 0, y: Int = 0) {
        this.x = x;
        this.y = y;
    }

    public function setPosition(x: Int, y: Int) {
        this.x = x;
        this.y = y;
        this.notify(this);
    }

    public function withPosition(x: Int, y: Int): Block {
        setPosition(x, y);
        return this;
    }

    public inline function toString(): String {
        return 'Block { $x, $y }';
    }
}