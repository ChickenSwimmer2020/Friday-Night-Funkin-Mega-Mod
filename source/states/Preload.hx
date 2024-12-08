package states;

import flixel.ui.FlxBar;
import backend.Functions;
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

		add(Color);
		add(BG);
		add(_BG);
		add(LoadText);
		LoadText.screenCenter(XY);

		Cache();
		Functions.wait(1, () ->
		{
			MusicBeatState.switchState(new Warnings());
		});
		super.create();
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
            var MainMenu = FileSystem.readDirectory('assets/shared/images/MainMenu/');
            for (image in MainMenu)
                if (image.endsWith('.png'))
                    Paths.image(image.substring(0, image.length - 4));
			var Sketchy = FileSystem.readDirectory('assets/shared/images/MainMenu/Sketches/');
            for (image in Sketchy)
                if (image.endsWith('.png'))
                    Paths.image(image.substring(0, image.length - 4));
			var Coolio = FileSystem.readDirectory('assets/shared/images/MainMenu/Enters/');
            for (image in Coolio)
                if (image.endsWith('.png'))
                    Paths.image(image.substring(0, image.length - 4));
			Paths.cacheBitmap('images/VizMenu.png');
		});
		// FreePlay
		Thread.create(() ->
		{
			//have to do manually since they dont have their own folder.
			Paths.cacheBitmap('images/freeplay_songs.png');
			Paths.cacheBitmap('images/JukeBox.png');
			Paths.cacheBitmap('images/jukebox_OVERLAY.png');
			Paths.cacheBitmap('images/JukeBox_PANEL.png');
		});
		// Story Menu
		Thread.create(() ->
		{
			var StoryMenu = FileSystem.readDirectory('assets/shared/images/storymenu');
			for (image in StoryMenu)
				if (image.endsWith('.png'))
					Paths.image(image.substring(0, image.length - 4));
			Paths.cacheBitmap('images/PlayChar.png');
			Paths.cacheBitmap('images/Tracks.png');
		});
	}
}
