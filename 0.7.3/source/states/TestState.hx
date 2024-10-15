//made for testing of custom states, not fully accessible through normal means as code for keypress detection on main menu is
//commented out, since its for testing purposes only
package states;

import flixel.addons.display.FlxSliceSprite;
import tjson.TJSON;

typedef Offsets = {
    TextY:Float,
    TextX:Float,
    EnterY:Float,
    EnterX:Float,
}

class TestState extends MusicBeatState
{
    var Pos:Offsets;
    var text:FlxText;
    var Enter:FlxSprite;

    override public function create() {
        Pos = tjson.TJSON.parse(Paths.getTextFromFile('data/NAME.json'));
        //text stuff
        text = new FlxText(Pos.TextX, Pos.TextY, 0, "", 24, false);
        text.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, true);
        text.text = "[PUT YOUR TEXT HERE]";
        add(text);

        Enter = new FlxSprite(Pos.EnterX, Pos.EnterY).loadGraphic(Paths.image('ENTER'));
    }
}