import logic.Score;
import h2d.Font;
import h3d.shader.ColorKey;
import hxd.res.DefaultFont;
import hxd.res.Resource;
import h2d.Flow.FlowAlign;
import core.Constants;
import view.components.AlertComp;
import view.components.ScoreComp;
import view.ColorProvidable;
import view.LocalColorProvider;
import hxd.Res;

import web.WebSocketClient;
import web.Player;
import web.OwnPlayer;
import web.OtherPlayer;

// For Extension Method
using core.pattern.observer.ObservableExtender;
using utils.ArrayTools;

class Game extends hxd.App {
    private var colorProvider: ColorProvidable = new LocalColorProvider();

    //Multiplayer variables
    private var wsClient: WebSocketClient; //= new WebSocketClient("ws://localhost:8100/ws"); //Testing: wss://echo.websocket.org, Server: ws://localhost:8100/ws
    private var playerId = 1;
    private var players: Array<Player> = [];
    private var ownPlayer: OwnPlayer;
    private var viewFont: Font;

    var rightTop: h2d.Flow;
    var style: h2d.domkit.Style;

    public function new() {
        super();
    }

    override function loadAssets(onLoaded:() -> Void) {
        super.loadAssets(onLoaded);
        // new hxd.fmt.pak.Loader(s2d, onLoaded);
    }

    override function init() {      
        viewFont = DefaultFont.get();
        viewFont.resizeTo(30);

        style = new h2d.domkit.Style();
		style.load(hxd.Res.style);
        // style.allowInspect = true;

        wsClient = new WebSocketClient("ws://172.17.216.217:8100/ws");
        wsClient.onNewPlayerCallback = function(playerId) {
            if(playerId != players[0].playerId){
    
                var xOffset = players.length * (40 + Constants.BOARD_WIDTH), yOffset = players.length * 2, row = 0;
                if(players.length % 5 == 0){
                   row += Constants.BOARD_HEIGHT; 
                } 

                var newPlayer: OtherPlayer = new OtherPlayer(colorProvider, s2d, xOffset, row * yOffset);
                newPlayer.playerId = playerId;
                newPlayer.init();
                newPlayer.onLose = function() {
                    players.remove(newPlayer);
                    // newPlayer.dispose();
                };
                players.push(newPlayer);
                style.addObject(newPlayer.board);
                wsClient.addObserver(newPlayer);
                trace("OtherPlayer added" + newPlayer.playerId);
            } else 
                trace("NewPlayer of OwnPlayer");
        }
        
        ownPlayer = new OwnPlayer(colorProvider, wsClient, s2d, 5, 2);
        ownPlayer.onLose = () -> {
            var b = new h2d.Flow(s2d);
            b.horizontalAlign = Middle;
            b.verticalAlign = FlowAlign.Bottom;
            b.minWidth = b.maxWidth = s2d.width;
		    b.minHeight = b.maxHeight = s2d.height;

            var alert = new AlertComp("You lost the game :(", Res.mail.toTile() , b);
            alert.icon.addShader(new h3d.shader.ColorAdd(0xffffff));
            alert.alertText.font = viewFont;
            alert.alertBtn.onClick = () -> {
                alert.remove();
            }

            style.addObject(alert);
        };

        ownPlayer.init();
        style.addObject(ownPlayer.board);
        players.push(ownPlayer);

        rightTop = new h2d.Flow(s2d);
        rightTop.horizontalAlign = FlowAlign.Right;
        rightTop.verticalAlign = FlowAlign.Top;
        onResize();

        var score = new ScoreComp(rightTop);
        score.scoretext.font = viewFont;
        Score.getInstance().addObserver(score);
        style.addObject(score);

        wsClient.addObserver(ownPlayer);
        wsClient.start();
    }

    override function onResize() {
        rightTop.minWidth = rightTop.maxWidth = s2d.width;
		rightTop.minHeight = rightTop.maxHeight = s2d.height;
    }

    override function update(dt:Float) {
        super.update(dt);

        players.forEach(p -> p.updatePlayer());
        style.sync();
    }

    static function main() {
        #if hl
        // Resource.LIVE_UPDATE = true;
        Res.initLocal();
        // Res.initPak();
        #else
        Res.initEmbed();
        #end
        new Game();
    }
    
} 