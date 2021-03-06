package web;

import core.pattern.observer.Observable;
import haxe.net.WebSocket;

using core.pattern.observer.ObservableExtender;

class WebSocketClient implements Observable {

    private var ws: WebSocket;
    private var isOpen: Bool = false;
    private var receivedId: Bool = false;

    private var webSocketURL: String;

    public dynamic function onNewPlayerCallback(playerId: Int) { };

    public function new (webSocketURL: String){
        this.webSocketURL = webSocketURL;
    }

    public function start(){
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
        var wsMessage;
        if(!receivedId) {
            wsMessage = WebSocketMessage.fromJson(sWsMessage);
            receivedId = true;
        }
        else
            wsMessage = WebSocketMessage.fromJson(sWsMessage);
        
        if(wsMessage.command == CommandType.NewPlayer)
            onNewPlayerCallback(wsMessage.playerId);
        else
            this.notify(wsMessage);
        
    }
          
    private function sendMessage(message: String)
        if (isOpen) ws.sendString(message);
        else trace("Client is not yet open");

    public function sendWebSocketMessage(wsMessage: WebSocketMessage){
        var wsMessage = WebSocketMessage.toJson(wsMessage);
        sendMessage(wsMessage);
    }
    
}