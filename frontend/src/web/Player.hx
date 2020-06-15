package web;

import core.contracts.Placeable;
import view.Color;
import logic.FigureBuilder;
import hxd.Key;
import logic.GameFieldChecker;
import view.ColorProvidable;
import view.LocalColorProvider;
import core.models.Figure;
import h2d.Text;
import view.BlockTilePool;
import logic.BlockPool;

class Player {
    public var playerId(default,default): Int;

    private var parent: h2d.Object;
    private var tf: Text;

    private var pool = new BlockPool();
    private var tilePool = new BlockTilePool();
    private var colorProvider: ColorProvidable;
    private var nextColor: Color;

    private var lost: Bool = false;

    public function new(colorProvider: ColorProvidable, parent: h2d.Object){
        this.parent = parent;
        this.tf = new h2d.Text(hxd.res.DefaultFont.get(), parent);
        this.colorProvider = colorProvider;

        // every time a new block is added to the game field
        // this block will added to a block tile (which displays the block)
        pool.onAdded = block -> tilePool
            .getBlockTile(block, parent)
            .setOffset(5)
            .withColor(nextColor)
            .setBlock(block)
            .show();

        pool.onFreed = block -> tilePool.freeOf(block);
        nextColor = colorProvider.getNextColor();
    }

    public function update() {
    }

    public function init() {
    }
}