package states;

class Warnings extends MusicBeatState
{
    //arrayed offsets are surprisingly efficient on line space!
    var buttonOffsets:Array<Int>;

    //global thingys
    var buttons:FlxSpriteGroup;
        var BACK:FlxSprite;
        var ENTER:FlxSprite;
        var SPACE:FlxSprite;
        var ESCAPE:FlxSprite;

    //furry warning images.
    //var furry:FlxTypedGroup<Dynamic>; if needed
    var furry:FlxSpriteGroup;
        var furtext1:FlxSprite;
        var furtext2:FlxSprite;
        var furbf:FlxSprite;
        var furwarnindicator:FlxSprite;


    override function create()
        {
            buttonOffsets = new Array();
            //offset arrays are in standard X/Y format
            //               back  enter esca  space
            buttonOffsets = [0, 0, 0, 0, 0, 0, 0, 0];
            //TODO: make the other buttons go on an offset position of the back button
            buttons = new FlxSpriteGroup(); //for quick loading and instant offsets
            add(buttons);

                BACK = new FlxSprite(buttonOffsets[0], buttonOffsets[1]);
                    BACK.frames = Paths.getSparrowAtlas('Warnings/BACK');
                    BACK.animation.addByPrefix('press', 'backspace_smash', 24, true);
                    BACK.animation.play('press');
                ENTER = new FlxSprite(buttonOffsets[2], buttonOffsets[3]);
                    ENTER.frames = Paths.getSparrowAtlas('Warnings/ENTER');
                    ENTER.animation.addByPrefix('press', 'enterbutton_smash', 24, true);
                    ENTER.animation.play('press');
                ESCAPE = new FlxSprite(buttonOffsets[4], buttonOffsets[5]);
                    ESCAPE.frames = Paths.getSparrowAtlas('Warnings/ESCAPE');
                    ESCAPE.animation.addByPrefix('press', 'escapekey_smash', 24, true);
                    ESCAPE.animation.play('press');
                SPACE = new FlxSprite(buttonOffsets[6], buttonOffsets[7]);
                    SPACE.frames = Paths.getSparrowAtlas('Warnings/SPACE');
                    SPACE.animation.addByPrefix('press', 'spacebar_smash', 24, true);
                    SPACE.animation.play('press');

            buttons.add(BACK);
            buttons.add(ENTER);
            buttons.add(ESCAPE);
            buttons.add(SPACE);
           
        }
}