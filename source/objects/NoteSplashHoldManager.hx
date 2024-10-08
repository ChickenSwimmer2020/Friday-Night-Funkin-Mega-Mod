package objects;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import states.PlayState;
import lime.math.Vector2;

typedef StrumPositionData =
{
	redPos:Vector2,
	bluePos:Vector2,
	greenPos:Vector2,
	purplePos:Vector2,
}

class NoteSplashHoldManager extends FlxTypedSpriteGroup<FlxSprite>
{
	public var StrumPosDat:StrumPositionData;
	public var red:FlxSprite;
	public var blue:FlxSprite;
	public var purple:FlxSprite;
	public var green:FlxSprite;

	public var instance:PlayState;

	public function new(instance:PlayState)
	{
		super();

		this.instance = instance;
		
		if(instance.playerStrums != null) {
			instance.playerStrums.forEachAlive((strum:StrumNote) ->
			{
				@:privateAccess
				switch (strum.noteData)
				{
					case 0:
						StrumPosDat.purplePos = new Vector2(strum.x, strum.y);
					case 1:
						StrumPosDat.bluePos = new Vector2(strum.x, strum.y);
					case 2:
						StrumPosDat.greenPos = new Vector2(strum.x, strum.y);
					case 3:
						StrumPosDat.redPos = new Vector2(strum.x, strum.y);
				}
			});
		}

		red = new FlxSprite(StrumPosDat.redPos.x, StrumPosDat.redPos.y);
		red.frames = Paths.getSparrowAtlas('noteSplashes/holdCoverRed');
		red.animation.addByPrefix('hold', 'holdCoverRed', 24, false, false, false);
		red.visible = false;
		add(red);

		blue = new FlxSprite(StrumPosDat.bluePos.x, StrumPosDat.bluePos.y);
		blue.frames = Paths.getSparrowAtlas('noteSplashes/holdCoverBlue');
		blue.animation.addByPrefix('hold', 'holdCoverBlue', 24, false, false, false);
		blue.visible = false;
		add(blue);

		purple = new FlxSprite(StrumPosDat.purplePos.x, StrumPosDat.purplePos.y);
		purple.frames = Paths.getSparrowAtlas('noteSplashes/holdCoverPurple');
		purple.animation.addByPrefix('hold', 'holdCoverPurple', 24, false, false, false);
		purple.visible = false;
		add(purple);

		green = new FlxSprite(StrumPosDat.greenPos.x, StrumPosDat.greenPos.y);
		green.frames = Paths.getSparrowAtlas('noteSplashes/holdCoverGreen');
		green.animation.addByPrefix('hold', 'holdCoverGreen', 24, false, false, false);
		green.visible = false;
		add(green);
	}

	public function DirToSpr(Direction:Int):FlxSprite
	{
		return Direction == 0 ? purple : Direction == 1 ? blue : Direction == 2 ? green : Direction == 3 ? red : null;
	}

	public function onNoteHit(note:Note)
	{
		var hitSprite:FlxSprite = DirToSpr(note.noteData);
		if(!note.noteSplashData.disabled)
			hitSprite.visible = true;
		if (note.isSustainNote)
		{
			hitSprite.animation.play('hold');
		}
		hitSprite.animation.finishCallback = function(wha)
		{
			hitSprite.visible = false;
		}
	}
}
