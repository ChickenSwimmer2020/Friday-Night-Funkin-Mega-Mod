package states;

import flixel.FlxSubState;

import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flash.system.System;

class FurryState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var FurText:FlxText;
	var PressText:FlxText;
	override function create()
	{
			super.create();
			
				var bg:FlxSprite;
					var bgpic:FlxSprite;
				bg = new FlxSprite(595, -35); //(595, -10)
					bgpic = new FlxSprite(300, -350);
				bg.frames = Paths.getSparrowAtlas('TitleScreen/Fur');
					bgpic.frames = Paths.getSparrowAtlas('TitleScreen/Fur_2');
				bg.animation.addByPrefix('furrysrule', "amogus", 24, true);
					bgpic.animation.addByPrefix('UwU', "dapicturtes", 24, true);
				bg.antialiasing = ClientPrefs.data.antialiasing;
					bgpic.antialiasing = ClientPrefs.data.antialiasing;
				bg.animation.play('furrysrule');
					bgpic.animation.play('UwU');
				add(bg);
					add(bgpic);
					bgpic.scale.x = 0.4;
					bgpic.scale.y = 0.4;

			
				var TWb:FlxSprite;
				TWb = new FlxSprite(-10, 615).loadGraphic(Paths.image('TitleScreen/textwrapper_bottom'));
				TWb.antialiasing = ClientPrefs.data.antialiasing;
				add(TWb);

			FurText = new FlxText(0, 0, FlxG.width,
				"Yo, this mod was made by a furry.\n
				if you wanna be a little child and cry about it,\n
				leave your comments on the GB page,\n
				so that i can ignore them!",
				32);
			FurText.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT);
			FurText.screenCenter(X);
			add(FurText);
			PressText = new FlxText(0, 645, FlxG.width, "Press ENTER to continue\n \nPress ESCAPE to go cry about it", 32);
			PressText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT);
			PressText.screenCenter(X);
			add(PressText);
	}

	override function update(elapsed:Float)
	{
		
		if(!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if(!back) {
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(FurText, 1, 0.1, false, true, function(flk:FlxFlicker) {
						new FlxTimer().start(0.5, function (tmr:FlxTimer) {
							MusicBeatState.switchState(new FinalWarningState());
								#if desktop
								//updates precense
								DiscordClient.changePresence("Furry Warning", "Proceeding");
								#end
						});
					});
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					CoolUtil.browserLoad('https://www.gamebanana.com/wips/79127');
					FlxTween.tween(FurText, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween) {
										System.exit(0);
							#if desktop
							//updates precense
							DiscordClient.changePresence("Furry Warning", "Leaving :(");
							#end
						}
					});
				}
			}
		}
	#if desktop
	//updates precense
	DiscordClient.changePresence("Furry Warning", "Being Warned");
	#end
		super.update(elapsed);
	}
}
