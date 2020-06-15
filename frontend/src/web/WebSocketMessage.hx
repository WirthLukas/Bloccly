package web;

import core.models.Block;
import haxe.Exception;
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
        var jMessage = "{ ";

        jMessage += "\"Command\":"+getNumberFromCommandType(wsMessage.command)+","
            + "\"PlayerId\":"+wsMessage.playerId+",\"Data\":";

        switch(wsMessage.command){
            case CommandType.Loss:
                if(Std.is(wsMessage.data, Array)){
                    var blockArray: Array<Block> = cast wsMessage.data;
                    jMessage += "[";
                    for(block in blockArray){
                        jMessage += "{";
                        if(Std.is(block, Block)){
                            jMessage += "\"X\":" + block.x + "\"Y\":" + block.y;
                        }
                        jMessage += "}";
                    }
                    jMessage += "]";
                } else 
                    throw new Exception("Wrong Data");
            case CommandType.BlockUpdate:
                if(Std.is(wsMessage.data, Array)){
                    var blockArray: Array<Block> = cast wsMessage.data;
                    jMessage += "[";
                    for(block in blockArray){
                        jMessage += "{";
                        if(Std.is(block, Block)){
                            jMessage += "\"X\":" + block.x + "\"Y\":" + block.y;
                        }
                        jMessage += "}";
                    }
                    jMessage += "]";
                } else 
                    throw new Exception("Wrong Data");
            default:
                throw new Exception("Wrong CommandType");
        }

        jMessage += " }";

        //jMessesage += "\n";

        return jMessage;
    }
        

    public static function fromJson(jMessage: String, initial: Bool): WebSocketMessage{
        if(initial){
            var message: haxe.DynamicAccess<Dynamic> = Json.parse(jMessage);

            var command = CommandType.Id;
            var playerId = -1;
            var data: Any = null;
    
            var cnt = 0;
    
            for (key in message.keys()) {
                trace(key, message.get(key));
                cnt++;
                switch(cnt){
                    case 1: 
                        playerId = message.get(key);
                    case 2:
                        data = message.get(key);
                    case 3:
                        command = getCommandTypeFromNumber(message.get(key));
                }
            } 
            return new WebSocketMessage(command, playerId, data);
        } else {
            var command: Int = cast jMessage.charAt(12); //Position of Value from Command
            var playerId: Int = cast jMessage.charAt(25); //Position of Value from PlayerId
            var dataString = jMessage.substr(34, jMessage.length - 34);
            //TODO: get blocks out of dataString
        }

        return new WebSocketMessage(CommandType.Loss, 0, 0);
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