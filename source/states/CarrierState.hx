package states;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxGradient;
import backend.Controls;

class CarrierState extends MusicBeatState
{
	var funkay:FlxSprite;
    var camOther:FlxCamera;
    var camLogo:FlxCamera;
	var grid:FlxBackdrop;
    

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

		grid = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
		grid.velocity.set(40, 40);
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
		camLogo.zoom = FlxMath.lerp(1, camLogo.zoom, 1 - (elapsed * 6));

		camOther.zoom = FlxMath.lerp(1, camOther.zoom, 1 - (elapsed * 3));

		var back:Bool = controls.BACK;
		if (controls.ACCEPT || back)
		{
            //funkay.scale.set(1.55, 1.55);
            camLogo.zoom = 1.1;
            camOther.zoom = 1.07;
			if (!back)
			{/* do nothing */ }
			else
				MusicBeatState.switchState(new MainMenuState());
		}
	}
}
