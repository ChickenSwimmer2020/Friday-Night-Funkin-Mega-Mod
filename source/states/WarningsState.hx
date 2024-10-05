package states;

class WarningsState extends MusicBeatState
{
    //arrayed offsets are surprisingly efficient on line space!
    var buttonOffsets:Array<Float>;
    var furryOffsets:Array<Float>;

    //global thingys
    var CurWarning:String = null;

    //buttons images.
    var buttons:FlxSpriteGroup;
        var BACK:FlxSprite;
        var ENTER:FlxSprite;
        var SPACE:FlxSprite;
        var ESCAPE:FlxSprite;

    //flash warning images.
    var flash:FlxSpriteGroup;
        var flashtext1:FlxSprite;
        var flashtext2:FlxSprite;
        var flashscreen:FlxSprite;
        var flashwarnindicator:FlxSprite;

    //furry warning images.
    var furry:FlxSpriteGroup;
        var furtext1:FlxSprite;
        var furtext2:FlxSprite;
        var furbg:FlxSprite;
        var furbf:FlxSprite;
        var furwarnindicator:FlxSprite;


    override function create()
        {
            //global declarations
            //if(CurWarning == null) CurWarning = 'Flashing' tba
            if(CurWarning == null) CurWarning = 'Furry';
            buttonOffsets = new Array();
            //offset arrays are in standard X/Y format
            //               back      enter  esca     space     scale
            buttonOffsets = [280, 145, 0, 10, 80, 145, 210, 10,  0.5, 0.5];
            buttons = new FlxSpriteGroup(); //for quick loading and instant offsets
                BACK = new FlxSprite(buttonOffsets[0], buttonOffsets[1]);
                    BACK.frames = Paths.getSparrowAtlas('Warnings/BACK');
                    BACK.animation.addByPrefix('press', 'backspace_smash', 24, true);
                    BACK.animation.play('press');
                    BACK.scale.set(buttonOffsets[8], buttonOffsets[9]);
                    BACK.updateHitbox();
                    BACK.antialiasing = ClientPrefs.data.antialiasing;
                ENTER = new FlxSprite(buttonOffsets[2], buttonOffsets[3]);
                    ENTER.frames = Paths.getSparrowAtlas('Warnings/ENTER');
                    ENTER.animation.addByPrefix('press', 'enterbutton_smash', 24, true);
                    ENTER.animation.play('press');
                    ENTER.scale.set(buttonOffsets[8], buttonOffsets[9]);
                    ENTER.updateHitbox();
                    ENTER.antialiasing = ClientPrefs.data.antialiasing;
                ESCAPE = new FlxSprite(buttonOffsets[4], buttonOffsets[5]);
                    ESCAPE.frames = Paths.getSparrowAtlas('Warnings/ESCAPE');
                    ESCAPE.animation.addByPrefix('press', 'escapekey_smash', 24, true);
                    ESCAPE.animation.play('press');
                    ESCAPE.scale.set(buttonOffsets[8], buttonOffsets[9]);
                    ESCAPE.updateHitbox();
                    ESCAPE.antialiasing = ClientPrefs.data.antialiasing;
                SPACE = new FlxSprite(buttonOffsets[6], buttonOffsets[7]);
                    SPACE.frames = Paths.getSparrowAtlas('Warnings/SPACE');
                    SPACE.animation.addByPrefix('press', 'spacebar_smash', 24, true);
                    SPACE.animation.play('press');
                    SPACE.scale.set(buttonOffsets[8], buttonOffsets[9]);
                    SPACE.updateHitbox();
                    SPACE.antialiasing = ClientPrefs.data.antialiasing;
            buttons.add(BACK);
            buttons.add(ENTER);
            buttons.add(ESCAPE);
            buttons.add(SPACE);
            //furry items declarations
            furry = new FlxSpriteGroup();
            furryOffsets = new Array();
            //              txt1  txt2     bg
            furryOffsets = [0, 0, 0, 310, -160, -50];
            
                furbg = new FlxSprite(furryOffsets[4], furryOffsets[5]);
                furbg.frames = Paths.getSparrowAtlas('Warnings/FURRY_SEPERATOR');
                furbg.animation.addByPrefix('dastage', 'SEPERATOR_furry', 24, true);
                furbg.animation.play('dastage');
                furbg.antialiasing = ClientPrefs.data.antialiasing;
                furry.add(furbg);

                furtext1 = new FlxSprite(furryOffsets[0], furryOffsets[1]);
                furtext1.frames = Paths.getSparrowAtlas('Warnings/FURRY_TEXT1');
                furtext1.animation.addByPrefix('Shift', 'furrywarning_textOne', 24, true, false, false);
                furtext1.animation.play('Shift');
                furtext1.scale.set(0.5, 0.5);
                furtext1.updateHitbox();
                furtext1.antialiasing = ClientPrefs.data.antialiasing;
                furry.add(furtext1);

                furtext2 = new FlxSprite(furryOffsets[2], furryOffsets[3]);
                furtext2.frames = Paths.getSparrowAtlas('Warnings/FURRY_TEXT2');
                furtext2.animation.addByPrefix('Shift', 'furrywarning_textTwo', 24, true, false, false);
                furtext2.animation.play('Shift');
                furtext2.scale.set(0.5, 0.5);
                furtext2.updateHitbox();
                furtext2.antialiasing = ClientPrefs.data.antialiasing;
                furry.add(furtext2);


            
            add(furry);
            add(buttons); //keep at bottom so it renders over everything
            //if(CurWarning != null && CurWarning == 'Flashing') TBA

            if(CurWarning != null && CurWarning == 'Furry')
            {

            }
        }
}