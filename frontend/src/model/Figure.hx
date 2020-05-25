package model;

import pattern.observer.Observable;

using pattern.observer.ObservableExtender;

class Figure implements Observable {
    public var blocks(default, null): Array<Block>;

    public function new(blocks: Array<Block>) {
        this.blocks = blocks;
    }

    public function rotate(): Void {
        // Todo
        this.notify(null);
    }

    public function moveDown() {
        for (block in blocks) {
            block.y += 1;
        }
    }
}