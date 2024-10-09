// OVERWORLD FADUQ WHAT?!?!?!?!!?!?
// yes, its overused. mario's madness did it first. IDGAF IM DOING IT TO GET SECRET SONGS!!!!!!!!!!!!!!
package states;

import flixel.input.keyboard.FlxKey;
import haxe.Json;
import objects.*;

class OverWorldState extends MusicBeatState
{
	// hehe. code go BRRRRRRRRRRRRRRRRR
	var Player:Overworld_player;

	// current world state
	public var CurrentWorld:String = 'null';

	// used for cavestory mode only
	public var TwoDimensional:Bool = false;

	// current skin selection
	// mainly set as a string so it can be updated dynamically
	// for instance, being in the cave story world would run
	// function update(elapsed:Float)
	// if(CurrentSkin == 'null' && CurrentWorld == 'CaveStory')
	//  {
	//     CurrentSkin = 'Cave'
	//  }
	public var CurrentSkin:String = 'null';

	var BG:FlxSprite;
	var isInDialouge:Bool = false;

	override function create()
	{
		// custom functions
		function getCurWorld()
		{
			trace(CurrentWorld);
			return CurrentWorld;
		}
		function setCurWorld(WorldToSet:String = '')
		{
			CurrentWorld = WorldToSet;
			trace('set current world to: ' + WorldToSet);
		}
		function getCurPlayerSkin()
		{
			trace(CurrentSkin);
			return CurrentSkin;
		}
		function setCurPlayerSkin(SkinToSet:String = '')
		{
			CurrentSkin = SkinToSet;
			trace('set current player skin to: ' + SkinToSet);
		}
		// end of custom functions
		// BG.frames = Paths.getSparrowAtlas('overworld/world/worlds.png');
		// BG.animation.addByIndices('Default', 'WORLD', [0], "", 0, true, false, false,);
		// BG.animation.addByIndices('Cave', 'WORLD', [1], "", 0, true, false, false,);
		// BG.animation.addByIndices('Mine', 'WORLD', [2], "", 0, true, false, false,);
		// force current world to be default on startup
		if (CurrentWorld == 'null')
		{
			CurrentWorld = 'Default';
		}
		Player = new Overworld_player(0, 0);
		add(Player);
	};

	override function update(elapsed:Float)
	{
		// world state detection
		// and skin forcing.
		// if(CurrentWorld == 'default')
		//    {
		//        BG.animation.play('Default');
		//        BG.antialiasing = ClientPrefs.data.antialiasing;
		//    }
		// if(CurrentWorld == 'Cave')
		//    {
		//        BG.animation.play('Cave');
		//        TwoDimensional = true;
		//        BG.antialiasing = false;
		//    }
		//
		// lets you go back to menu.
		if (controls.BACK && !isInDialouge)
		{
			MusicBeatState.switchState(new MainMenuState());
		}
	}
}
