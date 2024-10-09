package substates;

import backend.Section.SwagSection;
import backend.Song;
import backend.WeekData;
import objects.Character;
import flixel.FlxObject;
import flixel.tweens.FlxTween;
import flixel.FlxSubState;
import states.StoryMenuState;
import states.FreeplayState;

// TODO: implement properly
enum abstract DeathDifficulty(String) from String to String
{
	var Easy = "DIFF_EASY";
	var Normal = "DIFF_NORM";
	var Hard = "DIFF_HARD";
	var Nightmare = "DIFF_NIGHT"; // Maps "Nightmare" to "DIFF_NIGHT"

	public inline function new(value:String)
	{
		this = value;
	}

	// A static method to map a string to an enum value
	public static function fromString(value:String):Null<DeathDifficulty>
	{
		switch (value)
		{
			case "Easy":
				return Easy;
			case "Medium":
				return Normal;
			case "Hard":
				return Hard;
			case "Nightmare":
				return Nightmare;
			default:
				return null;
		}
	}
}

class GameOverSubstate extends MusicBeatSubstate
{
	public var boyfriend:Character;

	var camFollow:FlxObject;
	var moveCamera:Bool = false;
	var playingDeathSound:Bool = false;

	var CoolPulseBG:FlxSprite;
	var ComboNum:FlxSprite;
	var RatingNum:FlxSprite;
	// var SongTXT:Alphabet;
	var SongDef:FlxText;
	var Diff:FlxSprite;
	var Ratings:FlxSprite;
	var Wrapper:FlxSprite;

	public var slideTween:FlxTween;

	var stageSuffix:String = "";

	public static var characterName:String = 'bf-dead';
	public static var deathSoundName:String = 'fnf_loss_sfx';
	public static var loopSoundName:String = 'gameOver';
	public static var endSoundName:String = 'gameOverEnd';

	public var animPlayed:Bool = false;

	public static var instance:GameOverSubstate;

	public static function resetVariables()
	{
		characterName = 'bf-dead';
		deathSoundName = 'fnf_loss_sfx';
		loopSoundName = 'gameOver';
		endSoundName = 'gameOverEnd';

		var _song = PlayState.SONG;
		if (_song != null)
		{
			if (_song.gameOverChar != null && _song.gameOverChar.trim().length > 0)
				characterName = _song.gameOverChar;
			if (_song.gameOverSound != null && _song.gameOverSound.trim().length > 0)
				deathSoundName = _song.gameOverSound;
			if (_song.gameOverLoop != null && _song.gameOverLoop.trim().length > 0)
				loopSoundName = _song.gameOverLoop;
			if (_song.gameOverEnd != null && _song.gameOverEnd.trim().length > 0)
				endSoundName = _song.gameOverEnd;
		}
	}

	var charX:Float = 0;
	var charY:Float = 0;

	override function create()
	{
		instance = this;

		Conductor.songPosition = 0;

		CoolPulseBG = new FlxSprite();
		CoolPulseBG.frames = Paths.getSparrowAtlas('PulgeBS');
		CoolPulseBG.animation.addByPrefix('bgpfd', 'FirstDeath', 24, false, false, false);
		CoolPulseBG.animation.addByPrefix('bgpl', 'Loop', 24, true, false, false);
		CoolPulseBG.animation.addByPrefix('bgprstrt', 'Conf', 24, false, false, false);
		// reminder to get real positioning so that it doenst look weird on other weeks
		// im stupid, 0, 0 looks coolest :/
		// never mind, redid death completely, needs custom position.
		CoolPulseBG.x = -1000;
		CoolPulseBG.y = -200;
		add(CoolPulseBG);

		// for the death rating system
		Wrapper = new FlxSprite(0, 0).loadGraphic(Paths.image('DeathScreen_Wrapper'));
		Wrapper.x = 500;
		Wrapper.y = -1000;
		Wrapper.antialiasing = ClientPrefs.data.antialiasing;
		Wrapper.scale.set(0.30, 0.30);
		add(Wrapper);

		Ratings = new FlxSprite(0, 0);
		Ratings.frames = Paths.getSparrowAtlas('DeathScreen_RATINGS');
		Ratings.animation.addByPrefix('Ratings', 'Categories', 24, false);
		Ratings.x = 100;
		Ratings.y = -580;
		Ratings.antialiasing = ClientPrefs.data.antialiasing;
		Ratings.scale.set(0.2, 0.2);
		Ratings.visible = false;
		add(Ratings);

		// scaling is fucked up, swapped to FlxText
		// SongTXT = new Alphabet(0, 0, "-null-", true);
		// SongTXT.antialiasing = ClientPrefs.data.antialiasing;
		// SongTXT.scale.set(0.25, 0.25);
		// SongTXT.distancePerItem = new FlxPoint(10,120);
		// SongTXT.x = 700;
		// SongTXT.y = 0;
		// SongTXT.alpha = 0;
		// SongTXT.alignment = CENTERED;
		// SongTXT.text = PlayState.DeathSongState;
		// add(SongTXT);

		Diff = new FlxSprite(0, 0);
		Diff.frames = Paths.getSparrowAtlas('DeathScreen_DIFFICULTIES');
		Diff.x = 170;
		Diff.y = 250;
		Diff.scale.set(0.25, 0.25);
		Diff.animation.addByIndices('DIFF_EASY', 'Difficulties', [0, 1], "", 24, true, false, false);
		Diff.animation.addByIndices('DIFF_NORM', 'Difficulties', [2, 3], "", 24, true, false, false);
		Diff.animation.addByIndices('DIFF_HARD', 'Difficulties', [4, 5], "", 24, true, false, false);
		Diff.animation.addByIndices('DIFF_NIGHT', 'Difficulties', [6, 7], "", 24, true, false, false);
		Diff.alpha = 0;
		// trace(PlayState.DeathDiffState);
		add(Diff);

		var diff:DeathDifficulty = DeathDifficulty.fromString(PlayState.DeathDiffState);
		Diff.animation.play(diff, true, false, 0);
		if (diff == Nightmare)
			Diff.scale.set(0.15, 0.15);

		SongDef = new FlxText(0, 0, 0, "-DEBUG-", 8, true);
		SongDef.setFormat('Friday Night Funkin Regular', 48, FlxColor.BLACK, CENTER, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
		SongDef.antialiasing = ClientPrefs.data.antialiasing;
		SongDef.alpha = 0;
		SongDef.x = 600;
		SongDef.y = -100;
		SongDef.text = PlayState.DeathSongState;
		add(SongDef);

		boyfriend = new Character(0, 0, characterName, true);
		add(boyfriend);

		FlxG.sound.play(Paths.sound(deathSoundName));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		boyfriend.playAnim('firstDeath');

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(boyfriend.getGraphicMidpoint().x, boyfriend.getGraphicMidpoint().y);
		add(camFollow);

		PlayState.instance.setOnScripts('inGameOver', true);
		PlayState.instance.callOnScripts('onGameOverStart', []);

		super.create();
	}

	function ratingsdissappear(Speed:Float)
	{
		var Wait = new FlxTimer();
		Wait.start(1, function(Wat:FlxTimer)
		{
			SlideBack(0.5);
		}, 1);
		// song name
		FlxTween.tween(SongDef, {alpha: 0}, Speed, {
			onComplete: function(twn:FlxTween)
			{
				trace('Song Text Is Invisible');
			},
			ease: FlxEase.linear
		});
		// difficulty
		FlxTween.tween(Diff, {alpha: 0}, Speed, {
			onComplete: function(twn:FlxTween)
			{
				trace('Difficulty Is Invisible');
			},
			ease: FlxEase.linear
		});
		// ratings
		Ratings.animation.play('Ratings', false, true, 15);
		Ratings.animation.finishCallback = function(what)
		{
			Ratings.visible = false;
		}
	}

	function SlideBack(Speed:Float)
	{
		FlxTween.tween(Wrapper, {x: 500}, Speed, {
			onComplete: function(twn:FlxTween)
			{
				// trace('tween finished')
			},
			ease: FlxEase.circIn
		});
	}

	function WrapSlide(Speed:Float)
	{
		FlxTween.tween(Wrapper, {x: 0}, Speed, {
			onComplete: function(twn:FlxTween)
			{
				ratingsappear(0.5);
				Ratings.visible = true;
			},
			ease: FlxEase.circInOut
		});
	}

	function ratingsappear(Speed:Float)
	{
		// song name
		FlxTween.tween(SongDef, {alpha: 1}, Speed, {
			onComplete: function(twn:FlxTween)
			{
				trace('Song Text Is Visible');
			},
			ease: FlxEase.linear
		});
		// difficulty
		FlxTween.tween(Diff, {alpha: 1}, Speed, {
			onComplete: function(twn:FlxTween)
			{
				trace('Difficulty text is visible');
			},
			ease: FlxEase.linear
		});
		// ratings
		Ratings.animation.play('Ratings');
	}

	public var startedDeath:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		PlayState.instance.callOnScripts('onUpdate', [elapsed]);

		if (controls.ACCEPT)
		{
			endBullshit();
			ratingsdissappear(1);
		}

		if (controls.BACK)
		{
			#if DISCORD_ALLOWED DiscordClient.resetClientID(); #end
			FlxG.sound.music.stop();
			PlayState.deathCounter = 0;
			PlayState.seenCutscene = false;
			PlayState.chartingMode = false;

			Mods.loadTopMod();
			if (PlayState.isStoryMode)
				MusicBeatState.switchState(new StoryMenuState());
			else
				MusicBeatState.switchState(new FreeplayState());

			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			PlayState.instance.callOnScripts('onGameOverConfirm', [false]);
		}

		if (boyfriend.animation.curAnim != null)
		{
			if (boyfriend.animation.curAnim.name == 'firstDeath' && boyfriend.animation.curAnim.finished && startedDeath)
			{
				WrapSlide(1);
				boyfriend.playAnim('deathLoop');
				CoolPulseBG.animation.play('bgpl', true, false, 0);
			}
			if (boyfriend.animation.curAnim.name == 'firstDeath')
			{
				if (!animPlayed)
				{
					CoolPulseBG.animation.play('bgpfd', true, false, 0);
					animPlayed = true;
				}

				if (boyfriend.animation.curAnim.curFrame >= 0 && !moveCamera)
				{
					FlxG.camera.follow(camFollow, LOCKON, 9999);
					moveCamera = true;
				}

				if (boyfriend.animation.curAnim.finished && !playingDeathSound)
				{
					startedDeath = true;
					if (PlayState.SONG.stage == 'tank')
					{
						playingDeathSound = true;
						coolStartDeath(0.2);

						var exclude:Array<Int> = [];
						// if(!ClientPrefs.cursing) exclude = [1, 3, 8, 13, 17, 21];

						FlxG.sound.play(Paths.sound('jeffGameover/jeffGameover-' + FlxG.random.int(1, 25, exclude)), 1, false, null, true, function()
						{
							if (!isEnding)
							{
								FlxG.sound.music.fadeIn(0.2, 1, 4);
							}
						});
					}
					else
						coolStartDeath();
				}
			}
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
		PlayState.instance.callOnScripts('onUpdatePost', [elapsed]);
	}

	var isEnding:Bool = false;

	function coolStartDeath(?volume:Float = 1):Void
	{
		FlxG.sound.playMusic(Paths.music(loopSoundName), volume);
	}

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			boyfriend.playAnim('deathConfirm', true);
			CoolPulseBG.animation.play('bgprstrt', true, false, 0);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music(endSoundName));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					MusicBeatState.resetState();
				});
			});
			PlayState.instance.callOnScripts('onGameOverConfirm', [true]);
		}
	}

	override function destroy()
	{
		instance = null;
		super.destroy();
	}
}
