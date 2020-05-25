package logic;

import core.pattern.observer.Observable;
import core.models.Block;

using utils.ArrayTools;

class BlockPool implements Observable {
    /**
     * Blocks, which are currently used
     */
    private var blocks: Array<Block> = [];

    /**
     * Blocks, which are ready for use
     */
    private var freeBlocks: Array<Block> = [];

    private var addCallback: Null<(Block -> Void)>;
    private var removeCallback: Null<(Block -> Void)>;

    public function new() {
        
    }

    public function getBlock(): Block {
        var block: Block = freeBlocks.isEmpty()
            ? new Block(0, 0)
            : freeBlocks.pop();

        blocks.push(block);
        if (addCallback != null) addCallback(block);
        return block;
    }

    // public function getBlock(x: Int, y: Int): Block {
    //     var block: Block = freeBlocks.isEmpty()
    //         ? new Block(0, 0)
    //         : freeBlocks.pop();

    //     block.x = x;
    //     block.y = y;

    //     blocks.push(block);
    //     if (addCallback != null) addCallback(block);
    //     return block;
    // }

    public function free(block: Block) {
        var result: Bool = blocks.remove(block);
        if (!result) throw 'there is no block';
        freeBlocks.push(block);
        if (removeCallback != null) removeCallback(block);
    }

    public function setAddListener(l: Block -> Void) {
        addCallback = l;
    }

    public function setRemoveListener(l: Block -> Void) {
        removeCallback = l;
    }
}