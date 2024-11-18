package substates;


import backend.Functions;
import objects.Character;
import flixel.FlxObject;
import flixel.math.FlxPoint;

import states.StoryMenuState;
import states.FreeplayState;

//needed for death difficulty thingy
enum abstract DeathDifficulty(String) from String to String
{
	var Easy = "DIFF_EASY";
	var Normal = "DIFF_NORM";
	var Hard = "DIFF_HARD";
	var Nightmare = "DIFF_NIGHT";
	//var Erect = "DIFF_ERECT"; //TODO: implement difficulty.

	public inline function new(value:String) 
	{
		this = value;
	}

	public static function fromString(value:String):Null<DeathDifficulty>
	{
		switch(value)
		{
			case "Easy":
				return Easy;
			case "Meduium":
				return Normal;
			case "Hard":
				return Hard;
			case "Nightmare":
				return Nightmare;
			//case: "Erect"		//line 17 col 35
			//	return Erect;
			default:
				return null;
		}
	}
}

class GameOverSubstate extends MusicBeatSubstate
{
	//thedeathshtuff
	public var PulseBG:FlxSprite;
	public var ComboNumbs:Dynamic; //TODO: create custom object for this like the milestone did.
	public var RatingNums:Dynamic;
	public var Ratings:FlxSprite;
	public var SongDef:FlxText;
	public var Diff:FlxSprite;
	public var TextBG:FlxSprite;

	public var slideTween:FlxTween;


	//everything else
	public var boyfriend:Character;
	var camFollow:FlxObject;

	var stagePostfix:String = "";

	public static var characterName:String = 'bf-dead';
	public static var deathSoundName:String = 'fnf_loss_sfx';
	public static var loopSoundName:String = 'gameOver';
	public static var endSoundName:String = 'gameOverEnd';
	public static var deathDelay:Float = 0;

	public static var instance:GameOverSubstate;
	public function new(?playStateBoyfriend:Character = null)
	{
		if(playStateBoyfriend != null && playStateBoyfriend.curCharacter == characterName) //Avoids spawning a second boyfriend cuz animate atlas is laggy
		{
			this.boyfriend = playStateBoyfriend;
		}
		super();
	}

	public static function resetVariables() {
		characterName = 'bf-dead';
		deathSoundName = 'fnf_loss_sfx';
		loopSoundName = 'gameOver';
		endSoundName = 'gameOverEnd';
		deathDelay = 0;

		var _song = PlayState.SONG;
		if(_song != null)
		{
			if(_song.gameOverChar != null && _song.gameOverChar.trim().length > 0) characterName = _song.gameOverChar;
			if(_song.gameOverSound != null && _song.gameOverSound.trim().length > 0) deathSoundName = _song.gameOverSound;
			if(_song.gameOverLoop != null && _song.gameOverLoop.trim().length > 0) loopSoundName = _song.gameOverLoop;
			if(_song.gameOverEnd != null && _song.gameOverEnd.trim().length > 0) endSoundName = _song.gameOverEnd;
		}
	}

	var charX:Float = 0;
	var charY:Float = 0;

	override function create()
	{
		instance = this;

		Conductor.songPosition = 0;

		//thecoolstuff
		PulseBG = new FlxSprite(-1000, -200);
		PulseBG.frames = Paths.getSparrowAtlas('PulgeBS');
		PulseBG.animation.addByPrefix('bgp_fd', 'FirstDeath', 24, false, false, false);
		PulseBG.animation.addByPrefix('bgp_l', 'Loop', 24, false, false, false);
		PulseBG.animation.addByPrefix('bgp_restrt', 'Conf', 24, false, false, false);
		PulseBG.antialiasing = ClientPrefs.data.antialiasing;

		TextBG = new FlxSprite(500, -1000).loadGraphic(Paths.image('DeathScreen_Wrapper'));
		TextBG.antialiasing = ClientPrefs.data.antialiasing;
		TextBG.scale.set(0.3,0.3);


		Ratings = new FlxSprite(100, -580);
		Ratings.frames = Paths.getSparrowAtlas('DeathScreen_RATINGS');
		Ratings.animation.addByPrefix('Ratings', 'Categories', 24, false);
		Ratings.antialiasing = ClientPrefs.data.antialiasing;
		Ratings.scale.set(0.2, 0.2);
		Ratings.visible = false;

		Diff = new FlxSprite(170, 250);
		Diff.frames = Paths.getSparrowAtlas('DeathScreen_DIFFICULTIES');
		Diff.scale.set(0.25, 0.25);
		Diff.animation.addByIndices('DIFF_EASY', 'Difficulties', [0,1], "", 24, true, false, false);
		Diff.animation.addByIndices('DIFF_NORM', 'Difficulties', [2,3], "", 24, true, false, false);
		Diff.animation.addByIndices('DIFF_HARD', 'Difficulties', [4,5], "", 24, true, false, false);
		Diff.animation.addByIndices('DIFF_NIGHT', 'Difficulties', [6,7], "", 24, true, false, false);
		//Diff.animation.addByIndices('DIFF_ERECT', 'Difficulties', [8,9], "", 24, true, false, false);
		Diff.alpha = 0;

		var CurDiff:DeathDifficulty = DeathDifficulty.fromString(PlayState.DeathDiffState);
		Diff.animation.play(CurDiff, true, false, 0);
		if(CurDiff == Nightmare)
			Diff.scale.set(0.15,0.15);

		SongDef = new FlxText(600, -100, 0, "-ERROR-", 8, true);
		SongDef.setFormat('Friday Night Funkin Regular', 48, FlxColor.BLACK, CENTER, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
		SongDef.antialiasing = ClientPrefs.data.antialiasing;
		SongDef.alpha = 0;
		SongDef.text = PlayState.DeathSongState;


		add(PulseBG);
		add(TextBG);
		add(Ratings);
		add(Diff);
		add(SongDef);

		//therest
		if(boyfriend == null)
		{
			boyfriend = new Character(0, 0, characterName, true);
		}
		boyfriend.skipDance = true;
		add(boyfriend);

		FlxG.sound.play(Paths.sound(deathSoundName));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		boyfriend.playAnim('firstDeath');

		PulseBG.animation.play('bgp_fd', true, false, 0);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(boyfriend.getGraphicMidpoint().x + boyfriend.cameraPosition[0], boyfriend.getGraphicMidpoint().y + boyfriend.cameraPosition[1]);
		FlxG.camera.focusOn(new FlxPoint(FlxG.camera.scroll.x + (FlxG.camera.width / 2), FlxG.camera.scroll.y + (FlxG.camera.height / 2)));
		FlxG.camera.follow(camFollow, LOCKON, 9999999);
		add(camFollow);
		
		PlayState.instance.setOnScripts('inGameOver', true);
		PlayState.instance.callOnScripts('onGameOverStart', []);
		FlxG.sound.music.loadEmbedded(Paths.music(loopSoundName), true);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		PlayState.instance.callOnScripts('onUpdate', [elapsed]);

		var justPlayedLoop:Bool = false;
		if (!boyfriend.isAnimationNull() && boyfriend.getAnimationName() == 'firstDeath' && boyfriend.isAnimationFinished())
		{
			TextBGSlideIn(1);
			boyfriend.playAnim('deathLoop');
			PulseBG.animation.play('bgp_l', true, true, 0);
			justPlayedLoop = true;
		}

		if(!isEnding)
		{
			if (controls.ACCEPT)
			{
				endBullshit();
				PulseBG.animation.play('bgp_restrt', true, false, 0);
				RatingsDissappear(1);
			}
			else if (controls.BACK)
			{
				#if DISCORD_ALLOWED DiscordClient.resetClientID(); #end
				FlxG.camera.visible = false;
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
			else if (justPlayedLoop)
			{
				switch(PlayState.SONG.stage)
				{
					case 'tank':
						coolStartDeath(0.2);
						
						var exclude:Array<Int> = [];
						//if(!ClientPrefs.cursing) exclude = [1, 3, 8, 13, 17, 21];
	
						FlxG.sound.play(Paths.sound('jeffGameover/jeffGameover-' + FlxG.random.int(1, 25, exclude)), 1, false, null, true, function() {
							if(!isEnding)
							{
								FlxG.sound.music.fadeIn(0.2, 1, 4);
							}
						});

					default:
						coolStartDeath();
				}
			}
			
			if (FlxG.sound.music.playing)
			{
				Conductor.songPosition = FlxG.sound.music.time;
			}
		}
		PlayState.instance.callOnScripts('onUpdatePost', [elapsed]);
	}

	var isEnding:Bool = false;
	function coolStartDeath(?volume:Float = 1):Void
	{
		FlxG.sound.music.play(true);
		FlxG.sound.music.volume = volume;
	}

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			if(boyfriend.hasAnimation('deathConfirm'))
				boyfriend.playAnim('deathConfirm', true);
			else if(boyfriend.hasAnimation('deathLoop'))
				boyfriend.playAnim('deathLoop', true);

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

	//the cool death stuff, lets make it work again!
	public inline function TextBGSlideIn(Speed:Float):Void
	{
		FlxTween.tween(TextBG, {x: 0}, Speed, {
			onComplete: function(twn:FlxTween)
			{
				RatingsAppear(0.5);
				Ratings.visible = true;	
			},
			ease: FlxEase.circInOut
		});
	}

	public inline function TextBGSlideAway(Speed:Float):Void
	{
		FlxTween.tween(TextBG, {x:500}, Speed, {
			onComplete: function(twn:FlxTween)
			{
				#if DEBUG
					trace('Tween Completed: ' + 'TextBGSlideAway');
				#end
			},
			ease: FlxEase.circIn
		});
	}

	public inline function RatingsAppear(Speed:Float):Void
	{
			//Name
				FlxTween.tween(SongDef, {alpha: 1}, Speed, { ease: FlxEase.linear });
			//Difficulty
				FlxTween.tween(Diff, {alpha: 1}, Speed, { ease: FlxEase.linear });
			//Ratings
				Ratings.animation.play('Ratings');
	}

	public inline function RatingsDissappear(Speed:Float):Void
	{
		//var Wait = new FlxTimer() funnily enough, we dont need this anymore, we have Functions.wait now!
		//TextBG
			Functions.wait(1, () -> {	TextBGSlideAway(0.5);	});
		//SongName
			FlxTween.tween(SongDef, {alpha: 0}, Speed, { ease: FlxEase.linear });
		//SongDiff
			FlxTween.tween(Diff, {alpha: 0}, Speed, { ease: FlxEase.linear });
		//ratings
			Ratings.animation.play('Ratings', false, true, 15);
			Ratings.animation.finishCallback = function(what)
			{
				Ratings.visible = false;
			}
	}
}
