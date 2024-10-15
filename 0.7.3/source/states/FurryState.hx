package states;

import flixel.effects.FlxFlicker;
import flixel.addons.transition.FlxTransitionableState;
import flash.system.System;

//TODO: set all three of these screens to use the same state, saves on space and load times.

typedef OffsetDATA = 
{	
	BGx:Float,
	BGy:Float,
	BFx:Float,
	BFy:Float,
	WIx:Float,
	WIy:Float,
	txt1X:Float,
	txt1Y:Float,
	txt2X:Float,
	txt2Y:Float,
	enterX:Float,
	enterY:Float,
	spaceX:Float,
	spaceY:Float,
	escX:Float,
	escY:Float,
	backX:Float,
	backY:Float
}

class FurryState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var offsets:OffsetDATA;

	var isagoodperson:Bool;
	var isannoying:Bool;

	var BG:FlxSprite;
	var WI:FlxSprite;
	var BF:FlxSprite;

	var txt1:FlxSprite;
	var txt2:FlxSprite;

	var buttons1:FlxSprite;
	var buttons2:FlxSprite;
	var buttons3:FlxSprite;
	var buttons4:FlxSprite;

	override function create()
	{
		#if desktop
		//updates precense
		DiscordClient.changePresence("Furry Warning", "Being Warned");
		#end
		offsets = tjson.TJSON.parse(Paths.getTextFromFile('data/FurWarn/Offsets.json'));
		new FlxTimer().start(0.75, function(tmr:FlxTimer) { WI.animation.play('warn', true); }, (999999999));
			super.create();
				
			BG = new FlxSprite(offsets.BGx, offsets.BGy);
			BG.frames = Paths.getSparrowAtlas('FurryWarning/SEPERATOR_furry');
			BG.animation.addByPrefix('dastage', 'SEPERATOR_furry', 24, true);
			BG.animation.play('dastage');

			txt1 = new FlxSprite(offsets.txt1X, offsets.txt1Y);
			txt1.frames = Paths.getSparrowAtlas('FurryWarning/TEXT1');
			txt1.animation.addByPrefix('Shift', 'furrywarning_textOne', 24, true, false, false);
			txt1.animation.play('Shift');

			txt2 = new FlxSprite(offsets.txt2X, offsets.txt2Y);
			txt2.frames = Paths.getSparrowAtlas('FurryWarning/TEXT2');
			txt2.animation.addByPrefix('Shift', 'furrywarning_textTwo', 24, true, false, false);
			txt2.animation.play('Shift');

			
			buttons1 = new FlxSprite(offsets.enterX, offsets.enterY);
			buttons1.frames = Paths.getSparrowAtlas('FurryWarning/ENTER');
			buttons1.animation.addByPrefix('Press', 'enterbutton_smash', 24, true, false, false);
			buttons1.animation.play('Press');

			buttons2 = new FlxSprite(offsets.spaceX, offsets.spaceY);
			buttons2.frames = Paths.getSparrowAtlas('FurryWarning/SPACE');
			buttons2.animation.addByPrefix('Press', 'spacebar_smash', 24, true, false, false);
			buttons2.animation.play('Press');

			buttons3 = new FlxSprite(offsets.escX, offsets.escY);
			buttons3.frames = Paths.getSparrowAtlas('FurryWarning/ESCAPE');
			buttons3.animation.addByPrefix('Press', 'escapekey_smash', 24, true, false, false);
			buttons3.animation.play('Press');

			buttons4 = new FlxSprite(offsets.backX, offsets.backY);
			buttons4.frames = Paths.getSparrowAtlas('FurryWarning/BACK');
			buttons4.animation.addByPrefix('Press', 'backspace_smash', 24, true, false, false);
			buttons4.animation.play('Press');
			
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
			add(txt1);
				txt1.antialiasing = ClientPrefs.data.antialiasing;
				txt1.scale.x = 0.5;
				txt1.scale.y = 0.5;
			add(txt2);
				txt2.antialiasing = ClientPrefs.data.antialiasing;
				txt2.scale.x = 0.5;
				txt2.scale.y = 0.5;
			add(buttons1);
				buttons1.antialiasing = ClientPrefs.data.antialiasing;
				buttons1.scale.x = 0.5;
				buttons1.scale.y = 0.5;
			add(buttons2);
				buttons2.antialiasing = ClientPrefs.data.antialiasing;
				buttons2.scale.x = 0.5;
				buttons2.scale.y = 0.5;
			add(buttons3);
				buttons3.antialiasing = ClientPrefs.data.antialiasing;
				buttons3.scale.x = 0.5;
				buttons3.scale.y = 0.5;
			add(buttons4);
				buttons4.antialiasing = ClientPrefs.data.antialiasing;
				buttons4.scale.x = 0.5;
				buttons4.scale.y = 0.5;
			add(WI);
				WI.antialiasing = ClientPrefs.data.antialiasing;
			WI.animation.play('warn', true);

	}

	override function update(elapsed:Float)
	{	
		FlxG.mouse.visible = false;
		if(BF != null && !isagoodperson && !isannoying)
			BF.animation.play('bop');
		
		
		if(!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = false;
				FlxTransitionableState.skipNextTransOut = false;
				if(!back) {
					#if desktop
					//updates precense
					DiscordClient.changePresence("Furry Warning", "Being Awsome :3");
					#end
					FlxG.sound.play(Paths.sound('confirmMenu'));
					isagoodperson = true;
					BF.animation.play('yay!');
					if(ClientPrefs.data.flashing && !isannoying){
						FlxFlicker.flicker(WI, 1, 0.1, false, true, function(flk:FlxFlicker) {
							new FlxTimer().start(1, function (tmr:FlxTimer) {
								MusicBeatState.switchState(new FinalWarningState());
									#if desktop
									//updates precense
									DiscordClient.changePresence("Furry Warning", "Proceeding");
									#end
							});
						});
					};
					if(!ClientPrefs.data.flashing && !isannoying)
					{
						new FlxTimer().start(1, function (tmr:FlxTimer) {
							MusicBeatState.switchState(new FinalWarningState());
								#if desktop
								//updates precense
								DiscordClient.changePresence("Furry Warning", "Proceeding");
								#end
						});
					}
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					isannoying = true;
					#if desktop
					//updates precense
					DiscordClient.changePresence("Furry Warning", "Being an AntiFur :(");
					#end
					BF.screenCenter();
					BG.visible = false;
					WI.visible = false;
					BF.animation.play('fuckoff');
					new FlxTimer().start(1.83, function (tmr:FlxTimer) 
						{
							CoolUtil.browserLoad('https://www.gamebanana.com/wips/79127');
							System.exit(0);
						});
				}
			}
		}
		super.update(elapsed);
	}
}
