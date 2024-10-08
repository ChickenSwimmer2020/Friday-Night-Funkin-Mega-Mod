package states;

import backend.visualization.Visualizer;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;
import backend.WeekData;
import backend.Highscore;
import flixel.input.keyboard.FlxKey;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import haxe.Json;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import shaders.ColorSwap;
import states.StoryMenuState;
import states.MainMenuState;

import backend.visualization.Visualizer;


class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	var CSLogo:FlxSprite;
	var YTLogo:FlxSprite;
	var DAFUQWHAT:FlxSprite;
	var DAFUQWHATLEFTY:Bool = false;

	var Vis:Visualizer;

	var waitwhat:Bool;
	var TweenComplete:Bool = false;

	public var GameElapsedTime:Float;

	var willhey:Bool = false;

	var titleTextColors:Array<FlxColor> = [0xFF33FFFF, 0xFF3333CC];
	var titleTextAlphas:Array<Float> = [1, .64];

	var curWacky:Array<String> = [];
	var updateJoke:Array<String> = [];
	var devJoke:Array<String> = [];
	var brahdafack:Array<String> = [];

	var wackyImage:FlxSprite;

	public static var updateVersion:String = '';

	override public function create():Void
	{
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			MMlogo.animation.play('shine', true);
		}, 99999999);
		// random int code for the 1 in 10000 chance for bf to flip off the player
		var penis:Int;
		penis = FlxG.random.int(1, 10000);
		if (penis == 10000)
		{
			fuckoff = true;
			willhey = false;
		}
		else if (penis < 10000)
		{
			fuckoff = false;
			willhey = true;
		}

		if (!ClientPrefs.data.Cache)
		{
			Paths.clearStoredMemory();
		}

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

		curWacky = FlxG.random.getObject(getIntroTextShit());
		updateJoke = FlxG.random.getObject(getUpdateJokeTextShit());
		devJoke = FlxG.random.getObject(hahaFunnyDevJokeTextBitch());
		brahdafack = FlxG.random.getObject(startmessage());

		super.create();

		FlxG.save.bind('funkin', CoolUtil.getSavePath());

		ClientPrefs.loadPrefs();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Title", "Intro Text");
		#end

		Highscore.load();

		if (!initialized)
		{
			if (FlxG.save.data != null && FlxG.save.data.fullscreen)
			{
				FlxG.fullscreen = FlxG.save.data.fullscreen;
				// trace('LOADED FULLSCREEN SETTING!!');
			}
			persistentUpdate = true;
			persistentDraw = true;
		}

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;
		if (FlxG.save.data.flashing == null && !FlashingState.leftState)
		{
			FlxTransitionableState.skipNextTransIn = false;
			FlxTransitionableState.skipNextTransOut = false;
			MusicBeatState.switchState(new FlashingState());
		}
		else
		{
			if (initialized)
				startIntro();
			else
			{
				new FlxTimer().start(0.2, function(tmr:FlxTimer)
				{
					startIntro();
				});
			}
		}
	}

	var logoBl:FlxSprite;
	var bfBop:FlxSprite;
	//var squars:FlxSprite;
	var squares:FlxBackdrop;
	var menuBGL:FlxSprite;
	var menuBGR:FlxSprite;
	var bumpleft:Bool = false;
	var BGboom:FlxSprite;
	var VersionNumber:FlxSprite;
	#if DEBUG
		var Dev:FlxSprite;
	#end
	var bopLeft:Bool = false;
	var hey:Bool = false;
	var fuckoff:Bool = false;
	var boomleft:Bool = false;
	var titleText:FlxSprite;
	var MMlogo:FlxSprite;
	var swagShader:ColorSwap = null;

	function startIntro()
	{
		if (!initialized)
		{
			if (FlxG.sound.music == null)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			}
		}
		waitwhat = false;

		Conductor.bpm = 114;
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);

		DAFUQWHAT = new FlxSprite(0, 0);
		// DAFUQWHAT.screenCenter(X);
		// DAFUQWHAT.screenCenter(Y);
		DAFUQWHAT.scale.set(1.1, 1.1);
		DAFUQWHAT.frames = Paths.getSparrowAtlas('TitleScreen/TitleTextBG');
		DAFUQWHAT.animation.addByIndices('Left', 'lebg', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], "", 24, false);
		DAFUQWHAT.animation.addByIndices('Right', 'lebg', [10, 11, 12, 13, 14, 15, 16, 17, 18, 19], "", 24, false);
		DAFUQWHAT.animation.addByPrefix('up', 'lebgUP', 24, false);
		DAFUQWHAT.antialiasing = ClientPrefs.data.antialiasing;
		DAFUQWHAT.visible = false;

		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

		squares = new FlxBackdrop(FlxGridOverlay.createGrid(40, 40, 160, 160, true, 0x63000000, 0x0));
		squares.velocity.set(200, 110);
		squares.alpha = 1;

		logoBl = new FlxSprite(-75, -100);
		logoBl.frames = Paths.getSparrowAtlas('TitleScreen/logoBumpin');
		logoBl.animation.addByIndices('bumpleft', 'logo bumpin', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], "", false);
		logoBl.animation.addByIndices('bumpright', 'logo bumpin', [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", false);
		logoBl.antialiasing = ClientPrefs.data.antialiasing;
		logoBl.updateHitbox();
		logoBl.scale.set(0.65, 0.65);
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		MMlogo = new FlxSprite(810, 267);
		MMlogo.frames = Paths.getSparrowAtlas('TitleScreen/MMlogo');
		MMlogo.animation.addByPrefix('shine', 'MENU_megamod', 24, false);
		MMlogo.antialiasing = ClientPrefs.data.antialiasing;
		MMlogo.scale.set(0.5, 0.5);

		if (ClientPrefs.data.shaders)
			swagShader = new ColorSwap();
		BGboom = new FlxSprite(0, 295);
		BGboom.antialiasing = ClientPrefs.data.antialiasing;
		bfBop = new FlxSprite(800, 0);
		bfBop.antialiasing = ClientPrefs.data.antialiasing;
		//squars = new FlxSprite(0, 0);
		//squars.antialiasing = ClientPrefs.data.antialiasing;
		menuBGL = new FlxSprite(0, 0).loadGraphic(Paths.image('TitleScreen/SquaresBG'));
		menuBGL.antialiasing = ClientPrefs.data.antialiasing;
		menuBGR = new FlxSprite(menuBGL.x  + 640, 0).loadGraphic(Paths.image('TitleScreen/MenuBGbitR'));
		menuBGR.antialiasing = ClientPrefs.data.antialiasing;

		BGboom.frames = Paths.getSparrowAtlas('TitleScreen/bgcool');
		BGboom.animation.addByIndices('bounceleft', 'bgcool', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], "", 24, false);
		BGboom.animation.addByIndices('bounceright', 'bgcool', [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

		Vis = new Visualizer(FlxG.sound.music);
		//Vis.scale.set(1.5, 1.5);
		//Vis.updateHitbox();
		Vis.setPosition(BGboom.x, BGboom.y);
		FlxG.debugger.track(Vis);

		VersionNumber = new FlxSprite(BGboom.x + 700, BGboom.y);
		VersionNumber.scale.set(0.2, 0.2);
		VersionNumber.frames = Paths.getSparrowAtlas('TitleScreen/VersionNum');
		VersionNumber.animation.addByPrefix('Ver', 'VersionNumber', 24, true);
		VersionNumber.animation.play('Ver');
		VersionNumber.antialiasing = ClientPrefs.data.antialiasing;
		#if DEBUG
		Dev = new FlxSprite(VersionNumber.x + 200, VersionNumber.y + 70);
		Dev.scale.set(0.2, 0.2);
		Dev.frames = Paths.getSparrowAtlas('TitleScreen/DeveloperMode');
		Dev.animation.addByPrefix('dev', 'menu_debug', 24, true);
		Dev.animation.play('dev');
		Dev.antialiasing = ClientPrefs.data.antialiasing;
		#end

		bfBop.frames = Paths.getSparrowAtlas('TitleScreen/bfBopTitle');
		//same but broken because of force animations doesnt fucking work.
		bfBop.animation.addByIndices('BopL', 'boyfriend_menu', [0,1,2,3,4,5,6,7,8,9,10], "", 24, false);
		bfBop.animation.addByIndices('BopR', 'boyfriend_menu', [0,1,2,3,4,5,6,7,8,9,10], "", 24, false);
		bfBop.animation.addByPrefix('hey', 'boyfriend_menu_hey', 24, false);
		bfBop.animation.addByPrefix('fuck', 'boyfriend_menu_fuckoffmom', 24, false);
		bfBop.scale.set(0.5, 0.5);
		bfBop.updateHitbox();
		//squars.frames = Paths.getSparrowAtlas('TitleScreen/squares');
		//squars.animation.addByPrefix('SQUAR?!', 'menubgbit', 24, true);

		//add(squars);
		add(menuBGL);
		add(squares);
		add(menuBGR);
		add(bfBop);
		add(BGboom);
		add(Vis);
		#if DEBUG add(Dev); #end
		add(VersionNumber);
		add(MMlogo);
		add(logoBl);
		if (swagShader != null)
		{
			BGboom.shader = swagShader.shader;
			bfBop.shader = swagShader.shader;
			logoBl.shader = swagShader.shader;
			menuBGL.shader = swagShader.shader;
			menuBGR.shader = swagShader.shader;
			squares.shader = swagShader.shader;
			VersionNumber.shader = swagShader.shader;
			#if DEBUG
				Dev.shader = swagShader.shader;
			#end
			//squars.shader = swagShader.shader;
		}

		titleText = new FlxSprite(635, 625);
		titleText.frames = Paths.getSparrowAtlas('TitleScreen/titleEnter');
		titleText.scale.set(0.62, 0.62);
		var animFrames:Array<FlxFrame> = [];
		@:privateAccess {
			titleText.animation.findByPrefix(animFrames, "ENTER IDLE");
			titleText.animation.findByPrefix(animFrames, "ENTER FREEZE");
		}

		if (animFrames.length > 0)
		{
			newTitle = true;

			titleText.animation.addByPrefix('idle', "ENTER IDLE", 24);
			titleText.animation.addByPrefix('press', ClientPrefs.data.flashing ? "ENTER PRESSED" : "ENTER FREEZE", 24);
		}
		else
		{
			newTitle = false;

			titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
			titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		}

		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);
		credGroup.add(DAFUQWHAT);

		credTextShit = new Alphabet(0, 0, "", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('TitleScreen/newgrounds_logo'), true, 600);
		add(ngSpr);
		ngSpr.animation.add('idle', [0, 1], 8);
		ngSpr.animation.play('idle');
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.55));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.y += 25;
		ngSpr.antialiasing = ClientPrefs.data.antialiasing;

		// OLD
		// CSLogo = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('TitleScreen/ChickenSwimmer2020_logo'));
		// add(CSLogo);
		// CSLogo.visible = false;
		// CSLogo.setGraphicSize(Std.int(CSLogo.width * 0.8));
		// CSLogo.updateHitbox();
		// CSLogo.screenCenter(X);
		// CSLogo.antialiasing = ClientPrefs.data.antialiasing;

		// NEW
		CSLogo = new FlxSprite(0, 200);
		add(CSLogo);
		CSLogo.frames = Paths.getSparrowAtlas('TitleScreen/ChickenSwimmer2020_logo');
		CSLogo.animation.addByPrefix('Apper', 'CSLogo', 24, false, false, false);
		CSLogo.visible = false;
		// CSLogo.setGraphicSize(Std.int(CSLogo.width * 0.8));
		CSLogo.updateHitbox();
		CSLogo.scale.set(0.5, 0.5);
		CSLogo.screenCenter(X);
		CSLogo.antialiasing = ClientPrefs.data.antialiasing;

		YTLogo = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('TitleScreen/CS2020YT_logo'));
		add(YTLogo);
		YTLogo.visible = false;
		YTLogo.setGraphicSize(Std.int(YTLogo.width * 0.8));
		YTLogo.updateHitbox();
		YTLogo.screenCenter(X);
		YTLogo.antialiasing = ClientPrefs.data.antialiasing;

		if (initialized)
			skipIntro();
		else
			initialized = true;
		if (!ClientPrefs.data.Cache)
		{
			Paths.clearUnusedMemory();
		}
		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('TitleScreen/introText'));
		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	function getUpdateJokeTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('TitleScreen/UpdateJokes'));
		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	function hahaFunnyDevJokeTextBitch():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('TitleScreen/devJokes'));
		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	function startmessage():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('TitleScreen/startLine'));
		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	private static var playJingle:Bool = false;

	var newTitle:Bool = false;
	var titleTimer:Float = 0;

	override function update(elapsed:Float)
	{
		if(TweenComplete)
			FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, 1 - (elapsed * 6));
		FlxG.watch.addQuick("Current Beat", sickBeats);
		FlxG.watch.addQuick('Song Position', Conductor.songPosition);
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;
		}

		if (newTitle)
		{
			titleTimer += FlxMath.bound(elapsed, 0, 1);
			if (titleTimer > 2)
				titleTimer -= 2;
		}

		if (initialized && !transitioning && skippedIntro)
		{
			if (newTitle && !pressedEnter)
			{
				var timer:Float = titleTimer;
				if (timer >= 1)
					timer = (-timer) + 2;

				timer = FlxEase.quadInOut(timer);

				titleText.color = FlxColor.interpolate(titleTextColors[0], titleTextColors[1], timer);
				titleText.alpha = FlxMath.lerp(titleTextAlphas[0], titleTextAlphas[1], timer);
			}

			if (pressedEnter)
			{
				#if desktop
				// Updating Discord Rich Presence
				DiscordClient.changePresence("Title", "Heading to the Main Menu");
				#end
				titleText.color = FlxColor.WHITE;
				titleText.alpha = 1;

				if (titleText != null)
					titleText.animation.play('press');
				if (!fuckoff && willhey)
				{
					hey = true;
					fuckoff = false;
					bfBop.animation.play('hey');
					bfBop.y -= 50;
				}
				else if (fuckoff && !willhey)
				{
					fuckoff = true;
					hey = false;
					bfBop.animation.play('fuck');
				}
				if (ClientPrefs.data.flashing)
				{
					FlxG.camera.flash(FlxColor.WHITE, 1);
				}
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				transitioning = true;
				// FlxG.sound.music.stop();

				// originally worked like this, swapped to do after the player hey animation simply because yes.
				// new FlxTimer().start(1, function(tmr:FlxTimer)
				// {
				//	MusicBeatState.switchState(new MainMenuState());
				//	closedState = true;
				// });
				// works like this now
				bfBop.animation.finishCallback = function(huh)
				{
					// if(!closedState && skippedIntro) { dont use that! fuckes it up if you go back to this screen after going to the game
					if (skippedIntro)
					{
						MusicBeatState.switchState(new MainMenuState());
						closedState = true;
					}
				}
				// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
			}
		}

		if (initialized && pressedEnter && !skippedIntro)
		{
			skipIntro();
			FlxG.sound.music.time = 38000;
		}

		if (swagShader != null)
		{
			if (controls.UI_LEFT)
				swagShader.hue -= elapsed * 0.1;
			if (controls.UI_RIGHT)
				swagShader.hue += elapsed * 0.1;
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true);
			money.screenCenter(X);
			money.y += (i * 60) + 200 + offset;
			if (credGroup != null && textGroup != null)
			{
				credGroup.add(money);
				textGroup.add(money);
			}
		}
	}

	function addMoreText(text:String, ?offset:Float = 0)
	{
		if (textGroup != null && credGroup != null)
		{
			var coolText:Alphabet = new Alphabet(0, 0, text, true);
			coolText.screenCenter(X);
			coolText.y += (textGroup.length * 60) + 200 + offset;
			credGroup.add(coolText);
			textGroup.add(coolText);
		}
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private var sickBeats:Int = 0; // Basically curBeat but won't be skipped if you hold the tab or resize the screen

	public static var closedState:Bool = false;

	override function beatHit()
	{
		super.beatHit();

		if (logoBl != null)
		{
			bumpleft = !bumpleft;
			if (bumpleft)
			{
				logoBl.animation.play('bumpleft');
				if (TweenComplete)
				{
					FlxG.camera.zoom = 1.01;
				}
			}
			else
			{
				logoBl.animation.play('bumpright');
				if (TweenComplete)
				{
					FlxG.camera.zoom = 1.01;
				}
			}
		}

		if (bfBop != null && !hey)
		{
			bopLeft = !bopLeft;
			if (bopLeft && !hey)
				bfBop.animation.play('BopL', true);
			else if (!hey)
				bfBop.animation.play('BopR', true);
		}

		if (DAFUQWHAT != null && !waitwhat)
		{
			DAFUQWHATLEFTY = !DAFUQWHATLEFTY;
			if (DAFUQWHATLEFTY)
				DAFUQWHAT.animation.play('Left', true);
			else
				DAFUQWHAT.animation.play('Right', true);
		}

		if (BGboom != null)
		{
			boomleft = !boomleft;
			if (boomleft)
				BGboom.animation.play('bounceleft');
			else
				BGboom.animation.play('bounceright');
		}

		if (!closedState)
		{
			sickBeats++;
			switch (sickBeats)
			{
				case 1:
					// FlxG.sound.music.stop();
					FlxG.sound.playMusic(Paths.music('freakyMenu'), 1);
				case 2:
					#if PSYCH_WATERMARKS
					createCoolText(['Psych Engine by'], 40);
					#else
					// createCoolText(['ninjamuffin99', 'phantomArcade', 'kawaisprite', 'evilsk8er']);
					#end
				case 4:
					#if PSYCH_WATERMARKS
					addMoreText('Shadow Mario', 40);
					addMoreText('Riveren', 40);
					#else
					addMoreText('present');
					#end
				case 5:
					deleteCoolText();
				case 6:
					createCoolText(['Not associated', 'with'], -40);
				case 8:
					addMoreText('newgrounds', -40);
					ngSpr.visible = true;
				case 9:
					deleteCoolText();
					ngSpr.visible = false;
				case 10:
					createCoolText([curWacky[0]]);
				case 12:
					addMoreText(curWacky[1]);
				case 13:
					deleteCoolText();
				case 14:
					createCoolText(['one man team'], -40);
				case 15:
					createCoolText(['ChickenSwimmer2020'], 20);
					CSLogo.visible = true;
					CSLogo.animation.play('Apper', true);
				case 16:
					createCoolText(['my man'], 90);
				case 17:
					deleteCoolText();
					FlxTween.tween(CSLogo, {y: CSLogo.y - 200, alpha: 0}, 0.5, {
						ease: FlxEase.circIn,
						onComplete: function(Twn:FlxTween)
						{
							CSLogo.visible = false;
						},
					});
				case 18:
					createCoolText(['what else do i say,']);
				case 20:
					addMoreText('subscribe?');
					YTLogo.visible = true;
				case 22:
					deleteCoolText();
					FlxTween.tween(YTLogo, {y: YTLogo.y - 200}, 0.5, {
						ease: FlxEase.circOut,
					});
				case 23:
					FlxTween.tween(YTLogo, {alpha: 0}, 0.5, {
						ease: FlxEase.circIn,
						onComplete: function(Twn:FlxTween)
						{
							YTLogo.visible = false;
						},
					});
					if (!skippedIntro)
					{
						FlxG.sound.play(Paths.sound('bruh'));
					};
				case 25:
					createCoolText([updateJoke[0]]);
				case 27:
					addMoreText(updateJoke[1]);
				case 28:
					deleteCoolText();
				case 29:
					createCoolText([devJoke[0]]);
				case 31:
					addMoreText(devJoke[1]);
				case 32:
					deleteCoolText();
				case 33:
					if (ClientPrefs.data.flashing && !skippedIntro)
					{
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
					}
					DAFUQWHAT.visible = true;
					createCoolText(['Woah!']);
				case 34:
					deleteCoolText();
				case 36:
					createCoolText(['guitar hero']);
					addMoreText('guitar support');
				case 38:
					addMoreText('coming soon!');
				case 39:
					deleteCoolText();
				case 41:
					createCoolText(['so much time, so little to do!']);
				case 42:
					addMoreText('wait, scratch that.');
					addMoreText('flip it around');
				case 43:
					addMoreText('willy wonka - 1971');
				case 44:
					deleteCoolText();
				case 45:
					createCoolText(['now made with the']);
				case 47:
					addMoreText('CS20 Engine!');
				case 48:
					deleteCoolText();
					createCoolText(['CS20 ENGINE IS PSYCH']);
					addMoreText('BUT HEAVILY MODIFIED');
				case 49:
					deleteCoolText();
				case 51:
					#if DEBUG
					createCoolText(['Hi Developer!']);
					#else
					createCoolText(['Welcome Player!']);
					#end
				case 53:
					#if DEBUG
					addMoreText('Remember to build to release');
					#else
					addMoreText('To a massive');
					#end
				case 55:
					#if DEBUG
					addMoreText('to test this message!');
					#else
					addMoreText('Passion Project');
					#end
				case 56:
					deleteCoolText();
				case 58:
					createCoolText(['Now With More Jokes!']);
				case 59:
					//donothing
				case 60:
					deleteCoolText();
					createCoolText(['THE START LINES ARE RANDOM']);
				case 61:
					addMoreText('AND I DONT MEAN THEM.');
				case 63:
					addMoreText('MY FRIENDS GAVE EM');
				case 65:
					deleteCoolText();
					waitwhat = true;
					DAFUQWHAT.animation.curAnim.curFrame = 0;
				case 66:
					waitwhat = true;
				case 67:
					if (ClientPrefs.data.flashing && !skippedIntro)
					{
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						FlxTween.tween(FlxG.camera, {zoom: 1.25}, 0.3, {ease: FlxEase.quadOut, type: ONESHOT});
					}
					createCoolText(['Friday']);
					DAFUQWHAT.animation.play('up');
				case 68:
					if (ClientPrefs.data.flashing && !skippedIntro)
					{
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						FlxTween.tween(FlxG.camera, {zoom: 1.5}, 0.3, {ease: FlxEase.quadOut, type: ONESHOT});
					}
					addMoreText('Night');
					DAFUQWHAT.animation.play('up');
				case 69:
					if (ClientPrefs.data.flashing && !skippedIntro)
					{
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						FlxTween.tween(FlxG.camera, {zoom: 1.75}, 0.3, {ease: FlxEase.quadOut, type: ONESHOT});
					}
					addMoreText('Funkin');
					DAFUQWHAT.animation.play('up');
				case 70:
					if (ClientPrefs.data.flashing && !skippedIntro)
					{
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						FlxTween.tween(FlxG.camera, {zoom: 2}, 0.3, {ease: FlxEase.quadOut, type: ONESHOT});
					}
					addMoreText('MegaMod!');
					DAFUQWHAT.animation.play('up');
				case 71:
					deleteCoolText();
					createCoolText(['V5!'], 140);
					if (ClientPrefs.data.flashing && !skippedIntro)
					{
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						FlxTween.tween(FlxG.camera, {zoom: 3}, 0.1, {ease: FlxEase.quadIn, type: ONESHOT});
					}
				case 72:
					deleteCoolText();
					createCoolText([brahdafack[0]], 140);
					trace('startLine by: ' + brahdafack[1]);
					FlxTween.tween(FlxG.camera, {zoom: 1}, 0.5, {ease: FlxEase.quintInOut, type: ONESHOT});
					DAFUQWHAT.animation.play('up');
				case 73:
					DAFUQWHAT.visible = false;
					skipIntro();
			}
		}
	}

	var skippedIntro:Bool = false;
	var increaseVolume:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);
			remove(YTLogo);
			remove(CSLogo);
			remove(credGroup);
			if (ClientPrefs.data.flashing == true)
			{
				FlxG.camera.flash(FlxColor.WHITE, 4);
			}
			FlxTween.tween(FlxG.camera, {zoom: 5}, 3.5, {
				ease: FlxEase.quintInOut,
				type: BACKWARD,
				onComplete: function(twn:FlxTween)
				{
					TweenComplete = true;
				},
			});
			Vis.initAnalyzer();
			#if desktop
			// Updating Discord Rich Presence
			DiscordClient.changePresence("Title", "Title Screen");
			#end
			skippedIntro = true;
		}
	}
}
