package core.models;

import core.pattern.observer.Observable;

using core.pattern.observer.ObservableExtender;

class Figure implements Observable {
    public var blocks(default, null): Array<Block>;
    private var originPos: Int;
    private var shouldRotate: Bool;

    /**
     * Creates a figure which can move the given blocks
     * @param blocks the blocks wich defines that figure
     * @param originPos the block's position in the array. This figure gets rotated around that block
     * @param shouldRotate should this figure be able to rotate (maybe not for squares)
     */
    public function new(blocks: Array<Block>, originPos: Int = 0, shouldRotate: Bool = true) {
        this.blocks = blocks;
        this.originPos = originPos;
        this.shouldRotate = shouldRotate;
    }

    public function rotate(): Void {
        if (!shouldRotate) return;

        var origin: Block = blocks[originPos];

        for (i in 0...blocks.length) {
            var block = blocks[i];
            // block.setPosition(block.x + (origin.y - block.y), block.y - (origin.x - block.x));

            // its simply a normal vector rotation to the right
            // origin is the block of the figure. This figure gets rotated around this block
            // the new positions of the blocks (based on the origins), are added to the origin's position
            // block.setPosition(origin.x + (origin.y - block.y), origin.y - (origin.x - block.x));

            // a simpler version of the above formula
            block.setPosition(origin.x + origin.y - block.y, origin.y - origin.x + block.x);
        }

        // this.notify(null);
    }

    public function moveDown()
        for (block in blocks)
            block.setPosition(block.x, block.y + 1);
    
    public function moveLeft()
        for (block in blocks)
            block.setPosition(block.x - 1, block.y);

    public function moveRight()
        for (block in blocks)
            block.setPosition(block.x + 1, block.y);
}