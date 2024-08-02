package states;

import flixel_5_3_1.ParallaxSprite;
import flxanimate.animate.FlxTimeline;
import flixel.util.FlxSave;
import flixel.FlxSubState;

import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flash.system.System;

import haxe.Json;

typedef OffsetDATA = 
{	
	BGx:Float,
	BGy:Float,
	BFx:Float,
	BFy:Float,
	WIx:Float,
	WIy:Float
}

class FurryState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var offsets:OffsetDATA;

	var FurText:FlxText;
	var PressText:FlxText;

	var isagoodperson:Bool;
	var isannoying:Bool;

	var BG:FlxSprite;
	var WI:FlxSprite;
	var BF:FlxSprite;
	override function create()
	{
		offsets = tjson.TJSON.parse(Paths.getTextFromFile('data/FurWarn/Offsets.json'));
		new FlxTimer().start(0.75, function(tmr:FlxTimer) { WI.animation.play('warn', true); }, (999999999));
			super.create();
				
			BG = new FlxSprite(offsets.BGx, offsets.BGy);
			BG.frames = Paths.getSparrowAtlas('FurryWarning/SEPERATOR_furry');
			BG.animation.addByPrefix('dastage', 'SEPERATOR_furry', 24, true);
			BG.animation.play('dastage');
			
			WI = new FlxSprite(offsets.WIx, offsets.WIy);
			WI.frames = Paths.getSparrowAtlas('FurryWarning/WARNING');
			WI.animation.addByPrefix('warn', 'WARNING_furry', 24, false);

			BF = new FlxSprite(offsets.BFx, offsets.BFy);
			BF.frames = Paths.getSparrowAtlas('FurryWarning/FURRYBF');
			BF.animation.addByIndices('bop', 'BF_furry', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
			BF.animation.addByIndices('yay!', 'BF_furry', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30], "", 24, false);
			BF.animation.addByIndices('fuckoff', 'BF_furry', [31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69,70], "", 24, false);

			add(BG);
				BG.antialiasing = ClientPrefs.data.antialiasing;
			add(BF);
				BF.antialiasing = ClientPrefs.data.antialiasing;
			add(WI);
				WI.antialiasing = ClientPrefs.data.antialiasing;
			WI.animation.play('warn', true);

			FurText = new FlxText(0, 450, FlxG.width,
				"Yo, this mod was made by a furry.\n
				cry about it,\n
				beacuse im not apolagizing",
				32);
			FurText.setFormat("VCR OSD Mono", 25, FlxColor.WHITE, LEFT);
			FurText.screenCenter(X);
			add(FurText);
			PressText = new FlxText(0, 50, FlxG.width, "Press ENTER to continue\n \nPress ESCAPE to go cry about it", 32);
			PressText.setFormat("VCR OSD Mono", 25, FlxColor.WHITE, LEFT);
			PressText.screenCenter(X);
			add(PressText);
	}

	override function update(elapsed:Float)
	{	
		if(BF != null && !isagoodperson && !isannoying)
			BF.animation.play('bop');
		
		
		if(!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if(!back) {
					FlxG.sound.play(Paths.sound('confirmMenu'));
					isagoodperson = true;
					BF.animation.play('yay!');
					FlxFlicker.flicker(FurText, 1, 0.1, false, true, function(flk:FlxFlicker) {
						new FlxTimer().start(1, function (tmr:FlxTimer) {
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
					//ADD TIMER AND ANIM CODE HERE
					isannoying = true;
					BF.animation.play('fuckoff');
					//new FlxTimer().start(0, function (tmr:FlxTimer) { System.exit(0); })
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
