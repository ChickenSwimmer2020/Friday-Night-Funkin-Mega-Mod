package states;

import openfl.media.Video;
import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxTimer;
import openfl.utils.Assets as OpenFlAssets;

    //#if VIDEOS_ALLOWED
    //import hxcodec.flixel.FlxVideo as VideoHandler;
    //#end
//
    //#if sys
    //    import sys.FileSystem;
    //    import sys.io.File;
    //#end
using StringTools;
//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!
//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!
//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!
//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!
//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!
//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!
//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!
//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!
//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!//TODO: FIX THIS!!!!
class GameIntro extends FlxState
{  
    //public var video:VideoHandler;
    override function create()
    {

            new FlxTimer().start(1, function(guh:FlxTimer) // gives a bit delay
            {
                    startVideo('megamodintrovideo'); //put the video name here make sure the video on videos folder. you dont need to add like blabla.mp4 just blabla
            });
            #if desktop
                // Updating Discord Rich Presence
                DiscordClient.changePresence("Intro Video", "watching");
            #end
    }
    function startVideo(name:String)
    {
                #if VIDEOS_ALLOWED
                    var filepath:String = Paths.video(name);
                        #if sys
                        if(!FileSystem.exists(filepath))
                        #else
                    if(!OpenFlAssets.exists(filepath))
                #end
                {
                    FlxG.log.warn('Couldnt find video file: ' + name);
                    return;
                }
                //video = new VideoHandler();
                //video.play(filepath);
                //FlxG.watch.addQuick('video pos: ', video.position);
                #else
                    FlxG.log.warn('Platform not supported!');
                    return;
                #end
    }
    override public function update(elapsed:Float) {
        //if(!video.isPlaying)
        //    {
        //        video.dispose();
        //        FlxG.switchState(new TitleState()); //this will make after the video done it will switch to the intro text/ title state
        //            #if desktop
        //                // Updating Discord Rich Presence
        //                DiscordClient.changePresence("Intro Video", "Going to the Title Screen");
        //            #end
        //        return;
        //    }
    }
}