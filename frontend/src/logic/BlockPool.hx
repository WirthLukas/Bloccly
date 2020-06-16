package logic;

import core.Constants;
import haxe.ds.ArraySort;
import core.pattern.observer.Observer;
import core.pattern.observer.Observable;
import core.models.Block;

using utils.ArrayTools;

class BlockPool implements Observable {
    /**
     * Blocks, which are currently used
     */
    public var usedBlocks(default, null): Array<Block> = [];

    /**
     * Blocks, which are ready for use
     */
    private var freeBlocks: Array<Block> = [];

    public function new() {}

    public function getBlock(): Block {
        // if there are no free blocks, which could be used,
        // we generate a new one
        var block: Block = freeBlocks.isEmpty()
            ? new Block(0, 0)
            : freeBlocks.pop();

        usedBlocks.push(block);
        onAdded(block);
        return block;
    }

    public function free(block: Block) {
        var result: Bool = usedBlocks.remove(block);
        if (!result) throw 'there is no block';
        freeBlocks.push(block);
        onFreed(block);
    }

    public function freeRow(row: Int){
        var blocksOfRow = usedBlocks.filter(block -> block.y == row);
        for(block in blocksOfRow){
            free(block);
        }
    }

    /**
     * [Description]
     * @param moving all blocks, that are positioned above this row
     * @param dx amount to move in the horizontal direction (negative values means moving to the left)
     * @param dy amount to move in the vertical direction (negative values means moving to the top)
     */
    public function moveAllBlocksAboveRow(row: Int, dx: Int, dy: Int): Void
        for (block in usedBlocks)
            if (block.y <= row && block.y != Constants.FIELD_HEIGHT)
                block.setPosition(block.x + dx, block.y + dy);

    public function getHighestBlockAtCol(col: Int) {
        var filtered = usedBlocks.filter(block -> block.y == col);
        ArraySort.sort(filtered, (b1, b2) -> b1.y - b2.y);
        return filtered.shift().x;
    }

    public function clear() {
        usedBlocks.forEach(block -> free(block));
    }
                
    public dynamic function onAdded(block: Block) { }
    public dynamic function onFreed(block: Block) { }
}