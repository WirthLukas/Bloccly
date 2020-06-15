package view.components;

import h2d.Flow;

@:uiComp("border")
class BorderComp extends Flow implements h2d.domkit.Object {
    
    static var SRC =
        <border>
            <flow width={width + 2 * stroke} height={height + stroke}
             content-align="middle top" background="#fff" >
                <flow width={width} height={height} background="#000">
                </flow>
            </flow>
        </border>

    public function new(width: Int, height: Int, stroke: Int, ?parent: h2d.Object) {
        super(parent);
        initComponent();
    }
}