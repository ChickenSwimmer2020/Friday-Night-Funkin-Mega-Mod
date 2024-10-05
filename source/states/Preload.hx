package states;

// stuff below this is fine!
import openfl.system.System;
import lime.math.Vector2;
import lime.ui.Window;
import openfl.display.Stage;
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
import lime.system.System;

using StringTools;

// ZSOLARDEV IS A FUCKING GOD!!!!!!
// he actually was able to get this preloader to do something other than look cool and lag the game on startup.
// he the best frfr
// sorry solar, i had to remake the state. ill just take the base game preloading code.
// TODO: fix the outlines, might be an antialiasing issue
#if !SKIP_PRELOADER
class Preload extends MusicBeatState
{
	var FlixLog:FlxTimer;
	var loaded:FlxTimer;
	var givegametimetoloadassets:FlxTimer;
	var waitforthetweentime:FlxTimer;
	var bgfadeout:FlxTimer;
	var titlefade:FlxTimer;

	var logo:FlxSprite;
	var box:FlxSprite;
	var icon:FlxSprite;
	var FlixelLogo:FlxSprite;

	var text:FlxText;
	var text2:FlxText;

	var TimeToLoad:Bool = false;

    var oldX = 0;
    var oldY = 0;

	public function PreloaderArtAppear()
	{
		FlixelLogo.visible = false;
		FlxTween.tween(box, {y: 500, alpha: 1}, 1, {ease: FlxEase.circOut});
		FlxTween.tween(icon, {y: 625, alpha: 1}, 1.2, {ease: FlxEase.circOut});
		FlxTween.tween(text, {y: 550, alpha: 1}, 1.5, {ease: FlxEase.circOut});
		FlxTween.tween(text2, {y: 655, alpha: 1}, 2, {ease: FlxEase.circOut});
		FlxTween.tween(logo, {y: 0}, 2.5, {ease: FlxEase.circOut});
		logo.visible = true;
		box.visible = true;
		icon.visible = true;
		text.visible = true;
		text2.visible = true;
	}

	public function TweenOut()
	{
		FlxTween.tween(box, {y: -1000, alpha: 0}, 1, {ease: FlxEase.circInOut});
		FlxTween.tween(icon, {y: -1000, alpha: 0}, 1.2, {ease: FlxEase.circInOut});
		FlxTween.tween(text, {y: -1000, alpha: 0}, 1.3, {ease: FlxEase.circInOut});
		FlxTween.tween(text2, {y: -1000, alpha: 0}, 1.5, {ease: FlxEase.circInOut});
		FlxTween.tween(logo, {y: 200}, 2, {ease: FlxEase.sineOut});
		titlefade.start(2, function(Tmr:FlxTimer)
		{
			FlxTween.tween(logo, {alpha: 0}, 0.5, {ease: FlxEase.sineOut});
		});
		bgfadeout.start(2.5, function(Tmr:FlxTimer)
		{
            Application.current.window.width = 1280;
            Application.current.window.height  = 720;
            Application.current.window.x = oldX;
            Application.current.window.y = oldY;
            Application.current.window.borderless = false;
			MusicBeatState.switchState(new GameIntro());
		});
	}

	override public function create()
	{
		// trace('Window X: ' + Lib.application.window.x + ' Window Y: ' + Lib.application.window.y);
        oldX = Application.current.window.x;
        oldY = Application.current.window.y;
        //Application.current.window.width = Std.int(openfl.Lib.application.window.display.bounds.width);
        //Application.current.window.height = Std.int(openfl.Lib.application.window.display.bounds.height);
        //Application.current.window.x = 0;
        //Application.current.window.y = 0;
		FlxTransitionableState.skipNextTransOut = false;
		FlxTransitionableState.skipNextTransIn = true;
		Application.current.window.borderless = true;

        WindowsAPI.setWindowTransparencyColor(0, 0, 0, 255);

		FlixelLogo = new FlxSprite(0, 0);
		FlixelLogo.scale.set(0.5, 0.5);
		//FlixelLogo.screenCenter();
		FlixelLogo.frames = Paths.getSparrowAtlas('Preloader/FlixelLogo');
		FlixelLogo.animation.addByPrefix('Logo', 'flixellogo', 24, false);
		FlixelLogo.visible = false;

		waitforthetweentime = new FlxTimer();
		FlixLog = new FlxTimer();
		loaded = new FlxTimer();
		givegametimetoloadassets = new FlxTimer();
		bgfadeout = new FlxTimer();
		titlefade = new FlxTimer();

		inline function OtherTimersGo()
		{
			FlixLog.start(3.2, function(Tmr:FlxTimer)
			{
				PreloaderArtAppear();
				waitforthetweentime.start(5, function(Tmr:FlxTimer)
				{
					TweenOut();
				});
			});
			// remember to make duration dynamically update depending on load time like the og preloader did.
		}

		givegametimetoloadassets.start(1, function(Tmr:FlxTimer)
		{
			OtherTimersGo();
			FlxG.mouse.visible = false;
			FlixelLogo.animation.play('Logo', false);
			FlxG.sound.play(Paths.sound('flixel'), 0.5);
			FlixelLogo.visible = true;
		});

		FlixelLogo.animation.finishCallback = function(nameThing)
		{
			FlixelLogo.kill();
		};

		logo = new FlxSprite(350, -1000).loadGraphic(Paths.image('Preloader/LoadLogo'));
		logo.scale.set(1, 1);
		logo.visible = false;
		box = new FlxSprite(logo.x, 1000).loadGraphic(Paths.image('Preloader/LoadBox'));
		box.scale.set(1, 1);
		box.visible = false;
		box.alpha = 0;

		// originally, all of the y values were set by the object behind them.
		// i cant do that now thanks to the way that `FlxTween` works. thanks haxe
		icon = new FlxSprite(box.x + 15, 1000);
		icon.scale.set(1, 1);
		icon.frames = Paths.getSparrowAtlas('Preloader/LoadIcon');
		icon.animation.addByPrefix('Spin', 'Loading Icon', 24, true, false, false);
		icon.visible = false;
		icon.alpha = 0;
		text = new FlxText(box.x + 70, 1000, 0, "Preloading Assets", 24, true);
		text.setFormat("Cave Story Regular", 70, FlxColor.WHITE, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
		text.visible = false;
		text.alpha = 0;
		text2 = new FlxText(icon.x + 100, 1000, 0, "Please wait...", 24, true);
		text2.setFormat("Cave Story Regular", 48, FlxColor.WHITE, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT, true);
		text2.visible = false;
		text2.alpha = 0;
		super.create();
		add(box);
		add(text);
		add(text2);
		add(icon);
		add(logo);
		add(FlixelLogo);

		icon.animation.play('Spin', false, false);
        
        
	}
#else
MusicBeatState.switchState(new FlashingState());
#end
}
