package objects;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import states.PlayState;
import objects.StrumNote;
import backend.Vector3;

class NoteHoldCover extends FlxTypedSpriteGroup<FlxSprite>
{
    public var red:FlxSprite;
    public var blue:FlxSprite;
    public var purple:FlxSprite;
    public var green:FlxSprite;

    public var instance:PlayState;
    public function new(instance:PlayState) {
        super();

        red = new FlxSprite(0, 0);
        red.frames = Paths.getSparrowAtlas('noteSplashes/holdCoverRed');
        red.animation.addByPrefix('red', 'holdCoverRed', 24, false, false, false);
        red.visible = false;
        add(red);

        blue = new FlxSprite(0, 0);
        blue.frames = Paths.getSparrowAtlas('noteSplashes/holdCoverBlue');
        blue.animation.addByPrefix('blue', 'holdCoverBlue', 24, false, false, false);
        blue.visible = false;
        add(blue);

        purple = new FlxSprite(0, 0);
        purple.frames = Paths.getSparrowAtlas('noteSplashes/holdCoverPurple');
        purple.animation.addByPrefix('purple', 'holdCoverPurple', 24, false, false, false);
        purple.visible = false;
        add(purple);

        green = new FlxSprite(0, 0);
        green.frames = Paths.getSparrowAtlas('noteSplashes/holdCoverGreen');
        green.animation.addByPrefix('green', 'holdCoverGreen', 24, false, false, false);
        green.visible = false;
        add(green);



        this.instance = instance;
        var StrumPosData:Array<Vector3> = [];

        instance.playerStrums.forEachAlive((strum:StrumNote) -> {
            StrumPosData.push(new Vector3(strum.x, strum.y, strum.ID, null));
        });
    }

    public function DirToCol(Direction:Int):String {
        return Direction == 0 ? 'Purple' : Direction == 1 ? 'Blue' : Direction == 2 ? 'Green' : Direction == 3 ? 'Red' : 'null';
    }

    public function onNoteHit(note:Note) {
        
    }
}
