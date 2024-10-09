package states;

import flixel.effects.FlxFlicker;
import flixel.addons.transition.FlxTransitionableState;
import flash.system.System;

class FinalWarningState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	var warnTextFL:FlxText;
	var PressText:FlxText;

	override function create()
	{
		#if desktop
		// updates precense
		DiscordClient.changePresence("Final Warning", "Being Warned");
		#end
		super.create();

		var bg:FlxSprite = new FlxSprite(FlxG.height, FlxG.width).loadGraphic(Paths.image('WarnFinal'));
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width, "This is your final warning\n
			This mod contains:\n
			Furry Content\n
			Cursing\n
			References to Sex\n
			Additional Unlisted Content", 32);
		warnTextFL = new FlxText(0, 0, FlxG.width, // flashing lights ver
			"This is your final warning\n
			This mod contains:\n
			Flashing Lights (may be disabled depending on last choice)\n
			Furry Content\n
			Cursing\n
			References to Sex\n
			Additional Unlisted Content", 32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT);
		warnTextFL.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT);
		warnText.screenCenter(X);
		warnText.screenCenter(X);
		add(warnText);
		add(warnTextFL);
		warnText.visible = false;
		warnTextFL.visible = false;
		PressText = new FlxText(0, 625, FlxG.width, "Are you sure you want to continue?\n \nPress ENTER to continue anyways", 32);
		PressText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT);
		PressText.screenCenter(X);
		add(PressText);
	}

	override function update(elapsed:Float)
	{
		if (!ClientPrefs.data.flashing)
		{
			warnText.visible = false;
			warnTextFL.visible = true;
		}
		else if (ClientPrefs.data.flashing)
		{
			warnText.visible = true;
			warnTextFL.visible = false;
		};
		if (!leftState)
		{
			var accept:Bool = controls.ACCEPT;
			var back:Bool = controls.BACK;
			if (controls.BACK || accept)
			{
				leftState = true;
				FlxTransitionableState.skipNextTransIn = false;
				FlxTransitionableState.skipNextTransOut = false;
				if (!back)
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker)
					{
						new FlxTimer().start(0.5, function(tmr:FlxTimer)
						{
							MusicBeatState.switchState(new TitleState());
							#if desktop
							// updates precense
							DiscordClient.changePresence("Final Warning", "Proceeding");
							#end
						});
					});
				}
				else
				{
					FlxG.sound.play(Paths.sound('cancelMenu'));
					#if desktop
					// updates precense
					DiscordClient.changePresence("GET", "RICKROLLED!!!!!!!!");
					#end
					FlxTween.tween(warnText, {alpha: 0}, 1, {
						onComplete: function(twn:FlxTween)
						{
							CoolUtil.browserLoad('https://www.youtube.com/watch?v=dQw4w9WgXcQ');
							System.exit(0);
							#if desktop
							DiscordClient.shutdown();
							#end
						}
					});
				}
			}
		}
		super.update(elapsed);
	}
}
