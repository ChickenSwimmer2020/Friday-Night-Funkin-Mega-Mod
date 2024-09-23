package states;


//stuff below this is fine!

import flixel.addons.transition.FlxTransitionableState;
import lime.app.Application;
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
import backend.WindowsAPI;

using StringTools;

//ZSOLARDEV IS A FUCKING GOD!!!!!!
//he actually was able to get this preloader to do something other than look cool and lag the game on startup.
//he the best frfr
//sorry solar, i had to remake it.

class Preload extends MusicBeatState {
	var wait:FlxTimer;
	var loaded:FlxTimer;
	var logo:FlxSprite;
	var box:FlxSprite;
	var icon:FlxSprite;
	var text:FlxText;
	var text2:FlxText;
	var GameLoadCoolIcon:FlxSprite;
	override public function create() {
		FlxTransitionableState.skipNextTransOut = true;
		FlxTransitionableState.skipNextTransIn = true;
		Application.current.window.borderless = true;
		function GameLoaded():Void
			{
				MusicBeatState.switchState(new FlashingState());
			}
		function CacheFin():Void
			{
				logo.visible = false;
				box.visible = false;
				text.visible = false;
				text2.visible = false;
				icon.visible = false;
				GameLoadCoolIcon.visible = true;
				GameLoadCoolIcon.animation.play('Appear', true, false);
			}
			
		wait = new FlxTimer();
		loaded = new FlxTimer();
		wait.start(10, function(Tmr:FlxTimer) {GameLoaded();});
		loaded.start(8.8, function(Tmr:FlxTimer) {CacheFin();});
		logo = new FlxSprite(300, 0).loadGraphic(Paths.image('Preloader/LoadLogo'));
		logo.scale.set(1,1);
		box = new FlxSprite(logo.x, logo.y + 500).loadGraphic(Paths.image('Preloader/LoadBox'));
		box.scale.set(1,1);

		GameLoadCoolIcon = new FlxSprite(0, 0);
		GameLoadCoolIcon.scale.set(1,1);
		//GameLoadCoolIcon.screenCenter();
		GameLoadCoolIcon.visible = false;
		GameLoadCoolIcon.frames = Paths.getSparrowAtlas('Preloader/Loaded');
		GameLoadCoolIcon.animation.addByPrefix('Appear', 'GameLoaded', 24, true, false, false);

		icon = new FlxSprite(box.x + 15, box.y + 125);
		icon.scale.set(1,1);
		icon.frames = Paths.getSparrowAtlas('Preloader/LoadIcon');
		icon.animation.addByPrefix('Spin', 'Loading Icon', 24, true, false, false);
		text = new FlxText(box.x + 70, box.y + 50, 0, "Preloading Assets", 24, true);
		text.setFormat("Cave Story Regular", 70, FlxColor.WHITE, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
		text2 = new FlxText(icon.x + 100, icon.y + 30, 0, "Please wait...", 24, true);
		text2.setFormat("Cave Story Regular", 48, FlxColor.WHITE, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
		super.create();
		add(box);
		add(text);
		add(text2);
		add(icon);
		add(logo);
		add(GameLoadCoolIcon);
		WindowsAPI.setWindowTransparencyColor(0, 0, 0, 255);
		icon.animation.play('Spin', true, false);
	}
}