package states;

class CarrierState extends MusicBeatState
{
    var funkay:FlxSprite;

    override public function create()
    {
        funkay = new FlxSprite(0, 0).loadGraphic(Paths.image('funkay'));
        funkay.antialiasing = ClientPrefs.data.antialiasing;
        add(funkay);
    }
    override public function update(elapsed:Float)
    {
		funkay.setGraphicSize(Std.int(0.88 * FlxG.width + 0.9 * (funkay.width - 0.88 * FlxG.width)));
        funkay.setPosition(funkay.x + 60);
		funkay.updateHitbox();
        if(controls.ACCEPT)
        {
			funkay.setPosition(funkay.x - 60);
			funkay.setGraphicSize(Std.int(funkay.width + 60));
			funkay.updateHitbox();
        }
    }
}
