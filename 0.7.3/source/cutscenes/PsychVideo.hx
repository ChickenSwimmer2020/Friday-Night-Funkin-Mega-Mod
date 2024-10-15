#if VIDEOS_ALLOWED
package cutscenes;

import hxvlc.flixel.FlxVideoSprite;
import lime.math.Vector2;
import lime.app.Event;

class PsychVideo extends FlxVideoSprite {
    /**
     * Is the video loaded?
     */
    public var loaded:Bool = false;
    /**
     * An event that is fired when the load() function has finished.
     * (This assumes the function has finished loading after 1 frame.)
     */
    public var onLoaded(default, null):Event<Void->Void> = new Event<Void->Void>();
    /**
     * This event is fired when the load() function has failed.
     */
    public var onLoadError(default, null):Event<Void->Void> = new Event<Void->Void>();
	/**
	 * Play the video when it's finished loading?
	 */
	public var playOnLoaded:Bool = false;
    /**
     * Shrink the video to FlxG.width/height?
     */
    public var confineToBounds:Bool = false;
    override public function new(?x:Float = 0, ?y:Float = 0, ?playOnLoaded:Bool = false, ?confineToBounds:Bool = true, ?videoPath:String = '')
    {
        super(x, y);
        antialiasing = true;
        this.confineToBounds = confineToBounds;
        this.playOnLoaded = playOnLoaded;
        bitmap.onFormatSetup.add(() -> {
            if (bitmap != null && bitmap.bitmapData != null)
            {
                var scaleVector:Vector2 = new Vector2(0, 0);
                var scale:Null<Float> = null;
                if (confineToBounds)
                    scaleVector.setTo(FlxG.width, FlxG.height);
                else
                    scale = Math.min(FlxG.width / bitmap.bitmapData.width, FlxG.height / bitmap.bitmapData.height) * 0.8;

                setGraphicSize(scale != null ? bitmap.bitmapData.width * scale : scaleVector.x, scale != null ? bitmap.bitmapData.height * scale : scaleVector.y);
                updateHitbox();
            }
        });
        bitmap.onEndReached.add(destroy);
        // If the video path is set, load it in.
        if (videoPath != '')
            load(videoPath);
        // If the video is meant to play when loaded, add the play function to the onLoaded event.
        if (playOnLoaded)
            onLoaded.add(_playVoid);
    }

    override public function load(location:hxvlc.util.Location, ?options:Null<Array<String>>):Bool {
        if (super.load(location, options)) 
        {
            // If successful, wait a frame for the video to finish loading.
            Functions.wait(0.001, ()->{
                loaded = true;
                onLoaded.dispatch();
            });
            return true;
        }
        // If it failed, dispatch the onLoadError event.
        onLoadError.dispatch();
        return false;
        
    }

    override public function destroy()
    {
        onLoaded.removeAll();
        onLoadError.removeAll();
        super.destroy();
    }

    override public function play():Bool
    {
        if (loaded)
            return super.play();
        return false;
    }

    // Private functions
    private function _playVoid()
    {
        play();
    }
}
#end