package objects;

import backend.util.Vector3;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import states.PlayState;

class NoteSplashHoldManager extends FlxTypedSpriteGroup<FlxSprite>
{
    //public var strumData:Map<String, Vector3>;
    public var holdSprites:Map<String, FlxSprite>;

	public function new()
	{
		super();
		//strumData = new Map<String, Vector3>();
        holdSprites = new Map<String, FlxSprite>();
	}

    /**
     * This initializes your NoteSplashHoldManager.
     * @param strumGroup The group of strums for this manager to manage.
     */
    public function initialize(strumGroup:FlxTypedGroup<StrumNote>){
        
        strumGroup.forEachAlive((s:StrumNote) -> {
            // This is useless
            //strumData.set(dirToStr(s.noteData), new Vector3(s.x, s.y, s.noteData));

            // Color of the current direction
            var color = dirToStr(s.noteData);

            // The sprite for the hold note animation
            var holdSprite:FlxSprite = new FlxSprite(s.x, s.y);
		    holdSprite.frames = Paths.getSparrowAtlas('noteSplashes/holdCover$color');
		    holdSprite.animation.addByPrefix('hold', 'holdCover$color', 24, false, false, false);
		    holdSprite.visible = false;
		    add(holdSprite);

            // Sets the hold sprite to its respective colorName
            holdSprites.set(color, holdSprite);
        });
    }

	public function dirToSpr(Direction:Int):FlxSprite
		return holdSprites.get(dirToStr(Direction));
    public function dirToStr(Direction:Int):String
		return Direction == 0 ? 'Purple' : Direction == 1 ? 'Blue' : Direction == 2 ? 'Green' : Direction == 3 ? 'Red' : null;

	public function onNoteHit(note:Note)
	{
        if(!note.noteSplashData.disabled){
		    var hitSprite:FlxSprite = dirToSpr(note.noteData);
			hitSprite.visible = true;
		    if (note.isSustainNote)
		    	hitSprite.animation.play('hold');
		    hitSprite.animation.finishCallback = (_) -> hitSprite.visible = false;
        }
	}
}
