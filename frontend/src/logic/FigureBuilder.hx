package logic;

import core.models.Figure;
import core.models.Block;

class FigureBuilder {
    public static function getBlue(pool: BlockPool, x: Int, y: Int) {
        var blocks: Array<Block> = [];

        blocks.push(pool.getBlock().withPosition(x, y));
        blocks.push(pool.getBlock().withPosition(x, y + 1));
        blocks.push(pool.getBlock().withPosition(x, y + 2));
        blocks.push(pool.getBlock().withPosition(x, y + 3));

        return new Figure(blocks);
    }
}