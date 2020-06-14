package web;

import haxe.Json;
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

    public static function fromJson(jMessage: String): WebSocketMessage{
        var message: haxe.DynamicAccess<Dynamic> = Json.parse(jMessage);

        var command = CommandType.Id;
        var playerId;
        var data;

        var cnt = 0;

        for (key in message.keys()) {
            trace(key, message.get(key));
            trace(key);
            trace(message.get(key));
            cnt++;
            switch(cnt){
                case 1: 
                    data = message.get(key);
                case 2:
                    playerId = message.get(key);
                case 3:
                    command = getCommandTypeFromNumber(message.get(key));
            }
        } 

        return new WebSocketMessage(CommandType.Id, 1, 1);
    }

    private static function getCommandTypeFromNumber(number: Int): CommandType{
        switch(number){
            case 0:
                return CommandType.Id;
            case 1:
                return CommandType.Loss;
            case 2:
                return CommandType.BlockUpdate;
            case 3:
                return CommandType.NewBlock;
            default:
                return CommandType.NewPlayer;
        }
    }

}