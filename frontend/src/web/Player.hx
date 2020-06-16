package web;

import core.Constants;
import view.components.GameBoardViewComp;
import core.pattern.observer.Observable;
import core.pattern.observer.Observer;
import view.Color;
import view.ColorProvidable;
import h2d.Text;
import view.BlockTilePool;
import logic.BlockPool;
import core.models.Block;

using utils.ArrayTools;

class Player implements Observer {
    public var playerId: Int;
    public var board: GameBoardViewComp;

    private var parent: h2d.Object;

    private var pool = new BlockPool();
    private var tilePool = new BlockTilePool();
    private var colorProvider: ColorProvidable;
    private var nextColor: Color;

    private var offsetX: Int;
    private var offsetY: Int;

    private var lost: Bool = false;

    public function new(colorProvider: ColorProvidable, parent: h2d.Object, offsetX: Int = 0, offsetY: Int = 0) {
        this.parent = parent;
        this.colorProvider = colorProvider;
        this.offsetX = offsetX;
        this.offsetY = offsetY;

        // every time a new block is added to the game field
        // this block will added to a block tile (which displays the block)
        pool.onAdded = block -> tilePool
            .getBlockTile(block, parent)
            .setOffset(offsetX, offsetY)
            .withColor(nextColor)
            .setBlock(block)
            .show();

        pool.onFreed = block -> tilePool.freeOf(block);
        nextColor = colorProvider.getNextColor();
    }

    public function updatePlayer() {
    }   

    public function init() {
        board = new GameBoardViewComp(
            Constants.BOARD_WIDTH,
            Constants.BOARD_HEIGHT - Constants.BLOCK_WIDTH + 3,
            parent);

        board.setPosition(offsetX + board.x - 5, board.y + 2 * Constants.BLOCK_HEIGHT);
    }

    public function update(sender: Observable, ?data: Any): Void{
        if(Std.is(sender, WebSocketClient)){
            var wsMessage : WebSocketMessage = cast data;

            if(wsMessage.command == CommandType.Id)
                playerId = wsMessage.playerId;
            else if(wsMessage.playerId == playerId){
                switch(wsMessage.command){
                    case CommandType.Loss:
                        lost = true;
                    case CommandType.BlockUpdate:
                        pool.clear(); 

                        if(Std.is(wsMessage.data, Array)) {
                            (wsMessage.data: Array<Block>).forEach(block -> pool.getBlock().setPosition(block.x, block.y));
                        }
                            
                    default: trace("Wrong CommandType");
                }
            }
        }
    }


}