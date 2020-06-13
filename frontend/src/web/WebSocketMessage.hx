package web;

import haxe.Unserializer;
import haxe.Serializer;

class WebSocketMessage {
    public var command(default, default): String;
    public var data(default, default): Any;

    public function new (command: String, data: Any){
        this.command = command;
        this.data = data;
    }

    public static function serializeMessage(message: WebSocketMessage): String
        return Serializer.run(message);
    

    public static function unserializeMessage(sMessage: String): WebSocketMessage
        return cast Unserializer.run(sMessage);

}