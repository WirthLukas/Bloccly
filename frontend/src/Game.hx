import web.WebSocketMessage;
import view.ColorProvidable;
import view.LocalColorProvider;
import view.Color;
import h2d.Text;
import hxd.Res;
import hxd.Key;

import core.models.Figure;
import logic.BlockPool;
import logic.FigureBuilder;
import view.BlockTilePool;
import web.WebSocketClient;
import web.CommandType;
import web.Player;
import web.OwnPlayer;
import logic.GameFieldChecker;

// For Extension Method
using core.pattern.observer.ObservableExtender;
using utils.ArrayTools;

class Game extends hxd.App {
    private var colorProvider: ColorProvidable = new LocalColorProvider();

    //Multiplayer variables
    private var lost: Bool = false;
    private var wsClient: WebSocketClient; //= new WebSocketClient("ws://localhost:8100/ws"); //Testing: wss://echo.websocket.org, Server: ws://localhost:8100/ws
    private var playerId = 1;
    private var players: Array<Player> = [];
    private var ownPlayer: OwnPlayer;

    public function new() {
        super();
    }

    override function init() {     
        /*var tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
        tf.text = "Hello World !";

        b = new Bitmap(Tile.fromColor(0xFF0000, 60, 60), s2d);
        b.setPosition(100, 100);
        b.tile.setCenterRatio();    // configure to rotate around itself

        var i = new h2d.Interactive(b.tile.width, b.tile.height, b);
        i.onOver = _ -> b.alpha = 0.5;
        i.onOut = _ -> b.alpha = 1;
        var g = new h2d.Graphics(s2d);
        g.beginFill(0xFF00FF, .5);
        g.drawCircle(200, 200, 100);*/
    
        // figure = newFigureOf(nextColor, BLOCK_START_X, BLOCK_START_Y);
        wsClient = new WebSocketClient("ws://localhost:8100/ws");
        wsClient.onNewPlayerCallback = function(playerId) {
            var newPlayer: Player = new Player(colorProvider, s2d);
            newPlayer.playerId = playerId;
            players.push(newPlayer);
            wsClient.addObserver(newPlayer);
        }
        
        ownPlayer = new OwnPlayer(colorProvider, wsClient, s2d);
        ownPlayer.init();

        players.push(ownPlayer);

        wsClient.addObserver(ownPlayer);
        
        wsClient.start();
    }

    override function update(dt:Float) {
        super.update(dt);

        // for(player in players)
        //     player.update();

        players.forEach(p -> p.updatePlayer());
    }

    /*            
    //Needs more functionality
    private function startNewGame(){
        var fullRows: Array<Bool> = [ for(i in 0...FIELD_HEIGHT) true];
        clearFullRows(fullRows);
    }*/

    static function main() {
        Res.initEmbed();
        new Game();
    }
    
}