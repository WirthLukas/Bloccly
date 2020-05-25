package core.models;

import core.pattern.observer.Observable;

using core.pattern.observer.ObservableExtender;

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
            block.setPosition(block.x, block.y + 1);
        }
    }

    public function moveLeft() {
        for (block in blocks) {
            block.setPosition(block.x - 1, block.y);
        }
    }

    public function moveRight() {
        for (block in blocks) {
            block.setPosition(block.x + 1, block.y);
        }
    }
}