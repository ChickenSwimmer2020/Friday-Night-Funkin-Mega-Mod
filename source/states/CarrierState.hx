package states;

import openfl.Assets;
import backend.StageData;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxGradient;
import backend.Controls;

class CarrierState extends MusicBeatState
{
	var funkay:FlxSprite;
	var camOther:FlxCamera;
	var camLogo:FlxCamera;
	var grid:FlxSprite;

	var Bop:Bool = false;

	var target:FlxState;
	var stopMusic = false;
	var directory:String;

	function new(target:FlxState, stopMusic:Bool, directory:String)
	{
		super();
		this.target = target;
		this.stopMusic = stopMusic;
		this.directory = directory;
	}

	static function isSoundLoaded(path:String):Bool
	{
		trace(path);
		return Assets.cache.hasSound(path);
	}

	static function getSongPath()
	{
		return Paths.inst(PlayState.SONG.song);
	}

	static function getVocalPath()
	{
		return Paths.voices(PlayState.SONG.song);
	}

	static function isLibraryLoaded(library:String):Bool
	{
		return Assets.getLibrary(library) != null;
	}

	inline static public function loadAndSwitchState(target:FlxState, stopMusic = false)
	{
		MusicBeatState.switchState(getNextState(target, stopMusic));
	}

	static function getNextState(target:FlxState, stopMusic = false):FlxState
	{
		var directory:String = 'shared';
		var weekDir:String = StageData.forceNextDirectory;
		StageData.forceNextDirectory = null;

		if (weekDir != null && weekDir.length > 0 && weekDir != '')
			directory = weekDir;

		Paths.setCurrentLevel(directory);
		trace('Setting asset folder to ' + directory);

		var loaded:Bool = false;
		if (PlayState.SONG != null)
		{
			loaded = isSoundLoaded(getSongPath())
				&& (!PlayState.SONG.needsVoices || isSoundLoaded(getVocalPath()))
				&& isLibraryLoaded('week_assets');
		}

		if (!loaded)
			return new CarrierState(target, stopMusic, directory);
		else
			loaded = true;

		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();

		return target;
	}

	function onLoad()
	{
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();

		MusicBeatState.switchState(target);
	}

	override public function create()
	{
		FlxG.watch.addQuick('Song Position', Conductor.songPosition);
		camOther = new FlxCamera();
		camLogo = new FlxCamera();
		camOther.bgColor.alpha = 0;
		camLogo.bgColor.alpha = 0;
		FlxG.cameras.add(camOther, false);
		FlxG.cameras.add(camLogo, false);

		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xffcaff4d);
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

		grid = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x38000000, 0x0));
		grid.velocity.set(200, 110);
		grid.alpha = 1;
		grid.camera = camOther;
		add(grid);

		funkay = new FlxSprite(-250, 0).loadGraphic(Paths.image('funkay'));
		funkay.antialiasing = ClientPrefs.data.antialiasing;
		funkay.scale.set(0.5, 0.5);
		funkay.screenCenter();
		funkay.camera = camLogo;

		add(funkay); // keep at bottom so it goes on top of the bg
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		Conductor.bpm = 114;
		Conductor.songPosition = FlxG.sound.music.time;

		camLogo.zoom = FlxMath.lerp(1, camLogo.zoom, 1 - (elapsed * 6));
		camOther.zoom = FlxMath.lerp(1, camOther.zoom, 1 - (elapsed * 3));
		var back:Bool = controls.BACK;
		if (controls.ACCEPT || back)
		{
			if (!back)
			{/* do nothing */}
			else
				MusicBeatState.switchState(new MainMenuState());
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if (camLogo != null && camOther != null)
		{
			Bop = !Bop;
			if (Bop)
			{
				camLogo.zoom = 1.1;
				camOther.zoom = 1.07;
			}
			else
			{
				camLogo.zoom = 1.1;
				camOther.zoom = 1.07;
			}
		}
	}
}
