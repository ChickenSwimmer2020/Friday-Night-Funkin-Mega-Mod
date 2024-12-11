package states;

class Warnings extends MusicBeatState
{
	public var _FURRYWARNING:FlxSpriteGroup;
    	private var FW_crytext:Alphabet;
    	private var FW_headsup:Alphabet;
    	private var FW_madeby:Alphabet;
    	private var FW_bulletpoint1:Alphabet;
    	private var FW_bulletpoint2:Alphabet;
    	private var FW_bulletpoint3:Alphabet;
    	private var FW_bulletpoint4:Alphabet;
    	private var FW_item1:Alphabet;
    	private var FW_item2:Alphabet;
    	private var FW_item3:Alphabet;
    	private var FW_item3_2:Alphabet;
    	private var FW_item4:Alphabet;

    public var _FLASHWARNING:FlxSpriteGroup;
        private var FWarn_headsup:Alphabet;
        private var FWarn_fuckingparagraph:Alphabet;
        private var FWarn_keepordisable:Alphabet;




    public var curWarn:String = 'FurWarn';

	override public function create()
	{
		_FURRYWARNING = new FlxSpriteGroup();
        _FLASHWARNING = new FlxSpriteGroup(1500, 0, 0);
        CreateFurryWarning();
        CreateFlashWarning();
	}

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if(FlxG.keys.anyJustPressed([ENTER, SPACE])) {
            switch(curWarn) {
                case 'FurWarn':
                    TweenWarningOut(_FURRYWARNING);
                    TweenWarningIn(_FLASHWARNING);
                    curWarn = 'FlashWarn';
                case 'FlashWarn':
                    TweenWarningOut(_FLASHWARNING);
                    //TweenWarningIn(_CONFIRMATION);
                    curWarn = 'Confirmation';
                default:
                    MusicBeatState.switchState(new TitleState());
                    #if debug
                        trace('ERROR GETTING CURRENT WARNING VALUE');
                    #end
            }
        };
        if(FlxG.keys.anyJustPressed([BACKSPACE, ESCAPE])) {
            switch(curWarn) {
                case 'FurWarn':
                    //DoTheFunnyFurryThing();
                    curWarn = 'FUCK YOU';
                case 'FlashWarn':
                    TweenWarningOut(_FLASHWARNING);
                    ClientPrefs.data.flashing = false;
					ClientPrefs.saveSettings();
                    //TweenWarningIn(_CONFIRMATION);
                    curWarn = 'Confirmation';
                default:
                    MusicBeatState.switchState(new TitleState());
                    #if debug
                        trace('ERROR GETTING CURRENT WARNING VALUE');
                    #end
            }
        };
    }

    public function CreateFlashWarning() {
		var FLBG:FlxSprite = new FlxSprite(-150, -20);
		FLBG.frames = Paths.getSparrowAtlas('Warnings/FURRY_SEPERATOR');
		FLBG.animation.addByPrefix('Idle', 'SEPERATOR_furry', 24, true, false, false);
		FLBG.animation.play('Idle');
		FWarn_keepordisable = new Alphabet(-45, 20, '           |   \nto keep\nffflashing lights\n           /   \nto disable\nffflashing lights', true); // we can handle the side text through the alphabet now, possibly.
        FWarn_headsup = new Alphabet(70, 350, 'head\'s up!', true);
        FWarn_fuckingparagraph = new Alphabet(0, 440, 'this mod has a lot of\nflashing lights\nmost of witch cant\nbe disabled atm', true);
		fixFlashTextScaling();
		_FLASHWARNING.add(FLBG);
		_FLASHWARNING.add(FWarn_keepordisable);
		_FLASHWARNING.add(FWarn_headsup);
		_FLASHWARNING.add(FWarn_fuckingparagraph);

		add(_FLASHWARNING);
    }

    public function CreateFurryWarning() {
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

    public function fixFlashTextScaling():Void
        {
            FWarn_keepordisable.setScale(0.5, 0.5); // upper text
            FWarn_headsup.setScale(0.8, 0.8); // heads up text
            FWarn_fuckingparagraph.setScale(0.6, 0.6); // yap
        }

	public function TweenWarningOut(WarningToTween:FlxSpriteGroup):Void
	{
        FlxTween.tween(WarningToTween, { x: -1500}, 1, { ease: FlxEase.cubeInOut, onComplete: (_)->WarningToTween.kill() });
	}

	public function TweenWarningIn(WarningToTween:FlxSpriteGroup):Void
	{
        FlxTween.tween(WarningToTween, { x: 0}, 1, { ease: FlxEase.cubeInOut });
	}
}
