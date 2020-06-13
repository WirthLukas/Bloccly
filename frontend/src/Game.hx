import view.ColorProvidable;
import view.LocalColorProvider;
import view.Color;
import h2d.Text;
import hxd.Res;
import hxd.Key;

import core.models.Figure;
import logic.BlockPool;
import logic.FigureBuilder;
import view.BlockTilePool;
import web.WebSocketClient;
import logic.GameFieldChecker;

// For Extension Method
using core.pattern.observer.ObservableExtender;

class Game extends hxd.App {

    public static inline var FIELD_WIDTH = 10;
    public static inline var FIELD_HEIGHT = 21;

    private var figure: Figure;
    private var pool: BlockPool = new BlockPool();
    private var tilePool: BlockTilePool = new BlockTilePool();
    private var tf: Text;
    private var i = 0;
    private var wsClient: WebSocketClient;
    private var colorProvider: ColorProvidable = new LocalColorProvider();
    private var lost: Bool = false;

    private var updateCount: Int = 0;
    private var resetCount: Int = 50;
    private var nextColor: Color;

    public function new() {
        super();
        pool.onAdded = block -> tilePool
            .getBlockTile(block, s2d)
            .withColor(nextColor)
            .setBlock(block)
            .show();

        pool.onFreed = block -> tilePool.freeOf(block);
        nextColor = colorProvider.getNextColor();

        wsClient = new WebSocketClient("wss://echo.websocket.org"); //WS-Server for testing purposes
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
    
        figure = newFigureOf(nextColor, 5, 0);
        figure.addObserver(wsClient);        
    }

    private function log(text: String) {
        tf.text = text;
    }

    override function update(dt:Float) {
        super.update(dt);

        if(!lost){
            if (Key.isPressed(Key.DOWN)) {
                figure.moveDown();
            } else if (Key.isPressed(Key.LEFT)) {
                if(GameFieldChecker.checkBlockCollision(figure.blocks, "left", pool.usedBlocks))
                    figure.moveLeft();
            } else if (Key.isPressed(Key.RIGHT)) {
                if(GameFieldChecker.checkBlockCollision(figure.blocks, "right", pool.usedBlocks)){
                    figure.moveRight();
                }  
            } else if (Key.isPressed(Key.UP)) {
                figure.rotate();
            }
    
            updateCount++;
    
            if (updateCount == resetCount) {
                updateCount = 0;
                figure.moveDown();
            }
          
            if(GameFieldChecker.checkBlockReachesBottom(figure.blocks, pool.usedBlocks)){
                //If a Block reaches the end of its journey, checkRowFull() is called to check, if it filled a line
                var fullRows: Array<Bool> = GameFieldChecker.checkRowFull(pool.usedBlocks);
    
                if (fullRows.map(row -> row).length >= 1) {
                    clearFullRows(fullRows);
                    wsClient.sendBlocks(pool.usedBlocks); //wsClient sends the Array of Blocks to the Server, after a line is cleared.
                }
    
                //Create new Figure
                nextColor = colorProvider.getNextColor();
                figure = newFigureOf(nextColor, 5, 0);
    
                //figure.addObserver(wsClient);
                trace("Block reached Bottom");
            }   

            if(GameFieldChecker.checkGameLost(figure.blocks, pool.usedBlocks)){
                lost = true;
                var fullRows: Array<Bool> = [ for(i in 0...Game.FIELD_HEIGHT) true];
                clearFullRows(fullRows);
                tf.text = "You lost the game.";
                trace("You lost the game.");
            }
        }
    }

    private function newFigureOf(color: view.Color, x: Int, y: Int): Figure
        return switch color {
            case Orange: FigureBuilder.getOrange(pool, x, y);
            case Cyan: FigureBuilder.getCyan(pool, x, y);
            case Blue: FigureBuilder.getBlue(pool, x, y);
            case Green: FigureBuilder.getGreen(pool, x, y);
            case Purple: FigureBuilder.getPurple(pool, x, y);
            case Red: FigureBuilder.getRed(pool, x, y);
            case Yellow: FigureBuilder.getYellow(pool, x, y);
            default: throw "No such type available";
        }

    private inline function clearFullRows(fullRows: Array<Bool>): Void
        for(i in 0...fullRows.length)
            if(fullRows[i]) {
                trace('free row $i');
                pool.freeRow(i);
                pool.moveAllBlocksAboveRow(i, 0, 1);
            }
                

    static function main() {
        Res.initEmbed();
        new Game();
    }
}