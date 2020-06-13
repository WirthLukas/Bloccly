package web;

import haxe.Unserializer;
import haxe.Serializer;

class WebSocketMessage {
    public var command(default, default): CommandType;
    public var playerId(default, default): Int;
    public var data(default, default): Any;

    public function new (command: CommandType, playerId: Int, data: Any){
        this.command = command;
        this.playerId = playerId;
        this.data = data;
    }

    public static function serializeMessage(message: WebSocketMessage): String
        return Serializer.run(message);
    

    public static function unserializeMessage(sMessage: String): WebSocketMessage
        return cast Unserializer.run(sMessage);

}