package logic;

import core.models.Figure;
import core.models.Block;
import core.pattern.observer.Observable;

using core.pattern.observer.ObservableExtender;

class GameFieldChecker implements Observable {

    public function new() {
    }

    public function checkBlockCollision(blocks: Array<Block>, move: String, usedBlocks: Array<Block>): Bool{
        for(block in blocks){
            //Left bound or right bound
            if((block.x == 0 && move == "left") 
                || (block.x == Game.FIELD_WIDTH - 1 && move == "right"))
                return false;

            //Another Block to the left or right
            for(usedBlock in usedBlocks){
                if((block.x - 1 == usedBlock.x && block.y == usedBlock.y)
                    || (block.x + 1 == usedBlock.x && block.y == usedBlock.y))
                    if(blocks.filter(figureBlock -> figureBlock.x == usedBlock.x && figureBlock.y == usedBlock.y).length == 0)
                        return false;             
            }
        }

        return true;
    }

    //Checks if a row is full and returns an Array of Integers, which indicate which rows are full
    public function checkRowFull(blocks: Array<Block>): Void{
        var rows: Array<Int> = [ for(x in 0...Game.FIELD_HEIGHT) 0 ]; //Size of Field

        //Sum of blocks in a given row
        //If a row reaches the same value as Game.FIELD_WIDTH, it is full
        for(block in blocks)
            rows[block.y]++;

        //If a given row contains a one, it shows, that this row is full
        var fullRows = rows.map(num -> num/Game.FIELD_WIDTH == 1 ? true : false);

        //Notifies Observers, if at least one row is filled
        if(fullRows.filter(row -> row).length >= 1){
            this.notify(fullRows);
        }
    }    

    //Returns true, if a Block from a Figure reaches the bottom of the playing field...
    //... or the edge of another block
    public function checkBlockReachesBottom(figureBlocks: Array<Block>, usedBlocks: Array<Block>): Bool{
        for(block in figureBlocks){
            //race("CheckBlockReachesBottom Y is " + block.y);
            if(block.y >= 15) //Bottom of playing field (Game.FIELD_HEIGHT), CURRENT VALUE IS ONLY FOR TESTING PURPOSES
                return true;
            else 
                for(usedBlock in usedBlocks){
                    //If the Block is one above a used Block on the y Axis
                    //Blocks which are from the Figure are filtered out
                    if(block.y + 1 == usedBlock.y && block.x == usedBlock.x)
                        if(figureBlocks.filter(figureBlock -> figureBlock.x == usedBlock.x && figureBlock.y == usedBlock.y).length == 0)
                            return true;   
                }
        }
        return false;
    }

}
