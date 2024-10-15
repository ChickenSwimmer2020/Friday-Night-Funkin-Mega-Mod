package objects;

import flixel.input.keyboard.FlxKeyboard;
import flixel.input.keyboard.FlxKey;

import backend.Controls;

import states.OverWorldState;


class Overworld_player extends FlxSprite
{

    private var state:OverWorldState;
    public var playersprite:FlxSprite;

    public function new(x:Float, y:Float)
        {
            var SkinTypes:Array<String> = [
                'Player_Default',
                'Player_Cave',
                'Player_Mine'
            ];

            super(x, y);
            
            if(state.CurrentWorld == 'null')
                {
                    playersprite.frames = Paths.getSparrowAtlas('overworld/player/' + SkinTypes[0]);
                }
            else if(state.CurrentWorld == 'CS+')
                {
                    playersprite.frames = Paths.getSparrowAtlas('overworld/player/' + SkinTypes[1]);
                }
            else if(state.CurrentWorld == 'MC')
                {
                    playersprite.frames = Paths.getSparrowAtlas('overworld/player/' + SkinTypes[2]);
                }
            else if(state.CurrentWorld == 'DEBUG')
                {
                    //dosomething
                }
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
           //INDICES ARE FUCKING WEIRD :sob:
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
           //not implemented, kept to prevent crashes
           playersprite.animation.addByIndices('MU', 'MOVE', [], "", 24, true);
           playersprite.animation.addByIndices('ML', 'MOVE', [], "", 24, true);
           playersprite.animation.addByIndices('MR', 'MOVE', [], "", 24, true);
           playersprite.animation.addByIndices('MD', 'MOVE', [], "", 24, true);
            if(state.CurrentWorld == 'CS+')
            {
                playersprite.antialiasing = false;
            }
            else
            {
                playersprite.antialiasing = ClientPrefs.data.antialiasing;
            }
            
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
                if (FlxG.keys.pressed.DOWN && !state.TwoDimensional)
                {
                    y + 1;
                }
                else if(state.TwoDimensional)
                {
                    //Use();
                };
                if (FlxG.keys.pressed.UP && !state.TwoDimensional)
                {
                    y - 1;
                };
                else if(state.TwoDimensional)
                {
                    //jump();
                };
    };
}