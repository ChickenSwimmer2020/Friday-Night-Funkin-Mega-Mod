package states;

import flixel.FlxObject;
import flixel.effects.FlxFlicker;
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

enum MainMenuColumn {
	LEFT;
	CENTER;
	RIGHT;
}

class MainMenuState extends MusicBeatState
{
    public static var gameVersionInformation:VersionInfo;
    public static var UltimateVersion:String;
	public static var psychEngineVersion:String;
	public static var GameVersion:String;
	public static var VersionUpdateName:String;

	public static var curSelected:Int = 0;
	public static var curColumn:MainMenuColumn = CENTER;
	var allowMouse:Bool = false; //Turn this off to block mouse movement in menus

	public var menuItems:FlxTypedGroup<FlxSprite>;
	public var EntVarStory:FlxSprite;
	public var EntVarSettings:FlxSprite;
	public var EntVarAwards:FlxSprite;
    var sketch:FlxSprite;

    var versionLayoutMap:Map<String, String>;
    var versionLayout:Array<String> = [
        'FNF',
        'MM',
        'CS20',
        'ULT'
    ]; 

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

	var leftOption:String = null;
	var rightOption:String = null;
    var leftItem:FlxSprite;
	var rightItem:FlxSprite;

	var magenta:FlxSprite;

	override function create()
	{
        
        gameVersionInformation = tjson.TJSON.parse(Paths.getTextFromFile('data/Version.json'));
		UltimateVersion = ' ' + gameVersionInformation.Ultimate;
		psychEngineVersion = gameVersionInformation.EngVer;
		GameVersion = (gameVersionInformation.GameVer #if DEBUG + 'DEV' #end);
		VersionUpdateName = gameVersionInformation.UpdNme;

        versionLayoutMap = [
            'FNF' => "Friday Night Funkin' v" + Application.current.meta.get('version'),
            'CS20' => "CS20 Engine v" + psychEngineVersion,
            'ULT' => "Ultimate" + UltimateVersion,
            'MM' => "MegaMod v" + GameVersion
        ];

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Main Menu", '   ');
		#end

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg = new FlxSprite(-80).loadGraphic(Paths.image('MainMenu/menuBG'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		add(magenta);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

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
		var randInt = FlxG.random.int(0, 2); // reminder to change back from (0, 2) to (0, 20)
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
        for (versionID in 0...4)
        {
            var str = versionLayoutMap.get(versionLayout[versionID]);
            var versionTxt = new FlxText(12, 4 + (20 * versionID), 0, str, 12);
            versionTxt.scrollFactor.set();
		    versionTxt.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		    add(versionTxt);
        }

		var updateVersion = new FlxText(750, FlxG.height - 40, VersionUpdateName, 12, true);
		updateVersion.scrollFactor.set();
		updateVersion.setFormat("Cave Story Regular", 44, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		updateVersion.antialiasing = false;
		add(updateVersion);

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');

		#if MODS_ALLOWED
		Achievements.reloadList();
		#end
		#end

		super.create();

		//FlxG.camera.follow(camFollow, null, 0.15);
	}

	function createMenuItem(name:String, x:Float, y:Float):FlxSprite
	{
		var menuItem:FlxSprite = new FlxSprite(x, y);
		menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_$name');
		menuItem.animation.addByPrefix('idle', '$name idle', 24, true);
		menuItem.animation.addByPrefix('selected', '$name selected', 24, true);
		menuItem.animation.play('idle');
		menuItem.updateHitbox();
		
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
		menuItem.scrollFactor.set();
		menuItems.add(menuItem);
		return menuItem;
	}

	var selectedSomethin:Bool = false;

	var timeNotMoving:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume = Math.min(FlxG.sound.music.volume + 0.5 * elapsed, 0.8);

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
				changeItem(-1);

			if (controls.UI_DOWN_P)
				changeItem(1);

			var allowMouse:Bool = allowMouse;
			if (allowMouse && ((FlxG.mouse.deltaScreenX != 0 && FlxG.mouse.deltaScreenY != 0) || FlxG.mouse.justPressed)) //FlxG.mouse.deltaScreenX/Y checks is more accurate than FlxG.mouse.justMoved
			{
				allowMouse = false;
				FlxG.mouse.visible = true;
				timeNotMoving = 0;

				var selectedItem:FlxSprite;
				switch(curColumn)
				{
					case CENTER:
						selectedItem = menuItems.members[curSelected];
					case LEFT:
						selectedItem = leftItem;
					case RIGHT:
						selectedItem = rightItem;
				}

				if(leftItem != null && FlxG.mouse.overlaps(leftItem))
				{
					allowMouse = true;
					if(selectedItem != leftItem)
					{
						curColumn = LEFT;
						changeItem();
					}
				}
				else if(rightItem != null && FlxG.mouse.overlaps(rightItem))
				{
					allowMouse = true;
					if(selectedItem != rightItem)
					{
						curColumn = RIGHT;
						changeItem();
					}
				}
				else
				{
					var dist:Float = -1;
					var distItem:Int = -1;
					for (i in 0...optionShit.length)
					{
						var memb:FlxSprite = menuItems.members[i];
						if(FlxG.mouse.overlaps(memb))
						{
							var distance:Float = Math.sqrt(Math.pow(memb.getGraphicMidpoint().x - FlxG.mouse.screenX, 2) + Math.pow(memb.getGraphicMidpoint().y - FlxG.mouse.screenY, 2));
							if (dist < 0 || distance < dist)
							{
								dist = distance;
								distItem = i;
								allowMouse = true;
							}
						}
					}

					if(distItem != -1 && selectedItem != menuItems.members[distItem])
					{
						curColumn = CENTER;
						curSelected = distItem;
						changeItem();
					}
				}
			}
			else
			{
				timeNotMoving += elapsed;
				if(timeNotMoving > 2) FlxG.mouse.visible = false;
			}

			switch(curColumn)
			{
				case CENTER:
					if(controls.UI_LEFT_P && leftOption != null)
					{
						curColumn = LEFT;
						changeItem();
					}
					else if(controls.UI_RIGHT_P && rightOption != null)
					{
						curColumn = RIGHT;
						changeItem();
					}

				case LEFT:
					if(controls.UI_RIGHT_P)
					{
						curColumn = CENTER;
						changeItem();
					}

				case RIGHT:
					if(controls.UI_LEFT_P)
					{
						curColumn = CENTER;
						changeItem();
					}
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT || (FlxG.mouse.justPressed && allowMouse))
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				if (optionShit[curSelected] != 'donate')
				{
					selectedSomethin = true;
					FlxG.mouse.visible = false;

					if (ClientPrefs.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					var item:FlxSprite;
					var option:String;
					switch(curColumn)
					{
						case CENTER:
							option = optionShit[curSelected];
							item = menuItems.members[curSelected];

						case LEFT:
							option = leftOption;
							item = leftItem;

						case RIGHT:
							option = rightOption;
							item = rightItem;
					}

					FlxFlicker.flicker(item, 1, 0.06, false, false, function(flick:FlxFlicker)
					{
						switch (option)
						{
							case 'story_mode':
								MusicBeatState.switchState(new StoryMenuState());
							case 'freeplay':
								MusicBeatState.switchState(new FreeplayState());

							#if MODS_ALLOWED
							case 'mods':
								MusicBeatState.switchState(new ModsMenuState());
							#end

							#if ACHIEVEMENTS_ALLOWED
							case 'achievements':
								MusicBeatState.switchState(new AchievementsMenuState());
							#end

							case 'credits':
								MusicBeatState.switchState(new CreditsState());
							case 'options':
								MusicBeatState.switchState(new OptionsState());
								OptionsState.onPlayState = false;
								if (PlayState.SONG != null)
								{
									PlayState.SONG.arrowSkin = null;
									PlayState.SONG.splashSkin = null;
									PlayState.stageUI = 'normal';
								}
						}
					});
					
					for (memb in menuItems)
					{
						if(memb == item)
							continue;

						FlxTween.tween(memb, {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
					}
				}
				else CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
			}
			#if desktop
			if (controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(change:Int = 0)
	{
		if(change != 0) curColumn = CENTER;
		curSelected = FlxMath.wrap(curSelected + change, 0, optionShit.length - 1);
		FlxG.sound.play(Paths.sound('scrollMenu'));

		for (item in menuItems)
		{
			item.animation.play('idle');
			item.centerOffsets();
		}

		var selectedItem:FlxSprite;
		switch(curColumn)
		{
			case CENTER:
				selectedItem = menuItems.members[curSelected];
			case LEFT:
				selectedItem = leftItem;
			case RIGHT:
				selectedItem = rightItem;
		}
		selectedItem.animation.play('selected');
		selectedItem.centerOffsets();
	}
}
