package web;

import core.pattern.observer.Observable;
import haxe.net.WebSocket;

using core.pattern.observer.ObservableExtender;

class WebSocketClient implements Observable {

    private var ws: WebSocket;
    private var isOpen: Bool = false;

    //public var players(default, null): Array<Int> = [];

    public dynamic function onNewPlayerCallback(playerId: Int) { };

    public function new (webSocketURL: String){
        ws = WebSocket.create(webSocketURL, ['echo-protocol'], false);

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
        var wsMessage = WebSocketMessage.fromJson(sWsMessage);
        //var wsMessage = WebSocketMessage.unserializeMessage(sWsMessage);
        
        if(wsMessage.command == CommandType.NewPlayer)
            onNewPlayerCallback(wsMessage.data);
        else
            this.notify(wsMessage);
        
    }
          
    private function sendMessage(message: String)
        if (isOpen) ws.sendString(message);
        else trace("Client is not yet open");

    public function sendWebSocketMessage(wsMessage: WebSocketMessage){
        sendMessage(WebSocketMessage.serializeMessage(wsMessage));
    }
    
}