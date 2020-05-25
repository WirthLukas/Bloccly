package contracts;

@:generic
interface Placeable<T> {
    public var x(default, null): T;
    public var y(default, null): T;
}