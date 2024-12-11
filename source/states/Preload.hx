package states;

import states.Warnings;
import flixel.FlxState;
import backend.utils.Cache;
import flixel.ui.FlxBar;
import sys.thread.Thread;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;

class Preload extends MusicBeatState
{
	var LoadText:FlxText;
	var Color:FlxSprite;
	var BG:FlxBackdrop;
	var _BG:FlxBackdrop; // second set of squares.

	var Bar:FlxBar;
    var prog = 0;
    var maxProg:Float = 0;
    var cache:Cache = new Cache();

	public var StateToLoad:Null<flixel.FlxState>; //so we can choose if we need to load the warnings, or titlestate.

	override public function create()
	{
		Color = new FlxSprite().makeGraphic(1920, 1080, FlxColor.LIME, false);

		LoadText = new FlxText(0, 0, 0, "CACHING MENUS...\nPLEASE WAIT", 8, false);
		LoadText.setFormat(null, 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, true);

		BG = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x00000000, 0x6B000000));
		BG.velocity.set(100, 100);

		_BG = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x6B000000, 0x00000000));
		_BG.velocity.set(-100, -100);

		//Bar = new FlxBar(0, 450, LEFT_TO_RIGHT, 100, 10, null, "", 0, 100, true);
        Bar = new FlxBar(0, FlxG.height * 0.9, FlxBarFillDirection.HORIZONTAL_INSIDE_OUT, 601, 35, null, '', 0, 1, true);
		Bar.scale.x = 2;
		Bar.scale.y = 1.2;
		Bar.screenCenter(X);
		Bar.scrollFactor.set();
		Bar.createFilledBar(FlxColor.TRANSPARENT, FlxColor.WHITE, true, FlxColor.WHITE);
		

		add(Color);
		add(BG);
		add(_BG);
		add(LoadText);
        add(Bar);
		LoadText.screenCenter(XY);

        Thread.create(() ->{ cache.cacheMenuAssets(); });
		Thread.create(() ->{ AlphaCharacter.loadAlphabetData(); }); //do this here 1: to not stutter, two. so no matter what state we load, we dont crash
		super.create();
	}

    var doneFrames = 0;
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if(FlxG.save.data.warnings) { //should work in theory? //would have used ClientPrefs, but loading preferences causes a big graphics bug, so we use FlxG.save instead
			StateToLoad = new Warnings();
		}else{
			StateToLoad = new TitleState();
		}
        prog = cache.prog;
        maxProg = cache.targetProg;
        if (maxProg > 0)
            Bar.setRange(0, maxProg);
        Bar.value = prog;
        if (prog == maxProg) 
        {
            doneFrames++;
        if (doneFrames >= 30) MusicBeatState.switchState(StateToLoad);
        }else
            doneFrames = 0;
	}
}