package logic;

import model.Block;

using utils.ArrayTools;

class BlockPool {
    /**
     * Blocks, which are currently used
     */
    private var blocks: Array<Block> = [];

    /**
     * Blocks, which are ready for use
     */
    private var freeBlocks: Array<Block> = [];
    
    public function new() {
    }

    public function getBlock(): Block {
        var block: Block = freeBlocks.isEmpty()
            ? new Block(0, 0)
            : freeBlocks.pop();

        blocks.push(block);
        return block;
    }

    public function free(block: Block) {
        var result: Bool = blocks.remove(block);
        if (!result) throw 'there is no block';
        freeBlocks.push(block);
    }
}