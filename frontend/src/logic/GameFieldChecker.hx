package logic;

import core.models.Block;
import core.pattern.observer.Observable;

using core.pattern.observer.ObservableExtender;

class GameFieldChecker implements Observable {

    public function new (){

    }

    //Checks if a Row is full and returns an Array of Integers, which indicate which rows are full
    public function checkRowFull(blocks: Array<Block>): Void{
        var rows: Array<Int> = [ for(x in 0...21) 0 ]; //Size of Field (21 rows)

        //Sum of blocks in a given row
        //If a row reaches value 10 (width of Field), it is full
        for(block in blocks){
            rows[block.y]++;
        }

        //If a given row contains a one, it shows, that this row is full
        var fullRows = rows.map(num -> num/10 == 1 ? true : false);

        fullRows.filter(row -> row).length >= 1 ? this.notify(fullRows) : return;
    }    

}