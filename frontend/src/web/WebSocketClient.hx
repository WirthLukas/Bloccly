package web;

import core.models.Block;
import haxe.io.Bytes;
import core.pattern.observer.Observer;
import core.pattern.observer.Observable;
import haxe.net.WebSocket;

class WebSocketClient implements Observer{

    private var ws: WebSocket;
    private var isOpen: Bool = false;

    public function new (webSocketURL: String){
        ws = WebSocket.create(webSocketURL, ['echo-protocol'], false);

        trace("testing");
        ws.onopen = () -> {
            this.isOpen = true;
        }
        
        //TODO: Handle incoming message
        ws.onmessageString = message -> trace("message: "+message);

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

    private function receiveBlocks(blocks: Array<Block>){
        
    }
          
    private function sendMessage(message: String)
        if (isOpen) ws.sendString(message);
        else trace("Client is not yet open");

    /*private function sendBytes(bytes: Bytes)
        if (isOpen) ws.sendBytes(bytes);
        else trace("Client is not yet open");*/

    public function sendBlocks(blocks: Array<Block>){
        //sendBlocks(blocks.toString());
    }

    public function update(sender: Observable, ?data: Any){
        trace("WebSocketClient update: " + data + " from " + sender);
        if(Type.getClassName(Type.getClass(sender)) == "core.models.Figure"){
            trace("Figure moved " + data);
            //sendMessage("Figure moved " + data);
        }
        if(Type.getClassName(Type.getClass(sender)) == "logic.GameFieldChecker"){
            trace("Rows are full " + data);
            //sendMessage("Rows are full: " + data);
        }
    }

}