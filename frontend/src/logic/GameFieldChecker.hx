package logic;

import haxe.ds.ArraySort;
import core.Constants;
import core.models.Figure;
import core.models.Block;

class GameFieldChecker {

    /**
     * [Description]
     * @param blocks 
     * @param move 
     * @param usedBlocks 
     * @return moving allowed
     */
    public static function checkBlockCollision(blocks: Array<Block>, move: String, usedBlocks: Array<Block>): Bool{
        for(block in blocks){
            //Left bound or right bound
            if (collideLeft(block, move) || collideRight(block, move))
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

    private static inline function collideLeft(block: Block, move: String): Bool {
        return block.x == 0 && move == "left";
    }

    private static inline function collideRight(block: Block, move: String): Bool {
        return block.x == Constants.FIELD_WIDTH - 1 && move == "right";
    }

    //Checks if a row is full and returns an Array of Integers, which indicate which rows are full
    public static function checkRowFull(blocks: Array<Block>): Array<Bool> {
        var rows: Array<Int> = [ for(_ in 0...Constants.FIELD_HEIGHT) 0 ]; //Size of Field

        //Sum of blocks in a given row
        //If a row reaches the same value as Game.FIELD_WIDTH, it is full
        for(block in blocks)
            rows[block.y]++;

        //If a given row contains a one, it shows, that this row is full
        var fullRows: Array<Bool> = rows.map(num -> num / Constants.FIELD_WIDTH == 1 ? true : false);
        return fullRows;
    }    

    //Returns true, if a Block from a Figure reaches the bottom of the playing field...
    //... or the edge of another block
    public static function checkBlockReachesBottom(figureBlocks: Array<Block>, usedBlocks: Array<Block>): Bool{
        if (getRowOfLowestBlock(figureBlocks) >= Constants.FIELD_HEIGHT) {
            return true;
        }
        
        for(block in figureBlocks){
            // if(block.y >= Constants.FIELD_HEIGHT) //Bottom of playing field (Game.FIELD_HEIGHT), CURRENT VALUE IS ONLY FOR TESTING PURPOSES
            //     return true;
            // else 
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

    private static function getRowOfLowestBlock(blocks: Array<Block>): Int {
        var rows = blocks.map(b -> b.y);
        ArraySort.sort(rows, (a, b) -> a - b);
        var lowest = rows.pop();
        return lowest;
    }
}
