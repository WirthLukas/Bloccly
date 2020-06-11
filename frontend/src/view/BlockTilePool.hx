package view;

import h2d.Object;
import core.models.Block;
using utils.ArrayTools;

class BlockTilePool {
    private var usedTiles: Map<Block, BlockTile> = [];
    private var freeTiles: Array<BlockTile> = [];

    public function new() { }

    public function getBlockTile(block: Block, parent: h2d.Object): BlockTile {
        // if there are no free blocks, which could be used,
        // we geneare a new one
        var blockTile: BlockTile = freeTiles.isEmpty()
            ? new BlockTile(parent)
            : freeTiles.pop();

        usedTiles.set(block, blockTile);
        return blockTile;
    }

    public function freeOf(block: Block) {
        if (!usedTiles.exists(block)) throw 'there is no mapping with that block';

        var blockTile = usedTiles[block];
        if (blockTile == null) throw 'wtf? i checked if it exists!';

        blockTile.hide();
        usedTiles.remove(block);
        freeTiles.push(blockTile);
    }
}