package web;

import view.Color;
import logic.FigureBuilder;
import hxd.Key;
import logic.GameFieldChecker;
import view.ColorProvidable;
import view.LocalColorProvider;
import core.models.Figure;
import h2d.Text;
import view.BlockTilePool;
import logic.BlockPool;

class Player{

    private var figure: Figure;
    private var pool: BlockPool;
    private var tilePool: BlockTilePool;
    private var tf: Text;

    public var playerId(default,default): Int;
    private var lost: Bool = false;

    public function new(){
    }

    public function draw(){
        
    }

    public function initialize(figure: Figure, pool: BlockPool, tilePool: BlockTilePool, tf: Text){
        this.figure = figure;
        this.pool = pool;
        this.tilePool = tilePool;
        this.tf = tf;
    }

}