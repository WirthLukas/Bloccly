package web;

import view.ColorProvidable;

class OtherPlayer extends Player{
    public function new(colorProvider: ColorProvidable, parent: h2d.Object, offsetX: Int = 0, offsetY: Int = 0) {
        super(colorProvider, parent, offsetX, offsetY);
    }

    public override function updatePlayer(){
        
    }
}