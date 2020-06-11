package logic;

import core.models.Figure;
import core.models.Block;
import core.pattern.observer.Observable;

using core.pattern.observer.ObservableExtender;

class GameFieldChecker implements Observable {

    public function new (){

    }

    //Checks if a row is full and returns an Array of Integers, which indicate which rows are full
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

    //Returns true, if a Block from a Figure reaches the bottom of the playing field...
    //or the edge of another block
    public function checkBlockReachesBottom(figure: Figure, usedBlocks: Array<Block>): Bool{
        for(block in figure.blocks){
            //race("CheckBlockReachesBottom Y is " + block.y);
            if(block.y >= 10) //Bottom of playing field
                return true;
            else {
                for(usedBlock in usedBlocks){
                    //If the Block is one above a used Block on the y Axis
                    //Blocks which are from the Figure are filtered out
                    if(block.y + 1 == usedBlock.y && block.x == usedBlock.x)
                        if(figure.blocks.filter(figureBlock -> figureBlock.x == usedBlock.x && figureBlock.y == usedBlock.y).length == 0){
                            trace("Length: " + figure.blocks.filter(figureBlock -> figureBlock.x != usedBlock.x && figureBlock.y != usedBlock.y).length);
                            return true;
                        }
                }
            }

        }

        return false;
    }


}