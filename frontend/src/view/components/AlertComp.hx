package view.components;

import h2d.Tile;
import h2d.Flow;

@:uiComp("alert")
class AlertComp extends Flow implements h2d.domkit.Object {
    
    static var SRC = 
        <alert>
            <flow>
                <flow id="box">
                    <bitmap src={icon} public id="icon" />
                </flow>
                <flow public id="text-wrapper">
                    <text public id="alertText" text={text} />
                </flow>
                <flow public id="btn-wrapper">
                    <button public id="alertBtn" />
                </flow>
            </flow>
        </alert>

    public function new(text: String, icon: Tile, ?parent: h2d.Object) {
        super(parent);
        icon.scaleToSize(90, 90);
        initComponent();
        alertBtn.label = "Ok";
    }
}