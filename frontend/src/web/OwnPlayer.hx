package web;

import haxe.ds.ArraySort;
import core.models.Block;
import hxd.Res;
import hxd.res.Sound;
import core.Constants;
import view.LocalColorProvider;
import view.Color;
import logic.FigureBuilder;
import hxd.Key;
import logic.GameFieldChecker;
import view.ColorProvidable;
import core.models.Figure;
import h2d.Text;
import view.BlockTilePool;
import logic.BlockPool;

class OwnPlayer extends Player {

    private var updateCount: Int = 0;
    private var resetCount: Int = 30;
    
    private var wsClient: WebSocketClient;
    private var figure: Figure;
    private var music: Null<Sound> = null;

    private var finale: Bool = false;

    public function new(colorProvider: ColorProvidable, wsClient: WebSocketClient, parent: h2d.Object) {
        super(colorProvider, parent);
        this.wsClient = wsClient;
    }

    override function init() {
        // should be createNewFigure()
        // but in player, a color is already created
        figure = newFigureOf(nextColor, Constants.BLOCK_START_X, Constants.BLOCK_START_Y);

        if (Sound.supportedFormat(Mp3)) {
            music = Res.load('bc_n.mp3').toSound();
        }

        if(music != null){
            //Play the music and loop it
            music.play(true);
        }
    }

    public override function update() {
        if (lost) return;

        var blockReachedBottom: Bool = 
            if (Key.isPressed(Key.SPACE)) {
                moveToBottom();
            } else {
                doPlayerInput();
                doStandardFigureUpdate();
                GameFieldChecker.checkBlockReachesBottom(figure.blocks, pool.usedBlocks);
            } 

        if (blockReachedBottom) {
            trace("Block reached Bottom");

            if(playerLost()) {
                lost = true;
                trace("You lost the game.");
                music.dispose();
                var wsMessage = new WebSocketMessage(CommandType.Loss, playerId, pool.usedBlocks);
                wsClient.sendWebSocketMessage(wsMessage);
                onLoose();
            }
            else {
                clearFullRowsIfNeccessary();
                createNewFigure();
            }
        }  
    }

    private inline function moveToBottom(): Bool {
        while(!GameFieldChecker.checkBlockReachesBottom(figure.blocks, pool.usedBlocks)) {
            figure.moveDown();
        }

        updateCount = 0;
        return true;
    }

    private inline function doPlayerInput() {
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
    }

    private inline function doStandardFigureUpdate() {
        updateCount++;

        if (updateCount == resetCount) {
            updateCount = 0;
            figure.moveDown();
        }
    }

    private inline function playerLost(): Bool
        return figure.blocks.filter(block -> block.y < 0).length > 0;

    private inline function clearFullRowsIfNeccessary() {
        //If a Block reaches the end of its journey, checkRowFull() is called to check, if it filled a line
        var fullRows: Array<Bool> = GameFieldChecker.checkRowFull(pool.usedBlocks);

        if ( getRowOfHighestBlock(pool.usedBlocks) <= 8 && music != null && !finale) {
            //music.stop();
            trace('music change');
            music.dispose();
            music = Res.load('bc_int.mp3').toSound();
            music.play(true);
            finale = true;
        }

        if (fullRows.filter(row -> row).length >= 1) {
            clearFullRows(fullRows); 
        }
         
        var wsMessage = new WebSocketMessage(CommandType.BlockUpdate, playerId, pool.usedBlocks);
        wsClient.sendWebSocketMessage(wsMessage);
    }

    private inline function createNewFigure() {
        //Create new Figure and notify wsClient
        nextColor = colorProvider.getNextColor();
        figure = newFigureOf(nextColor, Constants.BLOCK_START_X, Constants.BLOCK_START_Y);
        var wsMessage = new WebSocketMessage(CommandType.NewBlock, playerId, figure.blocks);
        wsClient.sendWebSocketMessage(wsMessage);
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

    private static function getRowOfHighestBlock(blocks: Array<Block>): Int {
        var rows = blocks.map(b -> b.y);
        ArraySort.sort(rows, (a, b) -> -(a - b));
        var highest = rows.pop();
        trace(highest);
        return highest;
    }

    public dynamic function onLoose() {
    }
}