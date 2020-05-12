import hxd.Res;
import h2d.Graphics;
import hxd.Key;
import h2d.Interactive;
import h2d.Tile;
import h2d.Bitmap;
import model.Block;

using pattern.observer.ObservableExtender;

class Game extends hxd.App {
    private var b: Bitmap;
    private var img: Bitmap;

    override function init() {
        var tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
        tf.text = "Hello World !";

        b = new Bitmap(Tile.fromColor(0xFF0000, 60, 60), s2d);
        b.setPosition(100, 100);
        b.tile.setCenterRatio();    // configure to rotate around itself

        var i = new h2d.Interactive(b.tile.width, b.tile.height, b);
        i.onOver = _ -> b.alpha = 0.5;
        i.onOut = _ -> b.alpha = 1;
        
        var g = new h2d.Graphics(s2d);
        g.beginFill(0xFF00FF, .5);
        g.drawCircle(200, 200, 100);

        img = new Bitmap(Res.character.toTile(), s2d);
        img.setPosition(200, 200);
        img.setScale(3);
    }

    override function update(dt:Float) {
        super.update(dt);

        b.rotation += 0.01;

        if (Key.isDown(Key.LEFT)) {
            img.x -= 200 * dt;
        } else if (Key.isDown(Key.RIGHT)) {
            img.x += 200 * dt;
        }

        if (Key.isDown(Key.UP)) {
            img.y -= 200 * dt;
        } else if (Key.isDown(Key.DOWN)) {
            img.y += 200 * dt;
        }
    }

    static function main() {
        Res.initEmbed();
        new Game();


        var t = new Block();
        t.addObserver(null);
    }
}