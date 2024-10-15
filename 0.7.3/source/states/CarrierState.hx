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

	override public function create()
	{
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
