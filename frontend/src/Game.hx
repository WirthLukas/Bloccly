import h3d.shader.ColorKey;
import h3d.shader.ColorAdd;
import hxd.res.DefaultFont;
import hxd.res.Resource;
import h2d.Flow.FlowAlign;
import hxd.res.Sound;
import core.Constants;
import h2d.Flow.FlowLayout;
import view.components.ContainerComp;
import view.components.GameBoardViewComp;
import view.components.AlertComp;
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
    public static var test = 10;

    //Multiplayer variables
    private var lost: Bool = false;
    private var wsClient = new WebSocketClient("wss://echo.websocket.org"); //Testing: wss://echo.websocket.org, Server: ws://localhost:8100/ws
    private var playerId = 1;
    private var players: Array<Player> = [];
    private var ownPlayer: OwnPlayer;

    var center : h2d.Flow;
    var bottom: h2d.Flow;
    var style: h2d.domkit.Style;

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

        // var root = new ContainerComp(center);
        // root.btn.label = "Button";
        var root = new GameBoardViewComp(
            Constants.BLOCK_WIDTH * Constants.FIELD_WIDTH,
            Constants.BLOCK_HEIGHT * (Constants.FIELD_HEIGHT + 1),
            s2d);

        // root.setPosition(root.x + 2, root.y);

        style = new h2d.domkit.Style();
		style.load(hxd.Res.style);
        style.addObject(root);
        style.allowInspect = true;

        // center = new h2d.Flow(s2d);
        // center.horizontalAlign = center.verticalAlign = Middle;
        // // center.horizontalAlign = Right;
        // onResize();

        bottom = new h2d.Flow(s2d);
        bottom.horizontalAlign = Middle;
        bottom.verticalAlign = FlowAlign.Bottom;
        onResize();

        ownPlayer = new OwnPlayer(colorProvider, wsClient, s2d);
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

        players.push(ownPlayer);
    }

    override function onResize() {
		// center.minWidth = center.maxWidth = s2d.width;
        // center.minHeight = center.maxHeight = s2d.height;
        bottom.minWidth = bottom.maxWidth = s2d.width;
		bottom.minHeight = bottom.maxHeight = s2d.height;
	}

    override function update(dt:Float) {
        super.update(dt);

        // for(player in players)
        //     player.update();

        players.forEach(p -> p.update());
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
        #else
        Res.initEmbed();
        #end
        new Game();
    }
    
}