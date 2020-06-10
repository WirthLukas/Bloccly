package web;

import haxe.net.WebSocket;

class WebSocketClient {

    private var ws: WebSocket;
    private var isOpen: Bool = false;

    public function new (webSocketURL: String){
        ws = WebSocket.create(webSocketURL, ['echo-protocol'], false);

        trace("testing");
        ws.onopen = () -> {
            this.isOpen = true;
            trace("open");
            ws.sendString('hello friend');
        }
        
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

    public function sendMessage(message: String)
        if (isOpen) ws.sendString(message);
        else trace("Client is not yet open");
    
}