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

		LoadText = new FlxText(0, 0, 0, "CACHING ASSETS", 8, false);
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
		Functions.wait(15, () ->
		{
			MusicBeatState.switchState(new TitleState());
		});
		super.create();
	}

	override public function update(elapsed:Float)
	{

		super.update(elapsed);
	}

	public function Cache()
	{
		// images
		Thread.create(() ->
		{
            var images = FileSystem.readDirectory('assets/shared/images');
            for (image in images)
                if (image.endsWith('.png'))
                    Paths.image(image.substring(1, image.length - 4));
			// TitleScreen
			Paths.image('TitleScreen/bfBopTitle');
			Paths.image('TitleScreen/bgcool');
			Paths.image('TitleScreen/ChickenSwimmer2020_logo');
			Paths.image('TitleScreen/ChickenSwimmer2020YouTube_logo');
			Paths.image('TitleScreen/logoBumpin');
			#if DEBUG
				Paths.image('TitleScreen/DeveloperMode');
			#end
			Paths.image('TitleScreen/MenuBGbitR');
			Paths.image('TitleScreen/MMlogo');
			Paths.image('TitleScreen/newgrounds_logo');
			Paths.image('TitleScreen/titleEnter');
			Paths.image('TitleScreen/TitleTextBG');
			Paths.image('TitleScreen/VersionNum');
			Paths.image('TitleScreen/SquaresBG');
			// MainMenu
			Paths.image('MainMenu/menuBG');
			Paths.image('MainMenu/menu_youtube');
			Paths.image('MainMenu/menu_story_mode');
			Paths.image('MainMenu/menu_settings');
			Paths.image('MainMenu/menu_freeplay');
			Paths.image('MainMenu/menu_discord');
			Paths.image('MainMenu/menu_credits');
			Paths.image('MainMenu/menu_gallery');
			Paths.image('MainMenu/menu_awards');
			// MainMenu_Sketches
			Paths.image('MainMenu/Sketches/Sketchy0');
			Paths.image('MainMenu/Sketches/Sketchy1');
			Paths.image('MainMenu/Sketches/Sketchy2');
			// MainMenu_Enters
			Paths.image('MainMenu/Enters/Enter_awards');
			Paths.image('MainMenu/Enters/Enter_settings');
			Paths.image('MainMenu/Enters/Enter_story_mode');
			// OptionsMenu
			Paths.image('OptionsMenu/Background');
			Paths.image('OptionsMenu/Gears');
			// StoryMenu
			Paths.image('storymenu/Chicken');
			Paths.image('storymenu/Tutorial');
		});

		// data
		Thread.create(() ->
		{
			Paths.xml('VizMenu');
			Paths.xml('Tracks');
			Paths.xml('speech_bubble');
			Paths.xml('PulgeBS');
			Paths.xml('PlayChar');
			Paths.xml('JukeBox_PANEL');
			Paths.xml('JukeBox');
			Paths.xml('IntroSprite');
			Paths.xml('freeplay_songs');
			Paths.xml('DeathScreen_RATINGS');
			Paths.xml('DeathScreen_RATINGNUM');
			Paths.xml('DeathScreen_DIFFICULTIES');
			Paths.xml('DeathScreen_COMBONUM');
			Paths.xml('comboMilestoneNumbers');
			Paths.xml('comboMilestone');
			Paths.xml('checkboxanim');
			Paths.xml('campaign_menu_UI_assets');
			Paths.xml('alphabet_playstation');
			Paths.xml('alphabet');
			Paths.json('alphabet');
			//TitleScreen
			Paths.xml('TitleScreen/bfBopTitle');
			Paths.xml('TitleScreen/bgcool');
			Paths.xml('TitleScreen/ChickenSwimmer2020_logo');
			Paths.xml('TitleScreen/ChickenSwimmer2020YouTube_logo');
			#if DEBUG
				Paths.xml('TitleScreen/DeveloperMode');
			#end
			Paths.xml('TitleScreen/logoBumpin');
			Paths.xml('TitleScreen/MMlogo');
			Paths.xml('TitleScreen/titleEnter');
			Paths.xml('TitleScreen/TitleTextBG');
			Paths.xml('TitleScreen/VersionNum');
			// MainMenu
			Paths.xml('MainMenu/menu_awards');
			Paths.xml('MainMenu/menu_credits');
			Paths.xml('MainMenu/menu_discord');
			Paths.xml('MainMenu/menu_freeplay');
			Paths.xml('MainMenu/menu_gallery');
			Paths.xml('MainMenu/menu_settings');
			Paths.xml('MainMenu/menu_story_mode');
			Paths.xml('MainMenu/menu_youtube');
			// MainMenu_Sketches
			Paths.xml('MainMenu/Sketches/Sketchy0');
			Paths.xml('MainMenu/Sketches/Sketchy1');
			Paths.xml('MainMenu/Sketches/Sketchy2');
			// MainMenu_Enters
			Paths.xml('MainMenu/Enters/Enter_awards');
			Paths.xml('MainMenu/Enters/Enter_settings');
			Paths.xml('MainMenu/Enters/Enter_story_mode');
			// OptionsMenu
			Paths.xml('OptionsMenu/Gears');
		});
	}
}
