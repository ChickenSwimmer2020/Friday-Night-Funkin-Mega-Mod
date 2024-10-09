package states;

import substates.GameplayChangersSubstate.GameplayOption;
import lime.app.Application;
import flixel.system.FlxAssets;
import backend.WindowsAPI;

class TransparencyWarningState extends MusicBeatState
{
	var Text:FlxText;
	var leftState:Bool = false;

	override public function create()
	{
		Text = new FlxText(0, 0, 0, 'WARNING\n
        if the background of this window is black instead of transparent,\nthat means that some effects will be broken!\n
        if the background is black, please press the BACK key now\notherwise, press the ENTER key.', 8, true);
		Text.setFormat(FlxAssets.FONT_DEFAULT, 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, false);
		Text.antialiasing = false;
		Text.screenCenter(X);
		add(Text);
		Application.current.window.borderless = true;
		WindowsAPI.setWindowTransparencyColor(0, 0, 0, 255);
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.mouse.cursor.visible)
			FlxG.mouse.cursor.visible = false;

		if (!leftState)
		{
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back)
			{
				leftState = true;
				if (!back)
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));
					if (ClientPrefs.data.flashing)
					{
						ClientPrefs.data.WindowTransparency = true;
						Text.text = 'Window transparency enabled!';
						Text.size = 24;
						Text.screenCenter();

						Functions.wait(0.1, () -> {
							Application.current.window.borderless = false;
							WindowsAPI.disableWindowTransparency(true);
						});

						new FlxTimer().start(1, function(tmr:FlxTimer)
						{
								MusicBeatState.switchState(new GameIntro());
						});
					};
				}
				else
				{
					FlxG.sound.play(Paths.sound('cancelMenu'));
					new FlxTimer().start(1.83, function(tmr:FlxTimer)
					{
						ClientPrefs.data.WindowTransparency = false;
						WindowsAPI.disableWindowTransparency(true);
						Text.text = 'Window transparency disabled...';
						Text.size = 24;
						Text.screenCenter();
						MusicBeatState.switchState(new GameIntro());
					});
				}
			}
		}
	}
}
