package logic;

import core.pattern.observer.Observer;
import core.pattern.observer.Observable;
import core.models.Block;

using utils.ArrayTools;

class BlockPool implements Observable 
                implements Observer {
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

    //BlockPool gets notified by GameFieldChecker once at least one row is full
    //The BlockPool then proceeds to free the cleared Rows
    public function update(sender: Observable, ?data: Any){
        if(Type.getClassName(Type.getClass(sender)) == "logic.GameFieldChecker"){
            trace("Rows are full " + data);
            var rows: Array<Bool> = cast data;
            for(i in 0...rows.length)
                if(rows[i])
                    freeRow(i);
        }
    }

    public dynamic function onAdded(block: Block) { }
    public dynamic function onFreed(block: Block) { }
}