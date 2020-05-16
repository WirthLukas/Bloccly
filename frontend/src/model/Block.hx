package model;

import h2d.Tile;
import h2d.Bitmap;
import hxd.Res;
import pattern.observer.Observable;

using pattern.observer.ObservableExtender;

class Block implements Observable {
    
    public var x(get, set): Float;
    public var y(get, set): Float;

    private var image: Bitmap;

    public function new(type: BlockType, parent: h2d.Object) {
        image = new Bitmap(getTile(type), parent); 
        image.tile.setCenterRatio();
    }

    public function get_x(): Float return image.x;
    public function set_x(value: Float): Float {
        image.x = value;
        return image.x;
    }

    public function get_y(): Float return image.y;
    public function set_y(value: Float): Float {
        image.y = value;
        return image.y;
    }

    private function getTile(type: BlockType): Tile {
        var image = switch (type) {
            case BlockType.Orange: Res.block_orange;
            case BlockType.Green: Res.block_green;
            case BlockType.Blue: Res.block_blue;
            case BlockType.DarkBlue: Res.block_dark_blue;
            case BlockType.Purple: Res.block_purple;
            case BlockType.Red: Res.block_orange;
            case BlockType.Yellow: Res.block_yellow;
        }

        return image.toTile();
    }
    
    public function no() {
        this.notify();
    }

    public function rotate(v: Float) image.rotate(v);
}