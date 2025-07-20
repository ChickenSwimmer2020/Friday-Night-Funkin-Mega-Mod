package states;

import flixel.math.FlxRandom;
import shaders.RGBPalette;
import backend.WeekData;
import backend.Highscore;
import backend.Song;
import objects.HealthIcon;
import objects.MusicPlayer;
import options.GameplayChangersSubstate;
import substates.ResetScoreSubState;
import flixel.math.FlxMath;
import flixel.util.FlxDestroyUtil;
import haxe.Json;


import shaders.RGBPalette;
import shaders.RGBPalette.RGBShaderReference;

typedef BPMS =
{
	bpm:Float
}

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var JB:FlxSprite;
	var JBC:FlxSprite;
	var JBB:FlxSprite;
	var Console:FlxSprite;
	var Glass:FlxSprite;

	var record:FlxSprite;
	var curFrame:Int = 0;

	var curSong:Int;

	var bopspeed:Int = 2; // starts at two to prevent a crash
	var cambopspeed:Int = 4;

	var selector:FlxText;

	private static var curSelected:Int = 0;

	var lerpSelected:Float = 0;
    var oldDifficulty:Int = -1;
	var curDifficulty:Int = -1;

	private static var lastDifficultyName:String = Difficulty.getDefault();

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite;

	var missingTextBG:FlxSprite;
	var missingText:FlxText;

	var bottomString:String;
	var bottomText:FlxText;
	var bottomBG:FlxSprite;

	var player:MusicPlayer;

	public var songLowercase:String;

	public var choosenSong:String = '';


	public var JBShader:RGBShaderReference;
	var pallet:RGBPalette = new RGBPalette();

	override function create()
	{	
		curSong = 0;
        curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(lastDifficultyName)));

		// Pink = 0
		// Red = 1
		// Teal = 2
		// Aqua = 3
		// Green = 4
		// Cyan = 5
		// Sans = 6
		// Purple = 7

		JB = new FlxSprite(0, 0).loadGraphic(Paths.image('JB_C'));

		Glass = new FlxSprite(0, 0).loadGraphic(Paths.image('jukebox_OVERLAY'));
		Glass.scale.set(0.4,0.405);
		Glass.setPosition(JB.x + 198, JB.y + 227);
		Glass.antialiasing = ClientPrefs.data.antialiasing;
		Glass.updateHitbox();

		Console = new FlxSprite(JB.x + 0, JB.y + 250);
		Console.frames = Paths.getSparrowAtlas('JukeBox_PANEL');
		Console.animation.addByIndices('Easy', 'jukebox_DifficultyConsole', [0], "", 24, false, false, false);
		Console.animation.addByIndices('Easy_TransitionToNormal', 'jukebox_DifficultyConsole', [1, 2], "", 24, false, false, false);
        Console.animation.addByIndices('Normal_TransitionToEasy', 'jukebox_DifficultyConsole', [2, 1], "", 24, false, false, false);
		Console.animation.addByIndices('Normal', 'jukebox_DifficultyConsole', [3], "", 24, false, false, false);
		Console.animation.addByIndices('Normal_TransitionToHard', 'jukebox_DifficultyConsole', [4, 5], "", 24, false, false, false);
        Console.animation.addByIndices('Hard_TransitionToNormal', 'jukebox_DifficultyConsole', [5, 4], "", 24, false, false, false);
		Console.animation.addByIndices('Hard', 'jukebox_DifficultyConsole', [6], "", 24, false, false, false);
		Console.animation.addByIndices('Hard_TransitionToNightmare', 'jukebox_DifficultyConsole', [7, 8], "", 24, false, false, false);
        Console.animation.addByIndices('Nightmare_TransitionToHard', 'jukebox_DifficultyConsole', [8, 7], "", 24, false, false, false);
		Console.animation.addByIndices('Nightmare', 'jukebox_DifficultyConsole', [9], "", 24, false, false, false);
		Console.animation.addByIndices('Nightmare_TransitionToErect', 'jukebox_DifficultyConsole', [10, 11], "", 24, false, false, false);
        Console.animation.addByIndices('Erect_TransitionToNightmare', 'jukebox_DifficultyConsole', [11, 10], "", 24, false, false, false);
		Console.animation.addByIndices('Erect', 'jukebox_DifficultyConsole', [12], "", 24, false, false, false);
		Console.animation.addByIndices('Erect_TransitionToEasy', 'jukebox_DifficultyConsole', [13, 14], "", 24, false, false, false);
        Console.animation.addByIndices('Easy_TransitionToErect', 'jukebox_DifficultyConsole', [14, 13], "", 24, false, false, false); //TODO: change this to a spritemap AND implement transitions for Precursor difficulty
        // TODO: Implement
		Console.animation.addByIndices('Static', 'jukebox_DifficultyConsole', [15, 16], "", 24, true, false, false); // For locked difficulties
        Console.animation.play(difficultyToString(curDifficulty));
		Console.antialiasing = ClientPrefs.data.antialiasing;

		JB.antialiasing = ClientPrefs.data.antialiasing;

		JB.scale.set(0.9, 0.9);
		JB.setPosition(-120, 100);
		Console.scale.set(0.35, 0.35);

		//record
		record = new FlxSprite(Glass.x + 15, Glass.y + 52);
		record.frames = Paths.getSparrowAtlas('freeplay_songs');
		record.animation.addByIndices('SONG_SystemPRE', 'therealerecordwithmask', [for (i in 0...23) i], "", 30, false, false, false);
		record.animation.addByIndices('SONG_Tutorial', 'therealerecordwithmask', [for (i in 24...47) i], "", 30, false, false, false);
		record.animation.addByIndices('SONG_System', 'therealerecordwithmask', [for (i in 48...71) i], "", 30, false, false, false);
		record.scale.set(0.25, 0.25);
		record.updateHitbox();
		record.antialiasing = ClientPrefs.data.antialiasing;


		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		Conductor.bpm = 114; //fix camera speed error
		bopspeed = 2; // fixes anim play speed on state reopen
		cambopspeed = 4;
		record.animation.timeScale = 1;


		var JBO:FlxSprite = new FlxSprite(JB.x - 2, JB.y - 2).loadGraphic(Paths.image('JB_O'));
		JBO.scale.set(JB.scale.x, JB.scale.y);

		JBC = new FlxSprite(JB.x + 132, JB.y + 28);
		JBC.frames = Paths.getSparrowAtlas('JB_G');
		JBC.animation.addByPrefix('JB_G', 'jukebox_colors_glow', 24, false, false, false);

		JBB = new FlxSprite(JBC.x + 50, JBC.y + 18);
		JBB.frames = Paths.getSparrowAtlas('JB_B');
		JBB.animation.addByPrefix('flow', 'JukeBox_BUBBLES', 24, true, false, false); //TODO: find way to make bubbles spritesheet small, AND fix sprite animation loop.
		JBB.animation.play('flow');
		JBB.animation.timeScale = 0.8;

		

		pallet.r = colors[0];
		pallet.g = colors[0];
		pallet.b = colors[0];

		JBShader = new RGBShaderReference(JBC, pallet);

		if (WeekData.weeksList.length < 1)
		{
			FlxTransitionableState.skipNextTransIn = true;
			persistentUpdate = false;
			MusicBeatState.switchState(new states.ErrorState("NO WEEKS ADDED FOR FREEPLAY\n\nPress ACCEPT to go to the Week Editor Menu.\nPress BACK to return to Main Menu.",
				function() MusicBeatState.switchState(new states.editors.WeekEditorState()),
				function() MusicBeatState.switchState(new states.MainMenuState())));
			return;
		}

		for (i in 0...WeekData.weeksList.length)
		{
			if (weekIsLocked(WeekData.weeksList[i]))
				continue;

			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if (colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}
		Mods.loadTopMod();

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(90, 320, songs[i].songName, true);
			songText.targetY = i;
			grpSongs.add(songText);

			songText.scaleX = Math.min(1, 980 / songText.width);
			songText.snapToPosition();

			Mods.currentModDirectory = songs[i].folder;
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// too laggy with a lot of songs, so i had to recode the logic for it
			songText.visible = songText.active = songText.isMenuItem = false;
			icon.visible = icon.active = false;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		WeekData.setDirectoryFromWeek();

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(null, 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		missingTextBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		missingTextBG.alpha = 0.6;
		missingTextBG.visible = false;
		add(missingTextBG);

		missingText = new FlxText(50, 0, FlxG.width - 100, '', 24);
		missingText.setFormat(null, 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		missingText.scrollFactor.set();
		missingText.visible = false;
		add(missingText);

		if (curSelected >= songs.length)
			curSelected = 0;
		lerpSelected = curSelected;

		bottomBG = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		bottomBG.alpha = 0.6;
		//add(animationBG);
		add(JB);
		add(JBC);
		add(JBB);
		add(JBO);
		add(record);
		add(Glass);
		add(Console); // BG TRIED TO HIDE THEM, FUCK THE BG.
		add(bottomBG);
		



		var leText:String = Language.getPhrase("freeplay_tip",
			"Press SPACE to listen to the Song / Press CTRL to open the Gameplay Changers Menu / Press RESET to Reset your Score and Accuracy.");
		bottomString = leText;
		var size:Int = 16;
		bottomText = new FlxText(bottomBG.x, bottomBG.y + 4, FlxG.width, leText, size);
		bottomText.setFormat(null, size, FlxColor.WHITE, CENTER);
		bottomText.scrollFactor.set();
		add(bottomText);

		player = new MusicPlayer(this);
		add(player);

		changeSelection();
		updateTexts();
		super.create();
	}

	override function closeSubState()
	{
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color));
	}

	function weekIsLocked(name:String):Bool
	{
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked
			&& leWeek.weekBefore.length > 0
			&& (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}

	var instPlaying:Int = -1;

	public static var vocals:FlxSound = null;
	public static var opponentVocals:FlxSound = null;

	var holdTime:Float = 0;

	var stopMusicPlay:Bool = false;

    
    inline function difficultyToString(diff:Int)
        return diff == -1 ? 'Static' : diff == 0 ? 'Easy' : diff == 1 ? 'Normal' : diff == 2 ? 'Hard' : diff == 3 ? 'Nightmare' : diff == 4 ? 'Erect' : diff == 5 ? 'Precursor' : 'Unknown';

	override function update(elapsed:Float)
	{
		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		if(!player.playingMusic)
			DiscordClient.changePresence("Freeplay", 'Choosing song: $choosenSong');
		else
			DiscordClient.changePresence("Freeplay", 'Listening to: $choosenSong', null, true, null, 'icon');
		#end

		//trace(curSong);
		if(record.animation.curAnim != null)
			curFrame = record.animation.curAnim.curFrame;
		if(record.animation.curAnim != null && record.animation.curAnim.curFrame == 22)
			record.animation.curAnim.restart();

		FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, 1 - (elapsed * 6));

		Conductor.songPosition = FlxG.sound.music.time;

		switch(curSelected) {
			case 0:
				record.animation.play('SONG_Tutorial', false, false, curFrame);
				choosenSong = 'Tutorial';
				songLowercase = 'tutorial'; //bandaid fix
			case 1:
				record.animation.play(difficultyToString(curDifficulty) == 'Precursor' ? 'SONG_SystemPRE' : 'SONG_System', false, false, curFrame);
				choosenSong = 'System';
				songLowercase = 'system';
		}

		
        if (Console.animation.curAnim != null){
            if (Console.animation.curAnim.finished && curDifficulty != -1)
                Console.animation.play(difficultyToString(curDifficulty));
        }else if (curDifficulty == -1)
            Console.animation.play(difficultyToString(curDifficulty));

        if(player.playingMusic)
            record.animation.timeScale = 8; //fix for an error with timescale

		if (WeekData.weeksList.length < 1)
			return;

		if (FlxG.sound.music.volume < 0.7)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		lerpScore = Math.floor(FlxMath.lerp(intendedScore, lerpScore, Math.exp(-elapsed * 24)));
		lerpRating = FlxMath.lerp(intendedRating, lerpRating, Math.exp(-elapsed * 12));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(CoolUtil.floorDecimal(lerpRating * 100, 2)).split('.');
		if (ratingSplit.length < 2) // No decimals, add an empty space
			ratingSplit.push('');

		while (ratingSplit[1].length < 2) // Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';

		var shiftMult:Int = 1;
		if (FlxG.keys.pressed.SHIFT)
			shiftMult = 3;

		if (!player.playingMusic)
		{
			scoreText.text = Language.getPhrase('personal_best', 'PERSONAL BEST: {1} ({2}%)', [lerpScore, ratingSplit.join('.')]);
			positionHighscore();

			if (songs.length > 1)
			{
				if (FlxG.keys.justPressed.HOME)
				{
					curSelected = 0;
					changeSelection();
					holdTime = 0;
				}
				else if (FlxG.keys.justPressed.END)
				{
					curSelected = songs.length - 1;
					changeSelection();
					holdTime = 0;
				}
				if (controls.UI_UP_P)
				{
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (controls.UI_DOWN_P)
				{
					changeSelection(shiftMult);
 					holdTime = 0;
				}

				if (controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if (holdTime > 0.5 && checkNewHold - checkLastHold > 0)
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
				}

				if (FlxG.mouse.wheel != 0)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
					changeSelection(-shiftMult * FlxG.mouse.wheel, false);
				}
			}

			if (controls.UI_LEFT_P)
			{
				changeDiff(-1);
				_updateSongLastDifficulty();
			}
			else if (controls.UI_RIGHT_P)
			{
				changeDiff(1);
				_updateSongLastDifficulty();
			}
		}

		if (controls.BACK)
		{
			Conductor.bpm = 114;

			if (player.playingMusic)
			{
				FlxG.sound.music.stop();
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;
				instPlaying = -1;

				player.playingMusic = false;
				player.switchPlayMusic();

				record.animation.timeScale = 1; //fix record spin speed on song unload

				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
				// FlxTween.tween(FlxG.sound.music, {volume: 1}, 1);
			}
			else
			{
				persistentUpdate = false;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}
		}

		if (FlxG.keys.justPressed.CONTROL && !player.playingMusic)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else if (FlxG.keys.justPressed.SPACE)
		{
			if (instPlaying != curSelected && !player.playingMusic)
			{
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;

				Mods.currentModDirectory = songs[curSelected].folder;
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				if (PlayState.SONG.needsVoices)
				{
					vocals = new FlxSound();
					try
					{
						var playerVocals:String = getVocalFromCharacter(PlayState.SONG.player1);
						var loadedVocals = Paths.voices(PlayState.SONG.song, (playerVocals != null && playerVocals.length > 0) ? playerVocals : (curDifficulty == 5) ? 'Player-OG' : 'Player');
						if (loadedVocals == null)
							loadedVocals = Paths.voices(PlayState.SONG.song);

						if (loadedVocals != null && loadedVocals.length > 0)
						{
							vocals.loadEmbedded(loadedVocals);
							FlxG.sound.list.add(vocals);
							vocals.persist = vocals.looped = true;
							vocals.volume = 0.8;
							vocals.play();
							vocals.pause();
						}
						else
							vocals = FlxDestroyUtil.destroy(vocals);
					}
					catch (e:Dynamic)
					{
						vocals = FlxDestroyUtil.destroy(vocals);
					}

					opponentVocals = new FlxSound();
					try
					{
						// trace('please work...');
						var oppVocals:String = getVocalFromCharacter(PlayState.SONG.player2);
						var loadedVocals = Paths.voices(PlayState.SONG.song, (oppVocals != null && oppVocals.length > 0) ? oppVocals : (curDifficulty == 5) ? 'Opponent-OG' : 'Opponent');

						if (loadedVocals != null && loadedVocals.length > 0)
						{
							opponentVocals.loadEmbedded(loadedVocals);
							FlxG.sound.list.add(opponentVocals);
							opponentVocals.persist = opponentVocals.looped = true;
							opponentVocals.volume = 0.8;
							opponentVocals.play();
							opponentVocals.pause();
							// trace('yaaay!!');
						}
						else
							opponentVocals = FlxDestroyUtil.destroy(opponentVocals);
					}
					catch (e:Dynamic)
					{
						// trace('FUUUCK');
						opponentVocals = FlxDestroyUtil.destroy(opponentVocals);
					}
				}

				var SongBPM:SwagSong /*BPMS*/ = /*cast haxe.Json.parse*/ Song.parseJSON(File.getContent('assets/shared/data/${songs[curSelected].songName.toLowerCase()}/${songs[curSelected].songName.toLowerCase()}.json'),
					'You\'re Mom');
				Conductor.bpm = SongBPM.bpm;
				

				#if debug
				trace(Conductor.bpm);
				// trace(File.getContent('assets/shared/data/${songs[curSelected].songName.toLowerCase()}/${songs[curSelected].songName.toLowerCase()}.json'));
				#end

				switch (poop)
				{
					case 'system':
						bopspeed = 2;
						cambopspeed = 4;
						record.animation.timeScale = 8; //hehe, record go BRRRRRRRRRRR
					case 'tutorial':
						bopspeed = 4;
						cambopspeed = 8;
						record.animation.timeScale = 8;
					default:
						bopspeed = 2;
						cambopspeed = 4;
						record.animation.timeScale = 1;
				}

				if(curDifficulty == 5) //should be the Precursor difficulty
					FlxG.sound.playMusic(Paths.inst('${PlayState.SONG.song}', '-OG'), 0.8);
				else
					FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.8);

				FlxG.sound.music.pause();
				instPlaying = curSelected;

				player.playingMusic = true;
				player.curTime = 0;
				player.switchPlayMusic();
				player.pauseOrResume(true);
			}
			else if (instPlaying == curSelected && player.playingMusic)
			{
				player.pauseOrResume(!player.playing);
			}
		}
		else if (controls.ACCEPT && !player.playingMusic)
		{
			persistentUpdate = false;
			var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
			songLowercase = Paths.formatToSongPath(songs[curSelected].songName);
			try
			{
				Song.loadFromJson(poop, songLowercase);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;

				trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
			}
			catch (e:haxe.Exception)
			{
				trace('ERROR! ${e.message}');

				var errorStr:String = e.message;
				if (errorStr.contains('There is no TEXT asset with an ID of'))
					errorStr = 'Missing file: ' + errorStr.substring(errorStr.indexOf(songLowercase), errorStr.length - 1); // Missing chart
				else
					errorStr += '\n\n' + e.stack;

				missingText.text = 'ERROR WHILE LOADING CHART:\n$errorStr';
				missingText.screenCenter(Y);
				missingText.visible = true;
				missingTextBG.visible = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				updateTexts(elapsed);
				super.update(elapsed);
				return;
			}

			LoadingState.prepareToSong();
			LoadingState.loadAndSwitchState(new PlayState());

			destroyFreeplayVocals();
			#if (MODS_ALLOWED && DISCORD_ALLOWED)
			DiscordClient.loadModRPC();
			#end
		}
		else if (controls.RESET && !player.playingMusic)
		{
			persistentUpdate = false;
			openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}

		updateTexts(elapsed);
		super.update(elapsed);
	}

	var random:FlxRandom = new FlxRandom();
	var curCol:Int = 0;
	var lastCol:Int = 0;

	var colors:Array<Int> = [
		0xFFFFFFFF, // White
		0xFFFFB9F6, // Pink
		0xFFFF0000, // Red
		0xFF88FFFF, // Teal
		0xFF66A7A7, // Aqua
		0xFF00FF00, // Green
		0xFF00FFFF, // Cyan
		0xFFFFF99E, // Sans
		0xFF800080  // Purple
	];

	override function beatHit()
	{
		super.beatHit();
		if (curBeat % bopspeed == 0)
		{
			while (curCol == lastCol)
				curCol = random.int(0, colors.length -1);

			pallet.r = colors[curCol];
			pallet.g = colors[curCol];
			pallet.b = colors[curCol];
			
			JBC.animation.play('JB_G', true, false);

			lastCol = curCol;
			FlxG.camera.zoom = 1.02;
		}
	}

	function getVocalFromCharacter(char:String)
	{
		try
		{
			var path:String = Paths.getPath('characters/$char.json', TEXT);
			#if MODS_ALLOWED
			var character:Dynamic = Json.parse(File.getContent(path));
			#else
			var character:Dynamic = Json.parse(Assets.getText(path));
			#end
			return character.vocals_file;
		}
		catch (e:Dynamic)
		{
		}
		return null;
	}

	public static function destroyFreeplayVocals()
	{
		if (vocals != null)
			vocals.stop();
		vocals = FlxDestroyUtil.destroy(vocals);

		if (opponentVocals != null)
			opponentVocals.stop();
		opponentVocals = FlxDestroyUtil.destroy(opponentVocals);
	}

	function changeDiff(change:Int = 0)
	{
		if (player.playingMusic)
			return;

        oldDifficulty = curDifficulty;
		curDifficulty = FlxMath.wrap(curDifficulty + change, 0, Difficulty.list.length - 1);
		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		lastDifficultyName = Difficulty.getString(curDifficulty, false);
		var displayDiff:String = Difficulty.getString(curDifficulty);
		if (Difficulty.list.length > 1)
			diffText.text = '< ' + displayDiff.toUpperCase() + ' >';
		else
			diffText.text = displayDiff.toUpperCase();

		positionHighscore();
		missingText.visible = false;
		missingTextBG.visible = false;

        runConsoleTransitionAnim();
	}

    function runConsoleTransitionAnim()
    {
        var animName = '${difficultyToString(oldDifficulty)}_TransitionTo${difficultyToString(curDifficulty)}';
        if (oldDifficulty != -1 && oldDifficulty != curDifficulty && Console.animation.exists(animName))
            Console.animation.play(animName);
    }

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if (player.playingMusic)
			return;

        oldDifficulty = curDifficulty;
		curSelected = FlxMath.wrap(curSelected + change, 0, songs.length - 1);
		_updateSongLastDifficulty();
		if (playSound)
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		for (num => item in grpSongs.members)
		{
			var icon:HealthIcon = iconArray[num];
			item.alpha = 0.6;
			icon.alpha = 0.6;
			if (item.targetY == curSelected)
			{
				item.alpha = 1;
				icon.alpha = 1;
			}
		}

		Mods.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;
		Difficulty.loadFromWeek();

		var savedDiff:String = songs[curSelected].lastDifficulty;
		var lastDiff:Int = Difficulty.list.indexOf(lastDifficultyName);
		if (savedDiff != null && !Difficulty.list.contains(savedDiff) && Difficulty.list.contains(savedDiff))
			curDifficulty = Math.round(Math.max(0, Difficulty.list.indexOf(savedDiff)));
		else if (lastDiff > -1)
			curDifficulty = lastDiff;
		else if (Difficulty.list.contains(Difficulty.getDefault()))
			curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(Difficulty.getDefault())));
		else
			curDifficulty = 0;

		changeDiff();
		_updateSongLastDifficulty();
        runConsoleTransitionAnim();
	}

	inline private function _updateSongLastDifficulty()
		songs[curSelected].lastDifficulty = Difficulty.getString(curDifficulty, false);

	private function positionHighscore()
	{
		scoreText.x = FlxG.width - scoreText.width - 6;
		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;
	}

	var _drawDistance:Int = 4;
	var _lastVisibles:Array<Int> = [];

	public function updateTexts(elapsed:Float = 0.0)
	{
		lerpSelected = FlxMath.lerp(curSelected, lerpSelected, Math.exp(-elapsed * 9.6));
		for (i in _lastVisibles)
		{
			grpSongs.members[i].visible = grpSongs.members[i].active = false;
			iconArray[i].visible = iconArray[i].active = false;
		}
		_lastVisibles = [];

		var min:Int = Math.round(Math.max(0, Math.min(songs.length, lerpSelected - _drawDistance)));
		var max:Int = Math.round(Math.max(0, Math.min(songs.length, lerpSelected + _drawDistance)));
		for (i in min...max)
		{
			var item:Alphabet = grpSongs.members[i];
			item.visible = item.active = true;
			item.x = ((item.targetY - lerpSelected) * item.distancePerItem.x) + item.startPosition.x;
			item.y = ((item.targetY - lerpSelected) * 1.3 * item.distancePerItem.y) + item.startPosition.y;

			var icon:HealthIcon = iconArray[i];
			icon.visible = icon.active = true;
			_lastVisibles.push(i);
		}
	}

	override function destroy():Void
	{
		super.destroy();

		FlxG.autoPause = ClientPrefs.data.autoPause;
		if (!FlxG.sound.music.playing && !stopMusicPlay)
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";
	public var lastDifficulty:String = null;

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Mods.currentModDirectory;
		if (this.folder == null)
			this.folder = '';
	}
}
