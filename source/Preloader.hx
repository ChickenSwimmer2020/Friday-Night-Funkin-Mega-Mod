package;
import flixel.graphics.FlxGraphic;
import sys.thread.Thread;
import openfl.utils.Timer;
import openfl.display.Bitmap;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.text.Font;
import openfl.display.Sprite;
import flash.display.*;
import flash.Lib;
import flixel.system.FlxBasePreloader;

import flixel.FlxG;

import backend.ClientPrefs;

using StringTools;

//ZSOLARDEV IS A FUCKING GOD!!!!!!
//he actually was able to get this preloader to do something other than look cool and lag the game on startup.
//he the best frfr

typedef CacheFiles = {
    var imagePaths:Array<String>;
    var soundPaths:Array<String>;
}

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

	public static var loadingStr:String = 'hehe, null.';
	public static var fullSize:Int = 0;
	public static var doneCaching = false;
	public static var curProgress:Int = 0;

	var directories:Array<String> = [];

	var cached:Bool = false;

	var scaledPercent:Float;

	public static function cache(cacheFiles:CacheFiles)
		{
			
			Thread.create(() ->
			{
				doneCaching = false;
				fullSize = 0;
				fullSize = cacheFiles.imagePaths.length;
				fullSize += cacheFiles.soundPaths.length;
				for (i in cacheFiles.imagePaths)
				{
					curProgress++;
					loadingStr = 'Loading: $i';
					//trace(i);
					var data:BitmapData = BitmapData.fromFile(i);
					var graphic:FlxGraphic = FlxGraphic.fromBitmapData(data);
					graphic.persist = true;
					graphic.destroyOnNoUse = false;
				}
	
				for (i in cacheFiles.soundPaths)
				{
					curProgress++;
					loadingStr = 'Loading Sound: $i';
					var sound:FlxSound;
					sound = new FlxSound();
					sound.loadEmbedded(i);
					sound.volume = 0;
					sound.play();
					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						sound.stop();
						sound.destroy();
						sound = null;
					});
				}
				doneCaching = true;
			});
		}

	override public function create() {

		//have to do this for every folder :(
		//works anyways!
		for (file in FileSystem.readDirectory('assets/shared/images'))
			{
				if(file.endsWith('.png'))
					directories.push(file);
			}
		for (file in FileSystem.readDirectory('assets/shared/images/menudifficulties'))
			{
				if(file.endsWith('.png'))
					directories.push(file);
			}
		for (file in FileSystem.readDirectory('assets/shared/images/FurryWarning'))
			{
				if(file.endsWith('.png'))
					directories.push(file);
			}
		for (file in FileSystem.readDirectory('assets/shared/images/MainMenu'))
			{
				if(file.endsWith('.png'))
					directories.push(file);
			}
			for (file in FileSystem.readDirectory('assets/shared/images/MainMenu/Sketches'))
				{
					if(file.endsWith('.png'))
						directories.push(file);
				}
		for (file in FileSystem.readDirectory('assets/shared/images/OptionsMenu'))
			{
				if(file.endsWith('.png'))
					directories.push(file);
			}
		for (file in FileSystem.readDirectory('assets/shared/images/achievements'))
			{
				if(file.endsWith('.png'))
					directories.push(file);
			}
		for (file in FileSystem.readDirectory('assets/shared/images/characters'))
			{
				if(file.endsWith('.png'))
					directories.push(file);
			}
		for (file in FileSystem.readDirectory('assets/shared/images/credits'))
			{
				if(file.endsWith('.png'))
					directories.push(file);
			}
		for (file in FileSystem.readDirectory('assets/shared/images/dialogue'))
			{
				if(file.endsWith('.png'))
					directories.push(file);
			}
		for (file in FileSystem.readDirectory('assets/shared/images/icons'))
			{
				if(file.endsWith('.png'))
					directories.push(file);
			}
		for (file in FileSystem.readDirectory('assets/shared/images/menubackgrounds'))
			{
				if(file.endsWith('.png'))
					directories.push(file);
			}
		for (file in FileSystem.readDirectory('assets/shared/images/noteColorMenu'))
			{
				if(file.endsWith('.png'))
					directories.push(file);
			}
		for (file in FileSystem.readDirectory('assets/shared/images/noteSkins'))
			{
				if(file.endsWith('.png'))
					directories.push(file);
			}
			for (file in FileSystem.readDirectory('assets/shared/images/noteSkins/Mechanics'))
				{
					if(file.endsWith('.png'))
						directories.push(file);
				}
		for (file in FileSystem.readDirectory('assets/shared/images/noteSplashes'))
			{
				if(file.endsWith('.png'))
					directories.push(file);
			}
			for (file in FileSystem.readDirectory('assets/shared/images/noteSplashes/mechanics'))
				{
					if(file.endsWith('.png'))
						directories.push(file);
				}
		for (file in FileSystem.readDirectory('assets/shared/images/pixelUI'))
			{
				if(file.endsWith('.png'))
					directories.push(file);
			}
		for (file in FileSystem.readDirectory('assets/shared/images/storymenu'))
			{
				if(file.endsWith('.png'))
					directories.push(file);
			}
				cache({imagePaths:directories, soundPaths:[]});
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
			text.text = "PRELOADING ASSETS\n   DO NOT CLOSE";
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
		scaledPercent = (curProgress/fullSize) * 100;
		text2.text = "Loading " + Std.int(scaledPercent) + "%";
		super.update(Percent);

		if(doneCaching && !cached)
			{
				trace('finished caching!');
				cached = true;
			}
	}
	override public function onLoaded()
	{
		super.onLoaded();
		//trace('Files Loaded: ' + directories);
	}
}