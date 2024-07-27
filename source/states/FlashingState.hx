package states;
import lime.app.Application;

import openfl.text.TextFormat;
import openfl.text.TextField;

import flixel.FlxSubState;
import flixel.effects.FlxFlicker;
import flixel.addons.transition.FlxTransitionableState;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	var PressText:FlxText;
	override function create()
	{
		super.create();


			var bg:FlxSprite = new FlxSprite(FlxG.height, FlxG.width).loadGraphic(Paths.image('Flash'));
			add(bg);
			
			var TWb:FlxSprite;
			TWb = new FlxSprite(-10, 615).loadGraphic(Paths.image('TitleScreen/textwrapper_bottom_flash'));
			add(TWb);

		warnText = new FlxText(0, 0, FlxG.width,
			"Hey, watch out!\n
			This Mod contains some flashing lights!\n
			You've been warned!",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT);
		warnText.screenCenter(X);
		add(warnText);
		PressText = new FlxText(0, 645, FlxG.width, "Press ESCAPE to disable flashing lights\n \nPress ENTER to keep flashing lights", 32);
		PressText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT);
		PressText.screenCenter(X);
		add(PressText);
	}

	override function update(elapsed:Float)
	{

		if(!leftState) {
			var accept:Bool = controls.ACCEPT;
			var back:Bool = controls.BACK;
			if (controls.BACK || accept) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if(!back) {
					ClientPrefs.data.flashing = false;
					ClientPrefs.saveSettings();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker) {
						new FlxTimer().start(0.5, function (tmr:FlxTimer) {
							MusicBeatState.switchState(new FurryState());
							#if desktop
							//updates precense
							DiscordClient.changePresence("Flashing Lights Warning", "Proceeding without flashing lights");
							#end
						});
					});
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					FlxTween.tween(warnText, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween) {
							MusicBeatState.switchState(new FurryState());
								#if desktop
								//updates precense
								DiscordClient.changePresence("Flashing Lights Warning", "Proceeding with flashing lights");
								#end
						}
					});
				}
			}
		}
	#if desktop
	//updates precense
	DiscordClient.changePresence("Flashing Lights Warning", "Being Warned");
	#end
		super.update(elapsed);
	}
}
