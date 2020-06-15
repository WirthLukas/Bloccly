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
    private var offsetX: Int;
    private var offsetY: Int;

    public function new(parent: Object) {
        // tile.setPosition(block.x * tile.width, block.y * tile.height);
        b = new Bitmap(null, parent);
    }

    public function setBlock(block: Block): BlockTile {
        this.block = block;
        block.addObserver(this);
        b.setPosition(offsetX + block.x * tile.width, offsetY + block.y * tile.height);
        return this;
    }

    public function setOffset(x: Int = 0, y: Int = 0) {
        offsetX = x;
        offsetY = y;
        return this;
    }

    public function withColor(color: Color): BlockTile {
        tile = (switch color {
            case Orange: Res.orange;
            case Cyan: Res.cyan;
            case Blue: Res.blue;
            case Green: Res.green;
            case Purple: Res.purple;
            case Red: Res.red;
            case Yellow: Res.yellow;
            default: throw "No such type available";
        }).toTile();
        b.tile = tile;
        return this;
    }

    public function show()
        b.visible = true;

    public function update(sender: Observable, ?data: Any): Void {
        // check if data is a block
        var block = (data : Block);
        b.setPosition(offsetX + block.x * tile.width, offsetY + block.y * tile.height);
    }

    public function hide()
        b.visible = false;
}