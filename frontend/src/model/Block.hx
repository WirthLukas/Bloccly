package model;

import contracts.Placeable;

class Block {
    
    public var x: Int;
    public var y: Int;

    public inline function new(x: Int = 0, y: Int = 0) {
        this.x = x;
        this.y = y;
    }

    public inline function withPosition(x: Int, y: Int): Block {
        this.x = x;
        this.y = y;
        return this;
    }
}