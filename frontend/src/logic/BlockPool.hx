package logic;

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
        // we geneare a new one
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
        var blocksOfRow = usedBlocks.filter((block) -> block.x == row);
        for(block in blocksOfRow){
            usedBlocks.remove(block);
            freeBlocks.push(block);
            onFreed(block);
        }
    }

    public dynamic function onAdded(block: Block) { }
    public dynamic function onFreed(block: Block) { }
}