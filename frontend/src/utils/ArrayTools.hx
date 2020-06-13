package utils;

import haxe.ds.ArraySort;

class ArrayTools {
    @:generic
    public static function isEmpty<T>(array: Array<T>): Bool return array.length == 0;

    @:generic
    public static function forEach<T>(array: Array<T>, action: (item: T) -> Void)
        for (item in array) 
            action(item);
}