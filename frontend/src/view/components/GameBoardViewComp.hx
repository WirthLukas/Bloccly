package view.components;

import h2d.Flow;

@:uiComp("board")
class GameBoardViewComp extends Flow implements h2d.domkit.Object {
    
    static var SRC =
        <board>
            <border(width, height, 5) />            
        </board>

    public function new(width: Int, height: Int, ?parent: h2d.Object) {
        super(parent);
        initComponent();
    }
}