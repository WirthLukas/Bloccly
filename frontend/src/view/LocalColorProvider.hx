package view;

import view.ColorProvidable;

class LocalColorProvider implements ColorProvidable {
    public function new() {
    }

    public function getNextColor(): Color {

        return newColor();
    }

    private function newColor(): Color {
        var x = Math.floor(Math.random() * 100) % 7;
        return switch x {
            case 0: Color.Orange;
            case 1: Color.Cyan;
            case 2: Color.Blue;
            case 3: Color.Green;
            case 4: Color.Purple;
            case 5: Color.Red;
            default: Color.Yellow;
        }
    }
}