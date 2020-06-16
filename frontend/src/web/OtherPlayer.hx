package web;

import view.Color;
import core.models.Block;
import core.pattern.observer.Observable;
import core.pattern.observer.Observer;
import view.ColorProvidable;

using utils.ArrayTools;

class OtherPlayer extends Player implements Observer {
    public function new(colorProvider: ColorProvidable, parent: h2d.Object, offsetX: Int = 0, offsetY: Int = 0) {
        super(colorProvider, parent, offsetX, offsetY);
        nextColor = Color.Blue;
    }

    public override function updatePlayer(){
        
    }

    public override function update(sender: Observable, ?data: Any): Void{
        super.update(sender, data);
        if(Std.is(sender, WebSocketClient)){
            var wsMessage : WebSocketMessage = cast data;
            if(wsMessage.playerId == playerId){
                switch(wsMessage.command){
                    case CommandType.Loss:
                        lost = true;
                        onLose();
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

    public function dispose() {
        this.board.remove();
        this.pool.clear();
    }
}