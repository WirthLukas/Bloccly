package view.components;

import logic.Score;
import core.pattern.observer.Observable;
import core.pattern.observer.Observer;
import h2d.Flow;

@:uiComp("score")
class ScoreComp extends Flow implements h2d.domkit.Object implements Observer {
    static var SRC =
        <score>
            <flow public id="score-wrapper">
                <text public id="scoretext" text={Std.string(0)} />
            </flow>
        </score>

    public function new(?parent: h2d.Object) {
        super(parent);
        initComponent();

        enableInteractive = true;
		interactive.onOver = function(_) {
			dom.hover = true;
		};
		interactive.onOut = function(_) {
			dom.hover = false;
        };
    }

    public function update(sender: Observable, ?data: Any): Void {
        if (Std.is(sender, Score)) {
            this.scoretext.text = Std.string(Score.getInstance().score);
        }
    }
}