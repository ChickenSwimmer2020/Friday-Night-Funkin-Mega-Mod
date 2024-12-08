package states;

class Warnings extends MusicBeatState
{
	public var _FURRYWARNING:FlxTypedGroup<FlxSprite>;
    	public var FW_crytext:Alphabet;
    	public var FW_headsup:Alphabet;
    	public var FW_madeby:Alphabet;
    	public var FW_bulletpoint1:Alphabet;
    	public var FW_bulletpoint2:Alphabet;
    	public var FW_bulletpoint3:Alphabet;
    	public var FW_bulletpoint4:Alphabet;
    	public var FW_item1:Alphabet;
    	public var FW_item2:Alphabet;
    	public var FW_item3:Alphabet;
    	public var FW_item3_2:Alphabet;
    	public var FW_item4:Alphabet;

	override public function create()
	{
		AlphaCharacter.loadAlphabetData();
		_FURRYWARNING = new FlxTypedGroup<FlxSprite>();
		// add the furry warning graphchis
		var FBG:FlxSprite = new FlxSprite(-150, -20);
		FBG.frames = Paths.getSparrowAtlas('Warnings/FURRY_SEPERATOR');
		FBG.animation.addByPrefix('Idle', 'SEPERATOR_furry', 24, true, false, false);
		FBG.animation.play('Idle');
		FW_crytext = new Alphabet(-50, 20, '           |   \nto continue\n           /   \nto cry about it',
			true); // we can handle the side text through the alphabet now, possibly.
		FW_headsup = new Alphabet(70, 350, 'head\'s up!', true);
		FW_madeby = new Alphabet(0, 410, 'this mod was made\nby a furry!\nexpect to see', true);
		FW_bulletpoint1 = new Alphabet(0, 550, '•', true);
		FW_bulletpoint2 = new Alphabet(0, 590, '•', true);
		FW_bulletpoint3 = new Alphabet(0, 630, '•', true);
		FW_bulletpoint4 = new Alphabet(0, 670, '•', true);
		FW_item1 = new Alphabet(30, 530, 'furry jokes', false);
		FW_item2 = new Alphabet(30, 570, 'anthro animals', false);
		FW_item3 = new Alphabet(30, 610, 'sex jokes,', false);
		FW_item3_2 = new Alphabet(190, 645, 'a lot of them...', false);
		FW_item4 = new Alphabet(30, 650, 'other furry stuff', false);
		fixFurryTextScaling();
		_FURRYWARNING.add(FBG);
		_FURRYWARNING.add(FW_crytext);
		_FURRYWARNING.add(FW_headsup);
		_FURRYWARNING.add(FW_madeby);
		_FURRYWARNING.add(FW_bulletpoint1);
		_FURRYWARNING.add(FW_bulletpoint2);
		_FURRYWARNING.add(FW_bulletpoint3);
		_FURRYWARNING.add(FW_bulletpoint4);
		_FURRYWARNING.add(FW_item1);
		_FURRYWARNING.add(FW_item2);
		_FURRYWARNING.add(FW_item3);
		_FURRYWARNING.add(FW_item4);
		_FURRYWARNING.add(FW_item3_2);

		add(_FURRYWARNING);
	}

    override public function update(elapsed:Float) {
        super.update(elapsed);
    }

	public function fixFurryTextScaling():Void
	{
		FW_crytext.setScale(0.75, 0.75); // upper text
		FW_headsup.setScale(0.8, 0.8); // heads up text
		FW_madeby.setScale(0.6, 0.6); // mod was made by a furry
		FW_bulletpoint1.setScale(0.75, 0.75); // bullet point 1
		FW_bulletpoint2.setScale(0.75, 0.75); // bullet point 2
		FW_bulletpoint3.setScale(0.75, 0.75); // bullet point 3
		FW_bulletpoint4.setScale(0.75, 0.75); // bullet point 4
		FW_item1.setScale(0.5, 0.5); // the text
		FW_item2.setScale(0.5, 0.5); // the text
		FW_item3.setScale(0.5, 0.5); // the text
		FW_item3_2.setScale(0.2, 0.2); // the other text
		FW_item4.setScale(0.5, 0.5); // the text
	}

	public function TweenWarningOut(WarningToTween:String):Void
	{
	}

	public function TweenWarningIn(WarningToTween:String):Void
	{
	}
}
