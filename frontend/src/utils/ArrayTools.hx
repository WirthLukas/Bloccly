package utils;

class ArrayTools {
    @:generic
    public static function isEmpty<T>(array: Array<T>): Bool {
        return array.length == 0;
    }
}