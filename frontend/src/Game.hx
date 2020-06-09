import core.models.Block;
import h2d.Text;
import hxd.Res;
import logic.BlockPool;
import core.models.Figure;
import logic.FigureBuilder;
import view.BlockTile;
import hxd.Key;
import web.WebSocketClient;

// For Extension Method
using core.pattern.observer.ObservableExtender;

class Game extends hxd.App {

    private var figure: Figure;
    private var pool: BlockPool;
    private var tf: Text;
    private var i = 0;
    private var wsClient: WebSocketClient;

    public function new() {
        super();
        pool = new BlockPool();
        // pool.setAddListener(block -> {
        //     new BlockTile(block, s2d);
        //     // i++;
        //     // log("" + i);
        // });

        pool.onAdded = block -> new BlockTile(block, s2d);
    }

    override function init() {
        tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
        
        /*var tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
        tf.text = "Hello World !";

        b = new Bitmap(Tile.fromColor(0xFF0000, 60, 60), s2d);
        b.setPosition(100, 100);
        b.tile.setCenterRatio();    // configure to rotate around itself

        var i = new h2d.Interactive(b.tile.width, b.tile.height, b);
        i.onOver = _ -> b.alpha = 0.5;
        i.onOut = _ -> b.alpha = 1;
        var g = new h2d.Graphics(s2d);
        g.beginFill(0xFF00FF, .5);
        g.drawCircle(200, 200, 100);*/

        wsClient = new WebSocketClient("wss://echo.websocket.org");
    
        figure = FigureBuilder.getPurple(pool, 10, 0);
        figure.addObserver(wsClient);
    }

    private function log(text: String) {
        tf.text = text;
    }

    override function update(dt:Float) {
        super.update(dt);

        if (Key.isPressed(Key.DOWN)) {
            figure.moveDown();
            figure.notify("down");
        } else if (Key.isPressed(Key.LEFT)) {
            figure.moveLeft();
        } else if (Key.isPressed(Key.RIGHT)) {
            figure.moveRight();
        } else if (Key.isPressed(Key.UP)) {
            figure.rotate();
        }
    }

    static function main() {
        Res.initEmbed();
        new Game();
    }
}