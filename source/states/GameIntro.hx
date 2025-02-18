package states;

import flixel.FlxState;
import flixel.FlxG;
#if VIDEOS_ALLOWED
import cutscenes.PsychVideo;
#end
#if sys
import sys.FileSystem;
#end

using StringTools;

// DON'T USE WINDOWS API IN GAMEINTRO!!! THE GAME WILL NOT COMPILE!!
class GameIntro extends FlxState
{
    #if VIDEOS_ALLOWED
	var video:PsychVideo;
    #end

	override function create()
	{
		Functions.wait(1, () ->
		{ // Add a short delay
			startVideo('megamodintrovideo'); // Don't add .mp4 to the file name!!!!
		});
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Intro Video", "watching");
		#end
		FlxG.mouse.visible = false;
	}

	public function exitState()
	{
        #if VIDEOS_ALLOWED
		if (video.bitmap != null)
			video.destroy();
        #end
		FlxG.switchState(new TitleState());
	}

	override function update(elapsed)
	{
		if (FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER)
		{
			exitState();
		}
	}

	function startVideo(name:String)
	{
		#if VIDEOS_ALLOWED
		var filepath:String = Paths.video(name);
		#if sys
		if (!FileSystem.exists(filepath))
		#else
		if (!OpenFlAssets.exists(filepath))
		#end
		{
			trace('Couldnt find video file: ' + name);
			return;
		}
		else
		{
			video = new PsychVideo(0, 0, true, true, filepath);
			video.bitmap.onEndReached.add(() ->
			{
				exitState();
			});
			add(video);
		}
		#else
		trace('Platform not supported for videos!!');
		#end
	}
}
