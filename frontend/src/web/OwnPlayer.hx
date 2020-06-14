package web;

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

class OwnPlayer extends Player{

    private var updateCount: Int = 0;
    private var resetCount: Int = 50;
    private var nextColor: Color;
    
    private var colorProvider: ColorProvidable = new LocalColorProvider();
    
    private var wsClient: WebSocketClient;

    public override function draw(){
        if (lost) return;

        var blockReachedBottom = if (Key.isPressed(Key.SPACE)) {
            while(!GameFieldChecker.checkBlockReachesBottom(figure.blocks, pool.usedBlocks)) {
                figure.moveDown();
            }

            updateCount = 0;
            true;
        } else {
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
            
            GameFieldChecker.checkBlockReachesBottom(figure.blocks, pool.usedBlocks);
        } 

        if(blockReachedBottom){
            trace("Block reached Bottom");
            if(figure.blocks.filter(block -> block.y < 0).length > 0){
                lost = true;
                tf.text = "You lost the game.";
                trace("You lost the game.");
                var wsMessage = new WebSocketMessage(CommandType.Loss, playerId, pool.usedBlocks);
                wsClient.sendWebSocketMessage(wsMessage);
            }
            else {
                //If a Block reaches the end of its journey, checkRowFull() is called to check, if it filled a line
                var fullRows: Array<Bool> = GameFieldChecker.checkRowFull(pool.usedBlocks);
    
                if (fullRows.map(row -> row).length >= 1) {
                    clearFullRows(fullRows); 
                }
                
                var wsMessage = new WebSocketMessage(CommandType.BlockUpdate, playerId, pool.usedBlocks);
                wsClient.sendWebSocketMessage(wsMessage);
    
                //Create new Figure and notify wsClient
                nextColor = colorProvider.getNextColor();
                figure = newFigureOf(nextColor, Game.BLOCK_START_X, Game.BLOCK_START_Y);
                var wsMessage = new WebSocketMessage(CommandType.NewBlock, playerId, figure.blocks);
                wsClient.sendWebSocketMessage(wsMessage);
            }
        }
    }

    public function initializeOwnPlayer(figure: Figure, pool: BlockPool, tilePool: BlockTilePool, tf: Text, wsClient: WebSocketClient, colorProvider: ColorProvidable){
        super.initialize(figure, pool, tilePool, tf);
        this.wsClient = wsClient;
        this.colorProvider = colorProvider;
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

}