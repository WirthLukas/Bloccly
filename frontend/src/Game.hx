import h3d.shader.ColorKey;
import hxd.res.DefaultFont;
import hxd.res.Resource;
import h2d.Flow.FlowAlign;
import core.Constants;
import view.components.AlertComp;
import view.ColorProvidable;
import view.LocalColorProvider;
import hxd.Res;

import web.WebSocketClient;
import web.Player;
import web.OwnPlayer;

// For Extension Method
using core.pattern.observer.ObservableExtender;
using utils.ArrayTools;

class Game extends hxd.App {
    private var colorProvider: ColorProvidable = new LocalColorProvider();
    public static var test = 10;

    //Multiplayer variables
    private var lost: Bool = false;
    private var wsClient: WebSocketClient; //= new WebSocketClient("ws://localhost:8100/ws"); //Testing: wss://echo.websocket.org, Server: ws://localhost:8100/ws
    private var playerId = 1;
    private var players: Array<Player> = [];
    private var ownPlayer: OwnPlayer;

    var bottom: h2d.Flow;
    var style: h2d.domkit.Style;

    public function new() {
        super();
    }

    override function loadAssets(onLoaded:() -> Void) {
        super.loadAssets(onLoaded);
        // new hxd.fmt.pak.Loader(s2d, onLoaded);
    }

    override function init() {         
        // var root = new GameBoardViewComp(
        //     Constants.BOARD_WIDTH,
        //     Constants.BOARD_HEIGHT - Constants.BLOCK_WIDTH + 3,
        //     s2d);

        // root.setPosition(root.x, root.y + 2 * Constants.BLOCK_HEIGHT);

        style = new h2d.domkit.Style();
		style.load(hxd.Res.style);
        style.allowInspect = true;

        wsClient = new WebSocketClient("ws://localhost:8100/ws");
        wsClient.onNewPlayerCallback = function(playerId) {
            var newPlayer: Player = new Player(colorProvider, s2d);
            newPlayer.playerId = playerId;
            players.push(newPlayer);
            wsClient.addObserver(newPlayer);
        }
        
        ownPlayer = new OwnPlayer(colorProvider, wsClient, s2d, 5, 2);
        ownPlayer.playerId = 1; //TODO: Get playerId through websocket
        ownPlayer.onLoose = () -> {
            var b = new h2d.Flow(s2d);
            b.horizontalAlign = Middle;
            b.verticalAlign = FlowAlign.Bottom;
            b.minWidth = b.maxWidth = s2d.width;
		    b.minHeight = b.maxHeight = s2d.height;

            var font = DefaultFont.get();
            font.resizeTo(30);

            var alert = new AlertComp("You lost the game :(", Res.mail.toTile() , b);
            alert.icon.addShader(new h3d.shader.ColorKey(256));
            alert.alertText.font = font;
            alert.alertBtn.onClick = () -> {
                alert.remove();
            }

            style.addObject(alert);
        };

        ownPlayer.init();
        style.addObject(ownPlayer.board);
        players.push(ownPlayer);

        var ownPlayer2 = new OwnPlayer(colorProvider, wsClient, s2d, 40 + Constants.BOARD_WIDTH, 2);
        ownPlayer2.playerId = 1; //TODO: Get playerId through websocket
        // ownPlayer2.onLoose = () -> {
        //     var b = new h2d.Flow(s2d);
        //     b.horizontalAlign = Middle;
        //     b.verticalAlign = FlowAlign.Bottom;
        //     b.minWidth = b.maxWidth = s2d.width;
		//     b.minHeight = b.maxHeight = s2d.height;

        //     var font = DefaultFont.get();
        //     font.resizeTo(30);

        //     var alert = new AlertComp("You lost the game :(", Res.mail.toTile() , b);
        //     alert.icon.addShader(new h3d.shader.ColorKey(256));
        //     alert.alertText.font = font;
        //     alert.alertBtn.onClick = () -> {
        //         alert.remove();
        //     }

        //     style.addObject(alert);
        // };

        ownPlayer2.init();
        style.addObject(ownPlayer2.board);
        players.push(ownPlayer2);

        wsClient.addObserver(ownPlayer);
        wsClient.start();
    }

    override function onResize() {
        bottom.minWidth = bottom.maxWidth = s2d.width;
		bottom.minHeight = bottom.maxHeight = s2d.height;
	}

    override function update(dt:Float) {
        super.update(dt);

        // players.forEach(p -> p.update());
        players.forEach(p -> p.updatePlayer());
        style.sync();
    }

    /*            
    //Needs more functionality
    private function startNewGame(){
        var fullRows: Array<Bool> = [ for(i in 0...FIELD_HEIGHT) true];
        clearFullRows(fullRows);
    }*/

    static function main() {
        #if hl
        Resource.LIVE_UPDATE = true;
        Res.initLocal();
        // Res.initPak();
        #else
        Res.initEmbed();
        #end
        new Game();
    }
    
}