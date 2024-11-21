package states;

import flixel.group.FlxGroup;
import backend.Functions;
import states.GalleryState.GalleryMenuState;
import lime.app.Application;
	#if DEBUG
		import states.editors.MasterEditorMenu;
	#end
import options.OptionsState;

using flixel.util.FlxSpriteUtil;

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

	var bopL:Bool = false;
	var sketchIsBopper:Bool = false;

	public static var curSelected:Int = 0;
	public static var curColumn:MainMenuColumn = CENTER;
	var allowMouse:Bool = false; //Turn this off to block mouse movement in menus

	public var menuItems:FlxTypedGroup<FlxSprite>;
    var randInt = FlxG.random.int(0, 2); // reminder to change back from (0, 2) to (0, 20)
    var sketch:FlxSprite;

	var howLong:Float;

	public var verInfTxt:FlxGroup;

    var versionLayoutMap:Map<String, String>;
    var versionLayout:Array<String> = [
        'FNF',
        'MM',
        'CS20',
        'ULT'
    ]; 

	var choosables:Array<String> = [
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

	public var bg:FlxSprite;
	public var updateVersion:FlxText;
	override function create()
	{	
		//precache the enter anims, again.
		//fuck it, im using the function i created but modify it slightly so it works the way i want it too.
			cacheMenuEnter('story_mode');
			cacheMenuEnter('awards');
			cacheMenuEnter('settings');



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
		DiscordClient.changePresence("Main Menu", null);
		#end

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite(-80).loadGraphic(Paths.image('MainMenu/menuBG'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		//bg.setGraphicSize(Std.int(bg.width * 1));
		bg.scale.set(0.62, 0.62);
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

		var bg_dablack = new FlxSprite(0, 0).makeGraphic(1280, 720, FlxColor.TRANSPARENT);
		bg_dablack.drawPolygon([new FlxPoint(0, 0), new FlxPoint(1280, 0), new FlxPoint(1280, 100), new FlxPoint(295, 152), new FlxPoint(176, 481), new FlxPoint(380, 651), new FlxPoint(1280, 651), new FlxPoint(1280, 720), new FlxPoint(0, 720), new FlxPoint(0, 0)], FlxColor.BLACK, {pixelHinting: true}, {smoothing: true});
		bg_dablack.antialiasing = ClientPrefs.data.antialiasing;
		add(bg_dablack);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

        generateMenuItems();

		// SKETCH CHARS!!
		// sketch name's
		// [
		// sketch 0 = the game logo but sketchified
		// sketch 1 = bf idle
		// sketch 2 = gf bopping
		// sketch 3 = bf watching tv
		// sketch 4 = gf and bf cuddling
		// sketch 5 = gf playing minecraft
		// sketch 6 = bf playing doom(1993)
		// sketch 7 = CRT with audio visualiser (reminder to make work properly!)
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
		sketch = new FlxSprite(0, 0);
		sketch.frames = Paths.getSparrowAtlas('MainMenu/Sketches/Sketchy$randInt');
		sketch.animation.addByPrefix('idle', 'xml prefix', 24, false);
			
		sketch.animation.play('idle');
		sketch.antialiasing = ClientPrefs.data.antialiasing;
		// used for sketchy 0
		sketch.scale.x = 1;
		sketch.scale.y = 1;
		add(sketch);

		// offsets
        switch (randInt)
        {
            case 0:
                sketch.x = 400;
                sketch.y = 50;
                sketch.scale.x = 0.9;
                sketch.scale.y = 0.9;
            case 1:
                sketch.x = 550;
                sketch.y = 100;
                sketch.scale.x = 1;
                sketch.scale.y = 1;
            case 2:
                sketch.x = 300;
                sketch.y = 0;
                sketch.scale.x = 1;
                sketch.scale.y = 1;
        }

		verInfTxt = new FlxGroup();
		add(verInfTxt);

        // Version Information
        for (versionID in 0...4)
        {
            var str = versionLayoutMap.get(versionLayout[versionID]);
           	var versionTxt = new FlxText(0, 0 + (20 * versionID), 0, str, 12);
            versionTxt.scrollFactor.set();
		    versionTxt.setFormat(/*"VCR OSD Mono"*/null, 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		    verInfTxt.add(versionTxt);
        }

		updateVersion = new FlxText(750, FlxG.height - 40, VersionUpdateName, 12, true);
		updateVersion.scrollFactor.set();
		updateVersion.setFormat("Cave Story Regular", 44, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		updateVersion.antialiasing = false;
		add(updateVersion);

		changeItem();
        
		// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');

		Conductor.bpm = 114;

		trace(randInt);

		super.create();
	}

    function generateMenuItems()
    {
        for (itemID in 0...choosables.length)
        {
            var added = 0;
            var menuItem:FlxSprite = new FlxSprite(if(itemID==7){110;}else{0;}, 575);
            if (itemID < 4){
                for (_ in 0...itemID)
                    added += 50;
                menuItem = new FlxSprite(0, 100 + added);
            }
            if(itemID < 7 && itemID > 3){
                for (_ in 0...(itemID - 4))
                    added += 55;
                menuItem = new FlxSprite(added, 550);
            }
            menuItem.scale.x = 5;
            menuItem.scale.y = 5;
            menuItem.frames = Paths.getSparrowAtlas('MainMenu/menu_' + choosables[itemID]);
            menuItem.animation.addByPrefix('idle', choosables[itemID] + " basic", 24);
            menuItem.animation.addByPrefix('selected', choosables[itemID] + " white", 24);
            menuItem.animation.play('idle');
            menuItem.ID = itemID;
            menuItem.setGraphicSize(Std.int(menuItem.width * 0.70));
            menuItem.antialiasing = ClientPrefs.data.antialiasing;
            menuItem.updateHitbox();
            menuItems.add(menuItem);

			if (itemID == 4) menuItem.y += 100;
			if (itemID == 5) menuItem.y += 100;
			if (itemID == 6) menuItem.y += 100;
			if (itemID == 7) menuItem.y += 100;

            if (itemID == 8) menuItem.visible = false;
        }
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

	inline function createMenuEnter(name:String, X:Float, Y:Float, Scale:Float, WaitTime:Float):FlxSprite
	{
		var Enter:FlxSprite = new FlxSprite(X, Y);
		Enter.frames = Paths.getSparrowAtlas('MainMenu/Enters/Enter_$name');
		Enter.animation.addByPrefix('Yeet', '$name yeet', 24, true);
		Enter.animation.play('Yeet');
		Enter.scale.set(Scale, Scale);
		Enter.updateHitbox();
		Enter.antialiasing = ClientPrefs.data.antialiasing;
		add(Enter);

		howLong = WaitTime; //kinda important.

		return Enter;
	}

	inline function cacheMenuEnter(name:String):FlxSprite
	{
		var CacheableEnter:FlxSprite = new FlxSprite(0, 0);
		CacheableEnter.frames = Paths.getSparrowAtlas('MainMenu/Enters/Enter_$name');
		CacheableEnter.animation.addByPrefix('Yeet', '$name yeet', 24, true);
		CacheableEnter.animation.play('Yeet');
		CacheableEnter.updateHitbox();
		add(CacheableEnter);
		CacheableEnter.alpha = 0.001; //we need to keep this because it cant cache into memory if its not visible, odd feature of haxe.

		return CacheableEnter;
	}

	var selectedSomethin:Bool = false;

	var timeNotMoving:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume = Math.min(FlxG.sound.music.volume + 0.5 * elapsed, 0.8);

		sketch.animation.finishCallback = function(UwU)
		{
			sketch.animation.curAnim.restart();
		}

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
					for (i in 0...choosables.length)
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
				if (choosables[curSelected] != 'donate')
				{
					selectedSomethin = true;
					FlxG.mouse.visible = false;

					bg.alpha = 0.15;
					updateVersion.visible = false;
					sketch.visible = false;
					verInfTxt.visible = false;

					switch(curSelected)
					{
						case 0: //story mode
							createMenuEnter('story_mode', 0, 0, 1, 0.75);
						case 1: //freeplay
							trace('implement: Freeplay');
						case 2: //gallery
							trace('implement: Gallery');
						case 3: //credits
						trace('implement: credits');
						case 4: //settings
							createMenuEnter('settings', 0, 0, 1, 0.90);
						case 5: //awards
							createMenuEnter('awards', 250, 0, 0.75, 0.5);
						//we skip over 6 and 7 because those are for the youtube and discord, we dont need intro anims for those.
						case 8:
							trace('implement: Overworld');
					}

					var item:FlxSprite;
					var option:String;
					switch(curColumn)
					{
						case CENTER:
							option = choosables[curSelected];
							item = menuItems.members[curSelected];

						case LEFT:
							option = leftOption;
							item = leftItem;

						case RIGHT:
							option = rightOption;
							item = rightItem;
					}

					//FlxFlicker.flicker(item, 0.0001, 0.06, false, false, function(flick:FlxFlicker)
					Functions.wait(howLong, () -> 
					{
						switch (option)
						{
							case 'story_mode':
								MusicBeatState.switchState(new StoryMenuState());
							case 'freeplay':
								MusicBeatState.switchState(new FreeplayState());
							case 'awards':
								MusicBeatState.switchState(new AchievementsMenuState());
                            case 'gallery':
								MusicBeatState.switchState(new GalleryMenuState());
                            case 'overworld':
								// MusicBeatState.switchState(new OverWorldState());
								backend.WindowsAPI.showMessagePopup('Uh Oh!', 'Sorry! this feature is not yet implemented!\ntry again in the\nnext update!',
									MSG_INFORMATION); //prevents crashes because overworld doesnt work yet
                                MusicBeatState.switchState(new MainMenuState());
							case 'credits':
								MusicBeatState.switchState(new CreditsState());
							case 'settings':
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
						//if(memb == item) //everything goes invis, we dont need this.
						//	continue;

						FlxTween.tween(memb, {alpha: 0}, 0.1, {ease: FlxEase.quadOut});
					}
				}
				else CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
			}
			#if debug
			if (controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			if (controls.justPressed('debug_2'))
			{
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				FlxG.save.data.CacheEverything = null;
				MusicBeatState.resetState();
			}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(change:Int = 0)
	{
		if(change != 0) curColumn = CENTER;
		curSelected = FlxMath.wrap(curSelected + change, 0, choosables.length - 1);
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
        if (selectedItem.ID != 8)
		    selectedItem.animation.play('selected');
		selectedItem.centerOffsets();
	}
}
