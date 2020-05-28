package view;

import h2d.Object;
import core.models.Block;
using utils.ArrayTools;

class BlockTilePool {
    private var usedTiles: Array<BlockTile> = [];
    private var freeTiles: Array<BlockTile> = [];

    public function new() { }

    public function getBlockTile(block: Block, parent: h2d.Object): BlockTile {
        // if there are no free blocks, which could be used,
        // we geneare a new one
        var blockTile: BlockTile = freeTiles.isEmpty()
            ? new BlockTile(block, parent)
            : freeTiles.pop();

        usedTiles.push(blockTile);
        return blockTile;
    }

    public function free(block: BlockTile) {
        var result: Bool = usedTiles.remove(block);
        if (!result) throw 'there is no block';
        freeTiles.push(block);
    }
}