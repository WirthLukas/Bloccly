package logic;

import core.models.Figure;
import core.models.Block;

class FigureBuilder {
    public static function getCyan(pool: BlockPool, x: Int, y: Int) {
        var blocks: Array<Block> = [];

        blocks.push(pool.getBlock().withPosition(x, y));
        blocks.push(pool.getBlock().withPosition(x, y + 1));
        blocks.push(pool.getBlock().withPosition(x, y + 2));
        blocks.push(pool.getBlock().withPosition(x, y + 3));

        return new Figure(blocks);
    }

    public static function getPurple(pool: BlockPool, x: Int, y: Int) {
        var blocks: Array<Block> = [];

        blocks.push(pool.getBlock().withPosition(x, y));
        blocks.push(pool.getBlock().withPosition(x - 1, y + 1));
        blocks.push(pool.getBlock().withPosition(x, y + 1));
        blocks.push(pool.getBlock().withPosition(x + 1, y + 1));

        return new Figure(blocks);
    }

    public static function getRed(pool: BlockPool, x: Int, y: Int) {
        var blocks: Array<Block> = [];

        blocks.push(pool.getBlock().withPosition(x, y));
        blocks.push(pool.getBlock().withPosition(x - 1, y));
        blocks.push(pool.getBlock().withPosition(x, y + 1));
        blocks.push(pool.getBlock().withPosition(x + 1, y + 1));

        return new Figure(blocks);
    }

    public static function getGreen(pool: BlockPool, x: Int, y: Int) {
        var blocks: Array<Block> = [];

        blocks.push(pool.getBlock().withPosition(x, y));
        blocks.push(pool.getBlock().withPosition(x + 1, y));
        blocks.push(pool.getBlock().withPosition(x, y + 1));
        blocks.push(pool.getBlock().withPosition(x - 1, y + 1));

        return new Figure(blocks);
    }

    public static function getYellow(pool: BlockPool, x: Int, y: Int) {
        var blocks: Array<Block> = [];

        blocks.push(pool.getBlock().withPosition(x, y));
        blocks.push(pool.getBlock().withPosition(x + 1, y));
        blocks.push(pool.getBlock().withPosition(x, y + 1));
        blocks.push(pool.getBlock().withPosition(x + 1, y + 1));

        return new Figure(blocks);
    }

    public static function getBlue(pool: BlockPool, x: Int, y: Int) {
        var blocks: Array<Block> = [];

        blocks.push(pool.getBlock().withPosition(x, y));
        blocks.push(pool.getBlock().withPosition(x + 1, y));
        blocks.push(pool.getBlock().withPosition(x, y + 1));
        blocks.push(pool.getBlock().withPosition(x, y + 2));

        return new Figure(blocks);
    }

    public static function getOrange(pool: BlockPool, x: Int, y: Int) {
        var blocks: Array<Block> = [];

        blocks.push(pool.getBlock().withPosition(x, y));
        blocks.push(pool.getBlock().withPosition(x - 1, y));
        blocks.push(pool.getBlock().withPosition(x, y + 1));
        blocks.push(pool.getBlock().withPosition(x, y + 2));

        return new Figure(blocks);
    }
}