package options;

import openfl.filters.BlurFilter;
import flixel.addons.transition.FlxTransitionSprite.TransitionStatus;
import states.MainMenuState;
import backend.StageData;

import openfl.geom.Point;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import openfl.geom.Rectangle;
import openfl.Assets;
import openfl.display.ShaderInput;
import openfl.filters.ShaderFilter;
import openfl.display.Shader;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;

typedef GearsLocations = 
{
	GearsX:Float,
	GearsY:Float,
	GearsScale:Float,
	BgX:Float,
	BgY:Float,
}

class OptionsState extends MusicBeatState
{
	var options:Array<String> = ['Note Colors', 'Controls', 'Adjust Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay', 'MegaMod Options'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	var bg2:FlxSprite;
	public static var onPlayState:Bool = false;

	public var Leaving:Bool = false;

	var Offsets:GearsLocations;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Note Colors':
				openSubState(new options.NotesSubState());
			case 'Controls':
				openSubState(new options.ControlsSubState());
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals and UI':
				openSubState(new options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				MusicBeatState.switchState(new options.NoteOffsetState());
			case 'MegaMod Options':
				openSubState(new options.MegaModOptionsSubState());
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create() {
		
		if(FlxG.sound.music != null)
			{
				Leaving = false;
				FlxG.sound.music.stop();
				FlxG.sound.playMusic(Paths.music('Settings/SMBasic'), 1, true);
			}
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Options", null);
		#end

		Offsets = tjson.TJSON.parse(Paths.getTextFromFile('data/OptionsMenu/offsets.json'));

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('OptionsMenu/Background'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.color = 0xFFFFFFFF;
		bg.updateHitbox();
		bg.screenCenter();
		bg.x = Offsets.BgX;
		bg.y = Offsets.BgY;
		add(bg);

		bg2 = new FlxSprite(Offsets.GearsX, Offsets.GearsY);
		bg2.scale.x = Offsets.GearsScale;
		bg2.scale.y = Offsets.GearsScale;
		bg2.antialiasing = ClientPrefs.data.antialiasing;
		bg2.frames = Paths.getSparrowAtlas('OptionsMenu/Gears');
		bg2.animation.addByPrefix('spin', 'optionsbg_gears', 24, true, false, false);
		add(bg2);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, ' ', true);
		add(selectorRight);

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
		if(!Leaving && FlxG.sound.music == null)
			FlxG.sound.playMusic(Paths.music('Settings/SMBasic'), 1, true);
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Options", null);
		#end
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		bg2.animation.play('spin');

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			if(onPlayState)
			{
				StageData.loadDirectory(PlayState.SONG);
				LoadingState.loadAndSwitchState(new PlayState());
				FlxG.sound.music.volume = 0;
			}
			else 
			{
				MusicBeatState.switchState(new MainMenuState());
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 1);
				Leaving = true;
			}
		}
		else if (controls.ACCEPT) openSelectedSubstate(options[curSelected]);
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	override function destroy()
	{
		ClientPrefs.loadPrefs();
		super.destroy();
	}
}