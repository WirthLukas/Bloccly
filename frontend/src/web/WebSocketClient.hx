package web;

import haxe.net.WebSocket;

class WebSocketClient {

    private var ws: WebSocket;

    public function new (webSocketURL: String, tf: h2d.Text){
        ws = WebSocket.create(webSocketURL, ['echo-protocol'], false);

        ws.onopen = function() {
            tf.text = "open";
            ws.sendString('hello friend');
        }
        
        ws.onmessageString = function(message){
            tf.text="message from server!" + message;
        }

        //tf.text = "message";
        
        /*#if sys
        while (true) {
            ws.process();
            Sys.sleep(0.1);
        }
        #end*/
    }

    public function openWebSocket(){
        trace("p");
        
    }

    public function sendMessage(message: String){
        ws.sendString(message);
    }



    
}