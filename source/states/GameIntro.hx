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

class GameIntro extends FlxState
{
    var video:PsychVideo;

	override function create()
	{
        Functions.wait(1, ()->{ // Add a short delay
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
        if (video.bitmap != null)
            video.destroy();
		FlxG.switchState(new TitleState());
    }

	override function update(elapsed)
	{
        #if debug
		    if (FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER){
                exitState();
		    }
        #end
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
			FlxG.log.warn('Couldnt find video file: ' + name);
			return;
		}else{
            video = new PsychVideo(0, 0, true, true, filepath);
            video.bitmap.onEndReached.add(() -> {
                exitState();
            });
            add(video);
        }
		#else
		FlxG.log.warn('Platform not supported!');
		#end
	}
}
