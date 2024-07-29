package states;

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
import states.OutdatedState;
import states.MainMenuState;

typedef TitleData =
{
	titlex:Float,
	titley:Float,
	startx:Float,
	starty:Float,
	bgx:Float,
	bgy:Float,
	bfx:Float,
	bfy:Float,
	squaresY:Float,
	squaresX:Float,
	bpm:Float
}

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

	var willhey:Bool = false;
	
	var titleTextColors:Array<FlxColor> = [0xFF33FFFF, 0xFF3333CC];
	var titleTextAlphas:Array<Float> = [1, .64];

	var curWacky:Array<String> = [];
	var updateJoke:Array<String> = [];
	var devJoke:Array<String> = [];
	var brahdafack:Array<String> = [];

	var wackyImage:FlxSprite;

	#if TITLE_SCREEN_EASTER_EGG
	var easterEggKeys:Array<String> = [
		'SHADOW', 'RIVER', 'BBPANZU'
	];
	var allowedKeys:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	var easterEggKeysBuffer:String = '';
	#end

	var mustUpdate:Bool = false;

	var titleJSON:TitleData;

	public static var updateVersion:String = '';

	override public function create():Void
	{
		//random int code for the 1 in 10000 chance for bf to flip off the player
		var penis:Int;
		penis = FlxG.random.int(1, 10000);
		if(penis == 10000)
			{
				fuckoff = true;
				willhey = false;
			}
		else if(penis < 10000)
			{
				fuckoff = false;
				willhey = true;
			}
		Paths.clearStoredMemory();

		#if LUA_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

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

		#if CHECK_FOR_UPDATES
		if(ClientPrefs.data.checkForUpdates && !closedState) {
			trace('checking for update');
			var http = new haxe.Http("https://raw.githubusercontent.com/ShadowMario/FNF-PsychEngine/main/gitVersion.txt");

			http.onData = function (data:String)
			{
				updateVersion = data.split('\n')[0].trim();
				var curVersion:String = MainMenuState.psychEngineVersion.trim();
				trace('version online: ' + updateVersion + ', your version: ' + curVersion);
				if(updateVersion != curVersion) {
					trace('versions arent matching!');
					mustUpdate = true;
				}
			}

			http.onError = function (error) {
				trace('error: $error');
			}

			http.request();
		}
		#end

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Title", "Intro Text");
		#end

		Highscore.load();

		// IGNORE THIS!!!
		titleJSON = tjson.TJSON.parse(Paths.getTextFromFile('data/TitleScreen/MenuLocations.json'));

		#if TITLE_SCREEN_EASTER_EGG
		if (FlxG.save.data.psychDevsEasterEgg == null) FlxG.save.data.psychDevsEasterEgg = ''; //Crash prevention
		switch(FlxG.save.data.psychDevsEasterEgg.toUpperCase())
		{
			case 'SHADOW':
				titleJSON.gfx += 210;
				titleJSON.gfy += 40;
			case 'RIVER':
				titleJSON.gfx += 180;
				titleJSON.gfy += 40;
			case 'BBPANZU':
				titleJSON.gfx += 45;
				titleJSON.gfy += 100;
		}
		#end

		if(!initialized)
		{
			if(FlxG.save.data != null && FlxG.save.data.fullscreen)
			{
				FlxG.fullscreen = FlxG.save.data.fullscreen;
				//trace('LOADED FULLSCREEN SETTING!!');
			}
			persistentUpdate = true;
			persistentDraw = true;
		}

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;
		#if FREEPLAY
		MusicBeatState.switchState(new FreeplayState());
		#elseif CHARTING
		MusicBeatState.switchState(new ChartingState());
		#else
		if(FlxG.save.data.flashing == null && !FlashingState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		} else {
			if (initialized)
				startIntro();
			else
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					startIntro();
				});
			}
		}
		#end
	}

	var logoBl:FlxSprite;
	var bfBop:FlxSprite;
	var squars:FlxSprite;
	var bumpleft:Bool = false;
	var BGboom:FlxSprite;
	var bopLeft:Bool = false;
	var hey:Bool = false;
	var fuckoff:Bool = false;
	var boomleft:Bool = false;
	var titleText:FlxSprite;
	var swagShader:ColorSwap = null;

	function startIntro()
	{
		if (!initialized)
		{
			if(FlxG.sound.music == null) {
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			}
		}

		Conductor.bpm = titleJSON.bpm;
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	

		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

		logoBl = new FlxSprite(titleJSON.titlex, titleJSON.titley);
		logoBl.frames = Paths.getSparrowAtlas('TitleScreen/logoBumpin');
		logoBl.animation.addByIndices('bumpleft', 'logo bumpin', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], "", false);
		logoBl.animation.addByIndices('bumpright', 'logo bumpin', [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", false);
		logoBl.antialiasing = ClientPrefs.data.antialiasing;
		logoBl.updateHitbox();
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		if(ClientPrefs.data.shaders) swagShader = new ColorSwap();
		BGboom = new FlxSprite(titleJSON.bgx, titleJSON.bgy);
		BGboom.antialiasing = ClientPrefs.data.antialiasing;
		bfBop = new FlxSprite(titleJSON.bfx, titleJSON.bfy);
		bfBop.antialiasing = ClientPrefs.data.antialiasing;
		squars = new FlxSprite(titleJSON.squaresX, titleJSON.squaresY);
		squars.antialiasing = ClientPrefs.data.antialiasing;

		var easterEgg:String = FlxG.save.data.psychDevsEasterEgg;
		if(easterEgg == null) easterEgg = ''; //html5 fix

		switch(easterEgg.toUpperCase())
		{
			// IGNORE THESE, GO DOWN A BIT
			#if TITLE_SCREEN_EASTER_EGG
			case 'SHADOW':
				gfDance.frames = Paths.getSparrowAtlas('ShadowBump');
				gfDance.animation.addByPrefix('danceLeft', 'Shadow Title Bump', 24);
				gfDance.animation.addByPrefix('danceRight', 'Shadow Title Bump', 24);
			case 'RIVER':
				gfDance.frames = Paths.getSparrowAtlas('RiverBump');
				gfDance.animation.addByIndices('danceLeft', 'River Title Bump', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				gfDance.animation.addByIndices('danceRight', 'River Title Bump', [29, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
			case 'BBPANZU':
				gfDance.frames = Paths.getSparrowAtlas('BBBump');
				gfDance.animation.addByIndices('danceLeft', 'BB Title Bump', [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27], "", 24, false);
				gfDance.animation.addByIndices('danceRight', 'BB Title Bump', [27, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], "", 24, false);
			#end

			default:
			//EDIT THIS ONE IF YOU'RE MAKING A SOURCE CODE MOD!!!!
			//EDIT THIS ONE IF YOU'RE MAKING A SOURCE CODE MOD!!!!
			//EDIT THIS ONE IF YOU'RE MAKING A SOURCE CODE MOD!!!!
				BGboom.frames = Paths.getSparrowAtlas('TitleScreen/bgcool');
				BGboom.animation.addByIndices('bounceleft', 'bgcool', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], "", 24, false);
				BGboom.animation.addByIndices('bounceright', 'bgcool', [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				bfBop.frames = Paths.getSparrowAtlas('TitleScreen/bfBopTitle');
				bfBop.animation.addByIndices('Bop', 'boyfriend_menu', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9,], "", 24, false);
				bfBop.animation.addByIndices('Blink', 'boyfriend_menu', [10, 11, 12, 13, 14, 15, 16, 17, 18], "", 24, false);
				bfBop.animation.addByPrefix('hey', 'boyfriend_menu_hey', 24, false);
				bfBop.animation.addByPrefix('fuck', 'boyfriend_menu_fuckoffmom', 24, false);
				squars.frames = Paths.getSparrowAtlas('TitleScreen/squares');
				squars.animation.addByPrefix('SQUAR?!', 'menubgbit', 24, true);
		}

		add(squars);
		add(bfBop);
		add(BGboom);
		add(logoBl);
		if(swagShader != null)
		{
			BGboom.shader = swagShader.shader;
			bfBop.shader = swagShader.shader;
			logoBl.shader = swagShader.shader;
			squars.shader = swagShader.shader;
		}

		titleText = new FlxSprite(titleJSON.startx, titleJSON.starty);
		titleText.frames = Paths.getSparrowAtlas('TitleScreen/titleEnter');
		var animFrames:Array<FlxFrame> = [];
		@:privateAccess {
			titleText.animation.findByPrefix(animFrames, "ENTER IDLE");
			titleText.animation.findByPrefix(animFrames, "ENTER FREEZE");
		}
		
		if (animFrames.length > 0) {
			newTitle = true;
			
			titleText.animation.addByPrefix('idle', "ENTER IDLE", 24);
			titleText.animation.addByPrefix('press', ClientPrefs.data.flashing ? "ENTER PRESSED" : "ENTER FREEZE", 24);
		}
		else {
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

		credTextShit = new Alphabet(0, 0, "", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('TitleScreen/newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = ClientPrefs.data.antialiasing;

		CSLogo = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('TitleScreen/ChickenSwimmer2020_logo'));
		add(CSLogo);
		CSLogo.visible = false;
		CSLogo.setGraphicSize(Std.int(CSLogo.width * 0.8));
		CSLogo.updateHitbox();
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

		Paths.clearUnusedMemory();
		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		#if MODS_ALLOWED
		var firstArray:Array<String> = Mods.mergeAllTextsNamed('data/TitleScreen/introText.txt', Paths.getSharedPath());
		#else
		var fullText:String = Assets.getText(Paths.txt('data/TitleScreen/introText'));
		var firstArray:Array<String> = fullText.split('\n');
		#end
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
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}
		
		if (newTitle) {
			titleTimer += FlxMath.bound(elapsed, 0, 1);
			if (titleTimer > 2) titleTimer -= 2;
		}

		// EASTER EGG

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
			
			if(pressedEnter)
			{	
				#if desktop
				// Updating Discord Rich Presence
				DiscordClient.changePresence("Title", "Heading to the Main Menu");
				#end
				titleText.color = FlxColor.WHITE;
				titleText.alpha = 1;
				
				if(titleText != null) titleText.animation.play('press');
					if(!fuckoff && willhey)
						{
							hey = true;
							fuckoff = false;
							bfBop.animation.play('hey');
							bfBop.x = titleJSON.bfx + 100;
							bfBop.y = titleJSON.bfy - 50;
						}
					else if(fuckoff && !willhey)
						{
							fuckoff = true;
							hey = false;
							bfBop.animation.play('fuck');
						}
					if(ClientPrefs.data.flashing){
						FlxG.camera.flash(FlxColor.WHITE, 1);
					}
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				transitioning = true;
				// FlxG.sound.music.stop();

				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					if (mustUpdate) {
						MusicBeatState.switchState(new OutdatedState());
					} else {
						MusicBeatState.switchState(new MainMenuState());
					}
					closedState = true;
				});
				// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
			}
			#if TITLE_SCREEN_EASTER_EGG
			else if (FlxG.keys.firstJustPressed() != FlxKey.NONE)
			{
				var keyPressed:FlxKey = FlxG.keys.firstJustPressed();
				var keyName:String = Std.string(keyPressed);
				if(allowedKeys.contains(keyName)) {
					easterEggKeysBuffer += keyName;
					if(easterEggKeysBuffer.length >= 32) easterEggKeysBuffer = easterEggKeysBuffer.substring(1);
					//trace('Test! Allowed Key pressed!!! Buffer: ' + easterEggKeysBuffer);

					for (wordRaw in easterEggKeys)
					{
						var word:String = wordRaw.toUpperCase(); //just for being sure you're doing it right
						if (easterEggKeysBuffer.contains(word))
						{
							//trace('YOOO! ' + word);
							if (FlxG.save.data.psychDevsEasterEgg == word)
								FlxG.save.data.psychDevsEasterEgg = '';
							else
								FlxG.save.data.psychDevsEasterEgg = word;
							FlxG.save.flush();

							FlxG.sound.play(Paths.sound('ToggleJingle'));

							var black:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
							black.alpha = 0;
							add(black);

							FlxTween.tween(black, {alpha: 1}, 1, {onComplete:
								function(twn:FlxTween) {
									FlxTransitionableState.skipNextTransIn = true;
									FlxTransitionableState.skipNextTransOut = true;
									MusicBeatState.switchState(new TitleState());
								}
							});
							FlxG.sound.music.fadeOut();
							if(FreeplayState.vocals != null)
							{
								FreeplayState.vocals.fadeOut();
							}
							closedState = true;
							transitioning = true;
							playJingle = true;
							easterEggKeysBuffer = '';
							break;
						}
					}
				}
			}
			#end
		}

		if (initialized && pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		if(swagShader != null)
		{
			if(controls.UI_LEFT) swagShader.hue -= elapsed * 0.1;
			if(controls.UI_RIGHT) swagShader.hue += elapsed * 0.1;
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
			if(credGroup != null && textGroup != null) {
				credGroup.add(money);
				textGroup.add(money);
			}
		}
	}

	function addMoreText(text:String, ?offset:Float = 0)
	{
		if(textGroup != null && credGroup != null) {
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

	private var sickBeats:Int = 0; //Basically curBeat but won't be skipped if you hold the tab or resize the screen
	public static var closedState:Bool = false;
	override function beatHit()
	{
		super.beatHit();
		if(squars != null)
			squars.animation.play('SQUAR?!', true);

		if(logoBl != null){
			bumpleft = !bumpleft;
			if (bumpleft)
				logoBl.animation.play('bumpleft');
			else
				logoBl.animation.play('bumpright');
		}

		if(bfBop != null && !hey){
			bopLeft = !bopLeft;
			if (bopLeft)
				bfBop.animation.play('Bop');
			else if (!hey)
				bfBop.animation.play('Blink');
		}
		if(BGboom != null){
			boomleft = !boomleft;
			if (boomleft)
				BGboom.animation.play('bounceleft');
			else
				BGboom.animation.play('bounceright');
		}

		if(!closedState) {
			sickBeats++;
			switch (sickBeats)
			{
				case 1:
					//FlxG.sound.music.stop();
					FlxG.sound.playMusic(Paths.music('freakyMenu'), 4);
				case 2:
					#if PSYCH_WATERMARKS
					createCoolText(['Psych Engine by'], 40);
					#else
					//createCoolText(['ninjamuffin99', 'phantomArcade', 'kawaisprite', 'evilsk8er']);
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
					#if PSYCH_WATERMARKS
					createCoolText(['Not associated', 'with'], -40);
					#else
					createCoolText(['In association', 'with'], -40);
					#end
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
				case 16:
					createCoolText(['my man'], 90);
				case 17:
					deleteCoolText();
					CSLogo.visible = false;
				case 18:
					createCoolText(['what else do i say,']);
				case 19:
					addMoreText('Subscribe?');
					if (skippedIntro == false){
					FlxG.sound.play(Paths.sound('bruh'));
					};
					YTLogo.visible = true;
				case 20:
					deleteCoolText();
					YTLogo.visible = false;
				case 21:
					createCoolText([updateJoke[0]]);
				case 22:
					addMoreText(updateJoke[1]);
				case 23:
					deleteCoolText();
				case 24:
					createCoolText([devJoke[0]]);
				case 25:
					addMoreText(devJoke[1]);
				case 26:
					deleteCoolText();
				case 27:
					addMoreText('Friday');
					if (!skippedIntro){
					FlxTween.tween(FlxG.camera, {zoom:1.25}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
					};
				case 28:
					addMoreText('Night');
						if (!skippedIntro){
							FlxTween.tween(FlxG.camera, {zoom:1.5}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
						};
				case 29:
					addMoreText('Funkin'); // credTextShit.text += '\nFunkin';
						if (!skippedIntro){
							FlxTween.tween(FlxG.camera, {zoom:1.75}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
						};
				case 30:
					addMoreText('MegaMod!');
						if (!skippedIntro){
							FlxTween.tween(FlxG.camera, {zoom:2}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
						};
				case 31:
					deleteCoolText();
					createCoolText([brahdafack[0]], 90);

				case 32:
					deleteCoolText();

				case 33:
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
			if (playJingle) //Ignore deez
			{
				var easteregg:String = FlxG.save.data.psychDevsEasterEgg;
				if (easteregg == null) easteregg = '';
				easteregg = easteregg.toUpperCase();

				var sound:FlxSound = null;
				switch(easteregg)
				{
					case 'RIVER':
						sound = FlxG.sound.play(Paths.sound('JingleRiver'));
					case 'SHADOW':
						FlxG.sound.play(Paths.sound('JingleShadow'));
					case 'BBPANZU':
						sound = FlxG.sound.play(Paths.sound('JingleBB'));

					default: //Go back to normal ugly ass boring GF
						remove(ngSpr);
						remove(credGroup);
							if(ClientPrefs.data.flashing == true){
								FlxG.camera.flash(FlxColor.WHITE, 2);
							}
						skippedIntro = true;
						playJingle = false;

						FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
						FlxG.sound.music.fadeIn(4, 0, 0.7);
						return;
				}

				transitioning = true;
				if(easteregg == 'SHADOW')
				{
					new FlxTimer().start(3.2, function(tmr:FlxTimer)
					{
						remove(ngSpr);
						remove(credGroup);
							if(ClientPrefs.data.flashing == true){
								FlxG.camera.flash(FlxColor.WHITE, 0.6);
							}
						transitioning = false;
					});
				}
				else
				{
					remove(ngSpr);
					remove(credGroup);
						if(ClientPrefs.data.flashing == true){
							FlxG.camera.flash(FlxColor.WHITE, 3);
						}
					sound.onComplete = function() {
						FlxG.sound.playMusic(Paths.music('freakyMenu-loop'), 0);
						FlxG.sound.music.fadeIn(4, 0, 0.7);
						transitioning = false;
					};
				}
				playJingle = false;
			}
			else //Default! Edit this one!!
			{
				remove(ngSpr);
				remove(YTLogo);
				remove(CSLogo);
				remove(credGroup);
					if(ClientPrefs.data.flashing == true){
						FlxG.camera.flash(FlxColor.WHITE, 4);
					}
				FlxTween.tween(FlxG.camera, {zoom:5}, 3.5, {ease: FlxEase.quadInOut, type: BACKWARD});
				var easteregg:String = FlxG.save.data.psychDevsEasterEgg;
				if (easteregg == null) easteregg = '';
				easteregg = easteregg.toUpperCase();
					#if desktop
					// Updating Discord Rich Presence
					DiscordClient.changePresence("Title", "Title Screen");
					#end
				#if TITLE_SCREEN_EASTER_EGG
				if(easteregg == 'SHADOW')
				{
					FlxG.sound.music.fadeOut();
					if(FreeplayState.vocals != null)
					{
						FreeplayState.vocals.fadeOut();
					}
				}
				#end
			}
			skippedIntro = true;
		}
	}
}