package view;

import core.pattern.observer.Observable;
import core.pattern.observer.Observer;
import h2d.Bitmap;
import h2d.Object;
import hxd.Res;
import h2d.Tile;
import core.models.Block;

using core.pattern.observer.ObservableExtender;

class BlockTile implements Observer {
    private var block: Block;
    private var tile: Tile;
    private var b: Bitmap;

    public function new(block: Block, parent: Object) {
        this.block = block;
        block.addObserver(this);
        tile = Res.sp.toTile();
        // tile.setPosition(block.x * tile.width, block.y * tile.height);
        b = new Bitmap(tile, parent);
        b.setPosition(block.x * tile.width, block.y * tile.height);
    }

    public function update(sender: Observable, ?data: Any): Void {
        // check if data is a block
        var block = (data : Block);
        b.setPosition(block.x * tile.width, block.y * tile.height);
    }
}