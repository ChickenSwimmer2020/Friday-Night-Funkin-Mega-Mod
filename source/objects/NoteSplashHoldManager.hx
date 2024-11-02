package objects;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
class NoteSplashHoldManager extends FlxTypedSpriteGroup<FlxSprite>
{
    public var holdSprites:Map<String, FlxSprite> = new Map();

    /**
     * This initializes your NoteSplashHoldManager.
     * @param strumGroup The group of strums for this manager to manage.
     */
    public function initialize(strumGroup:FlxTypedGroup<StrumNote>){

        strumGroup.forEachAlive((s:StrumNote) -> {
            // This is useless

            // Color of the current direction
            var color = dirToStr(@:privateAccess s.noteData);

            // The sprite for the hold note animation
            var width = 160 * 0.7;
            var holdSprite:FlxSprite = new FlxSprite(s.x - width * 0.95, s.y - width + 15);
		    holdSprite.frames = Paths.getSparrowAtlas('noteHoldCovers/holdCover$color'); //should work on adding the full anim set
		    holdSprite.animation.addByIndices('hold', 'holdCover$color', [1,2,3], "", 24, false, false, false);
            holdSprite.animation.addByIndices('splash', 'holdCover$color', [4,5,6,7,8,9,10,11,12], "", 24, false, false, false);
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
        if(!note.noteSplashData.disabled && note.isSustainNote){
		    var hitSprite:FlxSprite = dirToSpr(note.noteData);
			hitSprite.visible = true;

		    if (note.isSustainNote)
		    	hitSprite.animation.play('hold');
            else
                hitSprite.visible = false;

		    hitSprite.animation.finishCallback = (_) -> {

                if(hitSprite.animation.curAnim.name == 'hold')
                    hitSprite.animation.play('splash', true);
                else
                    hitSprite.visible = false;
            };
        }
	}
}
