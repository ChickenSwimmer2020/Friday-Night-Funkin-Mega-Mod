package states;

import backend.WindowsAPI;
import tjson.TJSON;
import backend.ClientPrefs;
import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;

typedef VersionInfo =
{
	Ultimate:String,
	EngVer:String,
	GameVer:String,
	UpdNme:String
}

class MainMenuState extends MusicBeatState
{
	var gameVersionInformation:VersionInfo;
	// init var
	// used for the randomized characters
	var sketch:FlxSprite;
	var randInt:Int;

	// tween timer for the entry animations
	var TweenTimer:Float = 0.75;

	public static var UltimateVersion:String;
	public static var psychEngineVersion:String;
	public static var GameVersion:String;
	public static var UpdateName:String;

	public var versionShitU:FlxText;
	public var versionShitE:FlxText;
	public var versionShitMM:FlxText;
	public var versionShitFNF:FlxText;
	public var versionShitUpd:FlxText;

	public static var curSelected:Int = 0;

	public var bg:FlxSprite;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var EnterVarients:FlxTypedGroup<FlxSprite>;

	public var EntVarStory:FlxSprite;
	public var EntVarSettings:FlxSprite;
	public var EntVarAwards:FlxSprite;

	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'gallery',
		'credits',
		'settings',
		'awards',
		'discord',
		'youtube',
		'overworld'
	];

	var camFollow:FlxObject;

	override function create()
	{
		gameVersionInformation = tjson.TJSON.parse(Paths.getTextFromFile('data/Version.json'));
		UltimateVersion = ' ' + gameVersionInformation.Ultimate;
		psychEngineVersion = gameVersionInformation.EngVer;
		#if DEBUG
		GameVersion = (gameVersionInformation.GameVer + 'DEV');
		#else
		GameVersion = gameVersionInformation.GameVer;
		#end
		UpdateName = gameVersionInformation.UpdNme;

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		FlxTransitionableState.skipNextTransIn = false;
		FlxTransitionableState.skipNextTransOut = false;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		bg = new FlxSprite(-80).loadGraphic(Paths.image('MainMenu/menuBG'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		EnterVarients = new FlxTypedGroup<FlxSprite>();
		add(EnterVarients);

		// UI CODE!
		// Story Mode
		var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
		var menuItem:FlxSprite = new FlxSprite(0, 100);
		menuItem.scale.x = 5;
		menuItem.scale.y = 5;
		menuItem.frames = Paths.getSparrowAtlas('MainMenu/menu_' + optionShit[0]);
		menuItem.animation.addByPrefix('idle', optionShit[0] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[0] + " white", 24);
		// enter animation
		EntVarStory = new FlxSprite(0, 100);
		EntVarStory.frames = Paths.getSparrowAtlas('MainMenu/Enters/Enter_' + optionShit[0]);
		EntVarStory.animation.addByPrefix('enterpressed', 'story_mode yeet', 24);
		EntVarStory.animation.addByIndices('Freeze', 'story_mode yeet', [0], "", 24, true);
		EntVarStory.screenCenter(X);
		EntVarStory.animation.play('Freeze');
		EntVarStory.visible = false;
		EntVarStory.antialiasing = ClientPrefs.data.antialiasing;
		add(EntVarStory);
		menuItem.animation.play('idle');
		menuItem.ID = 0;
		menuItem.setGraphicSize(Std.int(menuItem.width * 0.70));
		menuItems.add(menuItem);
		// var scr:Float = (optionShit.length - 4) * 0.135;
		// if (optionShit.length < 6) scr = 0;
		// menuItem.scrollFactor.set(0, scr);
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
		menuItem.updateHitbox();

		// FreePlay Mode
		offset = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
		menuItem = new FlxSprite(0, 150);
		menuItem.scale.x = 5;
		menuItem.scale.y = 5;
		menuItem.frames = Paths.getSparrowAtlas('MainMenu/menu_' + optionShit[1]);
		menuItem.animation.addByPrefix('idle', optionShit[1] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[1] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.ID = 1;
		menuItem.setGraphicSize(Std.int(menuItem.width * 0.70));
		menuItems.add(menuItem);
		// scr = (optionShit.length - 4) * 0.135;
		// if (optionShit.length < 6) scr = 1;
		// menuItem.scrollFactor.set(1, scr);
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
		menuItem.updateHitbox();

		// gallery
		offset = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
		menuItem = new FlxSprite(0, 200);
		menuItem.scale.x = 5;
		menuItem.scale.y = 5;
		menuItem.frames = Paths.getSparrowAtlas('MainMenu/menu_' + optionShit[2]);
		menuItem.animation.addByPrefix('idle', optionShit[2] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[2] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.ID = 2;
		menuItem.setGraphicSize(Std.int(menuItem.width * 0.70));
		menuItems.add(menuItem);
		// scr = (optionShit.length - 4) * 0.135;
		// if (optionShit.length < 6) scr = 2;
		// menuItem.scrollFactor.set(2, scr);
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
		menuItem.updateHitbox();

		// settings
		offset = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
		menuItem = new FlxSprite(0, 550);
		menuItem.scale.x = 5;
		menuItem.scale.y = 5;
		menuItem.frames = Paths.getSparrowAtlas('MainMenu/menu_' + optionShit[4]);
		menuItem.animation.addByPrefix('idle', optionShit[4] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[4] + " white", 24);
		// enter animation
		EntVarSettings = new FlxSprite(0, 0);
		EntVarSettings.frames = Paths.getSparrowAtlas('MainMenu/Enters/Enter_' + optionShit[4]);
		EntVarSettings.animation.addByPrefix('enterpressed', 'settings yeet', 24, false);
		EntVarSettings.animation.addByIndices('Freeze', 'settings yeet', [0], "", 24, true);
		EntVarSettings.screenCenter(X);
		EntVarSettings.animation.play('Freeze');
		EntVarSettings.visible = false;
		EntVarSettings.antialiasing = ClientPrefs.data.antialiasing;
		add(EntVarSettings);
		menuItem.animation.play('idle');
		menuItem.ID = 4;
		menuItem.setGraphicSize(Std.int(menuItem.width * 0.70));
		menuItems.add(menuItem);
		// scr = (optionShit.length - 4) * 0.135;
		// if (optionShit.length < 6) scr = 3;
		// menuItem.scrollFactor.set(3, scr);
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
		menuItem.updateHitbox();

		// Credits
		offset = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
		menuItem = new FlxSprite(0, 250);
		menuItem.scale.x = 5;
		menuItem.scale.y = 5;
		menuItem.frames = Paths.getSparrowAtlas('MainMenu/menu_' + optionShit[3]);
		menuItem.animation.addByPrefix('idle', optionShit[3] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[3] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.ID = 3;
		menuItem.setGraphicSize(Std.int(menuItem.width * 0.70));
		menuItems.add(menuItem);
		// scr = (optionShit.length - 4) * 0.135;
		// if (optionShit.length < 6) scr = 2;
		// menuItem.scrollFactor.set(2, scr);
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
		menuItem.updateHitbox();

		// Awards
		offset = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
		menuItem = new FlxSprite(55, 550);
		menuItem.scale.x = 5;
		menuItem.scale.y = 5;
		menuItem.frames = Paths.getSparrowAtlas('MainMenu/menu_' + optionShit[5]);
		menuItem.animation.addByPrefix('idle', optionShit[5] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[5] + " white", 24);
		// enter animation
		EntVarAwards = new FlxSprite(0, 0);
		EntVarAwards.frames = Paths.getSparrowAtlas('MainMenu/Enters/Enter_' + optionShit[5]);
		EntVarAwards.animation.addByPrefix('enterpressed', 'awards yeet', 24, false);
		EntVarAwards.animation.addByIndices('Freeze', 'awards yeet', [0], "", 24, true);
		EntVarAwards.screenCenter(X);
		EntVarAwards.animation.play('Freeze');
		EntVarAwards.visible = false;
		EntVarAwards.antialiasing = ClientPrefs.data.antialiasing;
		add(EntVarAwards);
		menuItem.animation.play('idle');
		menuItem.ID = 5;
		menuItem.setGraphicSize(Std.int(menuItem.width * 0.70));
		menuItems.add(menuItem);
		// scr = (optionShit.length - 4) * 0.135;
		// if (optionShit.length < 6) scr = 2;
		// menuItem.scrollFactor.set(2, scr);
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
		menuItem.updateHitbox();

		// discord
		offset = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
		menuItem = new FlxSprite(110, 550);
		menuItem.scale.x = 5;
		menuItem.scale.y = 5;
		menuItem.frames = Paths.getSparrowAtlas('MainMenu/menu_' + optionShit[6]);
		menuItem.animation.addByPrefix('idle', optionShit[6] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[6] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.ID = 6;
		menuItem.setGraphicSize(Std.int(menuItem.width * 0.70));
		menuItems.add(menuItem);
		// scr = (optionShit.length - 4) * 0.135;
		// if (optionShit.length < 6) scr = 3;
		// menuItem.scrollFactor.set(3, scr);
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
		menuItem.updateHitbox();

		// youtube
		offset = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
		menuItem = new FlxSprite(110, 575);
		menuItem.scale.x = 5;
		menuItem.scale.y = 5;
		menuItem.frames = Paths.getSparrowAtlas('MainMenu/menu_' + optionShit[7]);
		menuItem.animation.addByPrefix('idle', optionShit[7] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[7] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.ID = 7;
		menuItem.setGraphicSize(Std.int(menuItem.width * 0.70));
		menuItems.add(menuItem);
		// scr = (optionShit.length - 4) * 0.135;
		// if (optionShit.length < 6) scr = 3;
		// menuItem.scrollFactor.set(3, scr);
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
		menuItem.updateHitbox();

		// overworld
		offset = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
		menuItem = new FlxSprite(0, 575);
		menuItem.scale.x = 5;
		menuItem.scale.y = 5;
		menuItem.frames = Paths.getSparrowAtlas('MainMenu/menu_' + optionShit[8]);
		menuItem.animation.addByPrefix('idle', optionShit[8] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[8] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.ID = 8;
		menuItem.setGraphicSize(Std.int(menuItem.width * 0.70));
		menuItems.add(menuItem);
		// scr = (optionShit.length - 4) * 0.135;
		// if (optionShit.length < 6) scr = 3;
		// menuItem.scrollFactor.set(3, scr);
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
		menuItem.updateHitbox();

		// SKETCH CHARS!!
		// sketch name's
		// [
		// sketch 0 = the game logo but sketchified
		// sketch 1 = bf idle
		// sketch 2 = gf bopping (use beathit for this)
		// sketch 3 = bf watching tv
		// sketch 4 = gf and bf cuddling
		// sketch 5 = gf playing minecraft
		// sketch 6 = bf playing doom(1993)
		// sketch 7 = CRT with audio visualiser (nonfunctional, possibly updatable in future update)
		// sketch 8 = bf eating pringles
		// sketch 9 = bf and gf
		// sketch 10 = boombox with a sign saying that bf and gf were off screen having sex [add bed creaking SFX in bg]
		// sketch 11 = CHAR
		// sketch 12 = CHAR
		// sketch 13 = CHAR
		// sketch 14 = CHAR
		// sketch 15 = CHAR  placeholder char will be '?' bopping
		// sketch 16 = CHAR
		// sketch 17 = CHAR
		// sketch 18 = CHAR
		// sketch 19 = CHAR
		// sketch 20 = CHAR
		// ]

		// create
		randInt = FlxG.random.int(0, 2); // reminder to change back from (0, 2) to (0, 20)
		sketch = new FlxSprite(0, 0);
		sketch.frames = Paths.getSparrowAtlas('MainMenu/Sketches/Sketchy$randInt');
		sketch.animation.addByPrefix('idle', 'xml prefix', 24, (randInt != 10));
		sketch.animation.play('idle');
		sketch.antialiasing = ClientPrefs.data.antialiasing;
		// used for sketchy 0
		sketch.scale.x = 1;
		sketch.scale.y = 1;
		add(sketch);

		// beatHit
		// if (randInt == 10 || randInt == 2) sketch.animation.play('idle', true);

		// offsets
		if (randInt == 0)
		{
			sketch.x = 400;
			sketch.y = 50;
			sketch.scale.x = 0.9;
			sketch.scale.y = 0.9;
		};
		if (randInt == 1)
		{
			sketch.x = 550;
			sketch.y = 100;
			sketch.scale.x = 1;
			sketch.scale.y = 1;
		};
		if (randInt == 2)
		{
			sketch.x = 300;
			sketch.y = 0;
			sketch.scale.x = 1;
			sketch.scale.y = 1;
		};
		// Version Information
		versionShitU = new FlxText(12, 68, 0, "Ultimate" + UltimateVersion, 12);
		versionShitU.scrollFactor.set();
		versionShitU.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShitU);

		versionShitE = new FlxText(12, 24, 0, "CS20 Engine v" + psychEngineVersion, 12);
		versionShitE.scrollFactor.set();
		versionShitE.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShitE);

		versionShitMM = new FlxText(12, 44, 0, "MegaMod v" + GameVersion, 12);
		versionShitMM.scrollFactor.set();
		versionShitMM.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShitMM);

		versionShitFNF = new FlxText(12, 0, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShitFNF.scrollFactor.set();
		versionShitFNF.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShitFNF);

		versionShitUpd = new FlxText(750, FlxG.height - 40, UpdateName, 12, true);
		versionShitUpd.scrollFactor.set();
		versionShitUpd.setFormat("Cave Story Regular", 44, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionShitUpd.antialiasing = false;
		add(versionShitUpd);

		changeItem();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Main Menu", '    ');
		#end

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if (FreeplayState.vocals != null)
				FreeplayState.vocals.volume += 0.5 * elapsed;
		}
		FlxG.camera.followLerp = FlxMath.bound(elapsed * 9 / (FlxG.updateFramerate / 60), 0, 1);
		Conductor.songPosition = FlxG.sound.music.time;

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'youtube')
				{
					CoolUtil.browserLoad('https://www.youtube.com/channel/UCzC66e3fxpkpnoL9vo0UQJQ');
				}
				else if (optionShit[curSelected] == 'discord')
				{
					CoolUtil.browserLoad('https://discord.gg/8jfbWp9PXg');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.0001, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							bg.alpha = 0.15;
							sketch.visible = false;
							versionShitU.visible = false;
							versionShitE.visible = false;
							versionShitMM.visible = false;
							versionShitFNF.visible = false;
							versionShitUpd.visible = false;
							spr.visible = false;
							if (spr.ID == 0)
							{
								TweenTimer = 0.75;
								EntVarStory.visible = true;
								EntVarStory.animation.play('enterpressed', true, false, 0);
							}
							if (spr.ID == 4)
							{
								TweenTimer = 0.90;
								EntVarSettings.visible = true;
								EntVarSettings.animation.play('enterpressed', true, false, 0);
							}
							if (spr.ID == 5)
							{
								TweenTimer = 0.90;
								EntVarAwards.visible = true;
								EntVarAwards.animation.play('enterpressed', true, false, 0);
							}
							// FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							new FlxTimer().start(TweenTimer, function(tmr:FlxTimer)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									case 'gallery':
										MusicBeatState.switchState(new GalleryMenuState());
									case 'overworld':
										// MusicBeatState.switchState(new OverWorldState());
										WindowsAPI.showMessagePopup('Uh Oh!', 'Sorry! this feature is not yet implemented!\ntry again in the\nnext update!',
											MSG_INFORMATION); //prevents crashes because overworld doesnt work yet
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'settings':
										LoadingState.loadAndSwitchState(new OptionsState());
										OptionsState.onPlayState = false;
										if (PlayState.SONG != null)
										{
											PlayState.SONG.arrowSkin = null;
											PlayState.SONG.splashSkin = null;
										}
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			// spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if (menuItems.length > 4)
				{
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
