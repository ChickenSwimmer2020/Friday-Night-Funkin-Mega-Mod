package objects;

import flixel.input.keyboard.FlxKeyboard;
import flixel.input.keyboard.FlxKey;

import backend.Controls;

typedef TitleData =
{
    DefaultSkin:Bool,
    MineSkin:Bool,
    CSPLUSSkin:Bool,
    //GlitchSkin:Bool
}

class Overworld_player extends FlxSprite
{
    public var playersprite:FlxSprite;

    public function new(x:Float, y:Float)
        {
            super(x, y);
            
            playersprite.frames = Paths.getSparrowAtlas('overworld/player');
            //was less efficent because it requires more xml data
            // playersprite.animation.addByPrefix('idle_down', 'ID', 24, true);
            // playersprite.animation.addByPrefix('idle_up', 'IU', 24, true);
            // playersprite.animation.addByPrefix('idle_left', 'IL', 24, true);
            // playersprite.animation.addByPrefix('idle_right', 'IR', 24, true);
            // playersprite.animation.addByPrefix('move_down', 'MD', 24, true);
            // playersprite.animation.addByPrefix('move_up', 'MU', 24, true);
            // playersprite.animation.addByPrefix('move_left', 'ML', 24, true);
            // playersprite.animation.addByPrefix('move_right', 'MR', 24, true);

           //idle
           //INSTANCES ARE FUCKING WEIRD :sob:
           //0, 1 = idleL
           //2, 3 = idleU
           //4, 5 = idleD
           //6, 7 = idleR
           //EVEN THOUGH THE FLA HAS 8 AHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
           playersprite.animation.addByIndices('IU', 'IDLE', [2, 3], "", 24, true);
           playersprite.animation.addByIndices('IL', 'IDLE', [0, 1], "", 24, true);
           playersprite.animation.addByIndices('IR', 'IDLE', [6, 7], "", 24, true);
           playersprite.animation.addByIndices('ID', 'IDLE', [4, 5], "", 24, true);

           //moving
           playersprite.animation.addByIndices('MU', 'MOVE', [], "", 24, true);
           playersprite.animation.addByIndices('ML', 'MOVE', [], "", 24, true);
           playersprite.animation.addByIndices('MR', 'MOVE', [], "", 24, true);
           playersprite.animation.addByIndices('MD', 'MOVE', [], "", 24, true);
            antialiasing = ClientPrefs.data.antialiasing;
        }
    override function update(elapsed:Float)
    {
        //this is where the code gets horrible... MOVEMENT. GAHHHHHHHHHHH
        //i hate my life, why did i do this
                if (FlxG.keys.pressed.LEFT)
                {
                    x + 1;
                };
                if (FlxG.keys.pressed.RIGHT)
                {
                    x - 1;
                };
                if (FlxG.keys.pressed.DOWN)
                {
                    y + 1;
                };
                if (FlxG.keys.pressed.UP)
                {
                    y - 1;
                };
    };
}