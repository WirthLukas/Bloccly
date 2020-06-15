package web;

import haxe.io.Bytes;
import core.models.Block;
import haxe.net.WebSocket;

class WebSocketClient{

    private var ws: WebSocket;
    private var isOpen: Bool = false;

    public var playerId(default, default): Int;

    public function new (webSocketURL: String){
        ws = WebSocket.create(webSocketURL, ['echo-protocol'], false);

        trace("testing");
        ws.onopen = () -> {
            this.isOpen = true;
        }
        
        ws.onmessageString = message -> receiveWebSocketMessage(message);

        //New Thread -> WebSocket is checking for Messages from specified Server
        #if sys
        sys.thread.Thread.create(() -> {
            while (true) {
                ws.process();
                Sys.sleep(0.1);
            }
        });
        #end
    }

    private function receiveWebSocketMessage(sWsMessage: String){
        var wsMessage = WebSocketMessage.unserializeMessage(sWsMessage);
        
        if(wsMessage.command == CommandType.Id){
            
        }
        else if(wsMessage.command == CommandType.Loss){
            
        }
        else if(wsMessage.command == CommandType.BlockUpdate){

        }
        else if(wsMessage.command == CommandType.NewBlock){

        }
    }
          
    private function sendMessage(message: String)
        if (isOpen) ws.sendString(message);
        else trace("Client is not yet open");

    public function sendWebSocketMessage(wsMessage: WebSocketMessage){
        sendMessage(WebSocketMessage.serializeMessage(wsMessage));
    }
    
}