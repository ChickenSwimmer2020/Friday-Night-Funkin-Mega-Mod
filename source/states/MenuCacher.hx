package states;

import flixel.ui.FlxBar;
import backend.Functions;
import sys.thread.Thread;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;

class MenuCacher extends MusicBeatState
{
	var LoadText:FlxText;
	var Color:FlxSprite;
	var BG:FlxBackdrop;
	var _BG:FlxBackdrop; // second set of squares.

	var Bar:FlxBar;

	var MsgTxt:String = 'CACHING MENU ASSETS';

	public function new(WhereToLoadTo:Null<flixel.FlxState>, ?message:String)
	{
		super();

		Color = new FlxSprite().makeGraphic(1920, 1080, FlxColor.LIME, false);

		LoadText = new FlxText(0, 0, 0, MsgTxt, 8, false);
		LoadText.setFormat(null, 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, true);

		BG = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x00000000, 0x6B000000));
		BG.velocity.set(100, 100);

		_BG = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x6B000000, 0x00000000));
		_BG.velocity.set(-100, -100);

		//Bar = new FlxBar(0, 450, LEFT_TO_RIGHT, 100, 10, null, "", 0, 100, true);

		add(Color);
		add(BG);
		add(_BG);
		add(LoadText);
		LoadText.screenCenter(XY);

		Cache();
		Functions.wait(5, () ->
		{
			if(WhereToLoadTo == null) {
				MusicBeatState.switchState(new TitleState()); //prevent a crash by having a fallback state to load to
				#if debug
					trace('ERROR LOADING STATE\nLOADING FALLBACK...');
				#end
			}
			else
				MusicBeatState.switchState(WhereToLoadTo);
		});
	}

	override public function update(elapsed:Float)
	{

		super.update(elapsed);
	}

	public function Cache()
	{
		// MainMenu
		Thread.create(() ->
		{
            var MainMenu = FileSystem.readDirectory('assets/shared/images/MainMenu');
            for (image in MainMenu)
                if (image.endsWith('.png'))
                    Paths.image(image.substring(0, image.length - 4));
			var Sketchy = FileSystem.readDirectory('assets/shared/images/MainMenu/Sketches');
            for (image in Sketchy)
                if (image.endsWith('.png'))
                    Paths.image(image.substring(0, image.length - 4));
			var Coolio = FileSystem.readDirectory('assets/shared/images/MainMenu/Enters');
            for (image in Coolio)
                if (image.endsWith('.png'))
                    Paths.image(image.substring(0, image.length - 4));
			Paths.cacheBitmap('VizMenu');
		});
		// FreePlay
		Thread.create(() ->
		{
			//have to do manually since they dont have their own folder.
			Paths.cacheBitmap('freeplay_songs');
			Paths.cacheBitmap('JukeBox');
			Paths.cacheBitmap('jukebox_OVERLAY');
			Paths.cacheBitmap('JukeBox_PANEL');
		});
		// Story Menu
		Thread.create(() ->
		{
			var StoryMenu = FileSystem.readDirectory('assets/shared/images/storymenu');
			for (image in StoryMenu)
				if (image.endsWith('.png'))
					Paths.image(image.substring(0, image.length - 4));
			Paths.cacheBitmap('PlayChar');
			Paths.cacheBitmap('Tracks');
		});
	}
}
