package view.components;

@:uiComp("container")
class ContainerComp extends h2d.Flow implements h2d.domkit.Object {

	static var SRC = <container>
		<button public id="btn"/>
	</container>;

	public function new(?parent) {
		super(parent);
		initComponent();
	}

}