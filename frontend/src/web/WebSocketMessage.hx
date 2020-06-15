package web;

import h3d.pass.Default;
import core.models.Block;
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

    public static function toJson(wsMessage: WebSocketMessage): String{
        var jMessage = "{";

        jMessage += "\"Command\":"+getNumberFromCommandType(wsMessage.command)+","
            + "\"PlayerId\":"+wsMessage.playerId+",\"Data\":";

        switch(wsMessage.command){
            case CommandType.Loss:
                if(Std.is(wsMessage.data, Array)){
                    /*
                    var blockArrayJson = blocksToJson(cast wsMessage.data);// Array<Block> = cast wsMessage.data;
                    jMessage += "[" + blockArrayJson;
                    jMessage = jMessage.substr(0, jMessage.length - 1);
                    jMessage += "]";*/
                    jMessage += "\"" + "520" + "\""; //To be score
                } else 
                    return "Wrong Data";
            case CommandType.BlockUpdate:
                if(Std.is(wsMessage.data, Array)){
                    /*var blockArrayJson = blocksToJson(cast wsMessage.data);// Array<Block> = cast wsMessage.data;
                    jMessage += "[" + blockArrayJson;
                    jMessage = jMessage.substr(0, jMessage.length - 1);
                    jMessage += "]";*/
                    jMessage += "\"" + Serializer.run(wsMessage.data) + "\"";
                } else 
                    return "Wrong Data";
            default:
                return "Wrong CommandType";
        }

        jMessage += "}";

        return jMessage;
    }

    private static function blocksToJson(blockArray: Array<Block>): String{
        var blockString: String = "";
        for(block in blockArray){
            blockString += "{";
            if(Std.is(block, Block)){
                blockString += "\"X\":" + block.x + "," + "\"Y\":" + block.y;
            }
            blockString += "},";
        }
        return blockString;
    }

    public static function fromJson(jMessage: String, initial: Bool): WebSocketMessage{
        var message: haxe.DynamicAccess<Dynamic> = Json.parse(jMessage);

        var command = CommandType.Id;
        var playerId = -1;
        var data: Any = null;

        var cnt = 0;

        for (key in message.keys()) {
            cnt++;
            switch(cnt){
                case 1: 
                    playerId = message.get(key);
                case 2:
                    //data = message.get(key); //as pure Json
                    data = message.get(key); //as serialized Blocks
                case 3:
                    command = getCommandTypeFromNumber(message.get(key));
            }
        } 

        if(command == CommandType.BlockUpdate)
            data = Unserializer.run(data);

        return new WebSocketMessage(command, playerId, data);
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

    private static function getNumberFromCommandType(command: CommandType): Int{
        switch(command){
            case CommandType.Id:
                return 0;
            case CommandType.Loss:
                return 1;
            case CommandType.BlockUpdate:
                return 2;
            case CommandType.NewBlock:
                return 3;
            default:
                return 4;
        }
    }

}