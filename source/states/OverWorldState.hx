//OVERWORLD FADUQ WHAT?!?!?!?!!?!?
//yes, its overused. mario's madness did it first. IDGAF IM DOING IT TO GET SECRET SONGS!!!!!!!!!!!!!!
package states;

import flixel.input.keyboard.FlxKey;

import haxe.Json;

import objects.*;

class OverWorldState extends MusicBeatState
{
    //hehe. code go BRRRRRRRRRRRRRRRRR
    var Player:Overworld_player;

    public var CurrentWorld:String = 'null';

    var BG:FlxSprite;
    override function create()
    {
        add(Player);
    };
    override function update(elapsed:Float)
    {
        if(CurrentWorld == 'null')
            {
                
            }
        if(controls.BACK)
        {
            MusicBeatState.switchState(new MainMenuState());
        }
    }
}