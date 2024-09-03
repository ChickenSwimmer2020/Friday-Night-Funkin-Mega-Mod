package;
import openfl.utils.Timer;
import openfl.display.Bitmap;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.text.Font;
import openfl.display.Sprite;
import flash.display.*;
import flash.Lib;
import flixel.system.FlxBasePreloader;

@:bitmap("assets/shared/images/Preloader/Logo.png") class LogoImage extends BitmapData { }
@:font("assets/fonts/vcr.ttf") class CustomFont1 extends Font {}
@:font("assets/fonts/Cave-Story.ttf") class CustomFont2 extends Font {}

class Preloader extends FlxBasePreloader {
	public function new(MinDisplayTime:Float = 0) {
		super(5);	
	}

	var logo:Sprite;
	var text:TextField;
	var text2:TextField;

	override public function create() {
		if(ClientPrefs.data.Cache)
			{
				//oh my fucking god...
					//function creation
						function cacheImages() //specifically .png
							{
								//loose files
								Paths.image('healthbaroverlay');
								Paths.image('timebar_overlay');
								Paths.image('IntroSprite');
								Paths.image('PlayChar');
								Paths.image('Tracks');
								Paths.image('menuBGBlue');
								Paths.image('menuDesat');
								Paths.image('combo');
								Paths.image('controllertype');
								Paths.image('eventArrow');
								Paths.image('good');
								Paths.image('healthbar');
								//Paths.image('logo');
								Paths.image('num0');
								Paths.image('num1');
								Paths.image('num2');
								Paths.image('num3');
								Paths.image('num4');
								Paths.image('num5');
								Paths.image('num6');
								Paths.image('num7');
								Paths.image('num8');
								Paths.image('num9');
								Paths.image('shit');
								Paths.image('sick');
								Paths.image('speech_bubble');
								Paths.image('timeBar');
								Paths.image('alphabet');
								Paths.image('alphabet_playstation');
								Paths.image('bad');
								Paths.image('campaign_menu_UI_assets');
								Paths.image('chart_quant');
								Paths.image('checkboxanim');
								//folders
								for (file in FileSystem.readDirectory('assets/shared/images/menudifficulties')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
								for (file in FileSystem.readDirectory('assets/shared/images/overworld')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
								for (file in FileSystem.readDirectory('assets/shared/images/FurryWarning')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
								for (file in FileSystem.readDirectory('assets/shared/images/MainMenu')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
									for (file in FileSystem.readDirectory('assets/shared/images/MainMenu/Enters')) {
										file = file.substring(0, file.lastIndexOf('.'));
									}
									for (file in FileSystem.readDirectory('assets/shared/images/MainMenu/Sketches')) {
										file = file.substring(0, file.lastIndexOf('.'));
									}
								for (file in FileSystem.readDirectory('assets/shared/images/OptionsMenu')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
								for (file in FileSystem.readDirectory('assets/shared/images/TitleScreen')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
								for (file in FileSystem.readDirectory('assets/shared/images/achievements')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
								for (file in FileSystem.readDirectory('assets/shared/images/characters')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
								for (file in FileSystem.readDirectory('assets/shared/images/credits')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
								#if DEBUG
									for (file in FileSystem.readDirectory('assets/shared/images/DEBUG')) {
										file = file.substring(0, file.lastIndexOf('.'));
									}
								#end
								for (file in FileSystem.readDirectory('assets/shared/images/dialogue')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
								for (file in FileSystem.readDirectory('assets/shared/images/Gallery')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
								for (file in FileSystem.readDirectory('assets/shared/images/icons')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
								for (file in FileSystem.readDirectory('assets/shared/images/menubackgrounds')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
								for (file in FileSystem.readDirectory('assets/shared/images/menucharacters')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
								for (file in FileSystem.readDirectory('assets/shared/images/noteColorMenu')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
								for (file in FileSystem.readDirectory('assets/shared/images/noteSkins')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
									for (file in FileSystem.readDirectory('assets/shared/images/noteSkins/Mechanics')) {
										file = file.substring(0, file.lastIndexOf('.'));
									}
								for (file in FileSystem.readDirectory('assets/shared/images/noteSplashes')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
									for (file in FileSystem.readDirectory('assets/shared/images/noteSplashes/mechanics')) {
										file = file.substring(0, file.lastIndexOf('.'));
									}
								for (file in FileSystem.readDirectory('assets/shared/images/pixelUI')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
								for (file in FileSystem.readDirectory('assets/shared/images/storymenu')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
							}
						function cacheData() //extends to both .json and .xml
							{
								//xml
								Paths.Externalxml('shared/images/healthbaroverlay');
								Paths.Externalxml('shared/images/timebar_overlay');
								Paths.Externalxml('shared/images/IntroSprite');
								Paths.Externalxml('shared/images/PlayChar');
								Paths.Externalxml('shared/images/Tracks');
								Paths.Externalxml('shared/images/titleEnter');
								Paths.Externalxml('shared/images/alphabet');
								Paths.Externalxml('shared/images/speech_bubble');
								Paths.Externalxml('shared/images/alphabet_playstation');
								Paths.Externalxml('shared/images/campaign_menu_UI_assets');
								Paths.Externalxml('shared/images/chart_quant');
								Paths.Externalxml('shared/images/checkboxanim');
								//json
									//characters
									Paths.Externaljson('bf-cs20');
									Paths.Externaljson('bf');
									Paths.Externaljson('bf-dead');
									Paths.Externaljson('bf-pixel');
									Paths.Externaljson('bf-pixel-dead');
									Paths.Externaljson('bf-pixel-opponent');
									Paths.Externaljson('gf');
									Paths.Externaljson('gf-pixel');
								Paths.json('digital/digital');
								Paths.json('digital/digital-nightmare');
								Paths.json('digital/events');
								Paths.json('OptionsMenu/offsets');
								Paths.json('FurWarn/offsets');
								#if DEBUG
								Paths.json('DEBUG/CHART');
								#end
								Paths.json('Gallery/GalleryData');
								Paths.json('testsong-Debug');
								Paths.json('TitleScreen/MenuLocations');
								Paths.json('tutorial/events');
								Paths.json('tutorial/tutorial');
								Paths.json('tutorial/tutorial-easy');
								Paths.json('tutorial/tutorial-hard');
								//folders
								for (file in FileSystem.readDirectory('assets/shared/images/characters')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
								for (file in FileSystem.readDirectory('assets/shared/images/dialogue')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
								for (file in FileSystem.readDirectory('assets/shared/images/noteSkins')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
									for (file in FileSystem.readDirectory('assets/shared/images/noteSkins/Mechanics')) {
										file = file.substring(0, file.lastIndexOf('.'));
									}
								for (file in FileSystem.readDirectory('assets/shared/images/noteSplashes')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
									for (file in FileSystem.readDirectory('assets/shared/images/noteSplashes/mechanics')) {
										file = file.substring(0, file.lastIndexOf('.'));
									}
								for (file in FileSystem.readDirectory('assets/shared/images/MainMenu')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
								for (file in FileSystem.readDirectory('assets/shared/images/OptionsMenu')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
								for (file in FileSystem.readDirectory('assets/shared/images/TitleScreen')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
								for (file in FileSystem.readDirectory('assets/shared/images/FurryWarning')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
							}
						function cacheSounds() //sounds folder
							{
								//im not even gonna try.
								for (file in FileSystem.readDirectory('assets/shared/sounds')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
							}
						function cacheMusic() //music folder
							{
								for (file in FileSystem.readDirectory('assets/shared/music')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
							}
						function cacheSongs() //songs folder
							{
								for (file in FileSystem.readDirectory('assets/songs/digital')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
								for (file in FileSystem.readDirectory('assets/songs/testsong')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
								for (file in FileSystem.readDirectory('assets/songs/tutorial')) {
									file = file.substring(0, file.lastIndexOf('.'));
								}
							}
					//running said functions
					cacheImages();
					cacheSounds();
					cacheMusic();
					cacheSongs();
					cacheData();
			}
		this._width = Lib.current.stage.stageWidth;
		this._height = Lib.current.stage.stageHeight;

		var ratio:Float = this._width / 1250; //asset scaling.

		logo = new Sprite();
		logo.addChild(new Bitmap(new LogoImage(0,0)));
		logo.scaleX = logo.scaleY = ratio;
		logo.x = ((this._width) / 2) - ((logo.width) / 2);
		logo.y = (this._height / 2) - ((logo.height) / 2);
		addChild(logo);

		Font.registerFont(CustomFont1);
			text = new TextField();
			text.defaultTextFormat = new TextFormat("VCR OSD Mono", 24, 0xffffffff);
			text.embedFonts = true;
			text.text = "   DO NOT CLOSE\nPRELOADING ASSETS";
			text.width = 300;
			text.x = 500;
			text.y = 660;
			addChild(text);

		Font.registerFont(CustomFont2);
			text2 = new TextField();
			text2.defaultTextFormat = new TextFormat("Cave Story Regular", 66, 0xffffff, false, false, false, "", "", CENTER);
			text2.embedFonts = true;
			text2.selectable = false;
			text2.multiline = false;
			text2.x = 0;
			text2.y = 5.2 * this._height / 6;
			text2.width = _width;
			text2.height = Std.int(66 * ratio);
			addChild(text2);
		
		super.create();
		
	}
	override public function update(Percent:Float):Void
	{
		text2.text = "Loading " + Std.int(Percent * 100) + "%";
		super.update(Percent);
	}
	override public function onLoaded()
	{
		super.onLoaded();
	}
}