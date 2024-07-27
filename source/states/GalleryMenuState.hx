package states;

import lime.app.Application;

import flixel.input.keyboard.FlxKey;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.FlxSubState;

import haxe.Json;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

typedef GalDat = 
{
	BackgroundX:Float,
	BackgroundY:Float,
	Spacer1:String,
	LeftArrowX:Float,
	LeftArrowY:Float,
	Spacer2:String,
	RightArrowX:Float,
	RightArrowY:Float,
	Spacer3:String,
	Galone:String,
	Spacer4:String,
	GaloneDesc:String,
}
//spacers exist to help with json organization

class GalleryMenuState extends MusicBeatState
{	
	var desctext:FlxText;
	//extruded since theres a lot of these. I NEED TO LEARN TO USE ARRAYS :sob:
	//	var image:FlxSprite;
	//var moverL:FlxSprite;
	//var moverR:FlxSprite;
	var BackSpace:FlxSprite;
	var Background:FlxSprite;
	var GalleryData:GalDat;

	var Selected:Bool = false;
	var NotSelected:Bool = true;
	var Pressed:Bool = false;



	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Gallery", "HEAVY W.I.P DEBUG ENABLED");
		#end

		GalleryData = tjson.TJSON.parse(Paths.getTextFromFile('data/Gallery/GalleryData.json'));
				//		moverL = new FlxSprite(0, 0);
				//		moverL.antialiasing = ClientPrefs.data.antialiasing;
				//		moverL.frames = Paths.getSparrowAtlas('Gallery/UI/ArrowLeft');
				//		moverL.animation.addByPrefix('idle', 'sitonyourassjohn');
				//		moverL.animation.addByPrefix('idle_selected', 'standupjohn');
				//		moverL.animation.addByPrefix('kaboom', 'prankemjohn');
				//		moverL.animation.play('idle');

				//		moverR = new FlxSprite(0, 0);
				//		moverR.antialiasing = ClientPrefs.data.antialiasing;
				//		moverR.frames = Paths.getSparrowAtlas('Gallery/UI/ArrowRight');
				//		moverR.animation.addByPrefix('idle', 'sitonyourassjohn');
				//		moverR.animation.addByPrefix('idle_selected', 'standupjohn');
				//		moverR.animation.addByPrefix('kaboom', 'prankemjohn');
				//		moverR.animation.play('idle');

						BackSpace = new FlxSprite(0, 0);
						BackSpace.screenCenter(X);
						BackSpace.screenCenter(Y);
						BackSpace.antialiasing = ClientPrefs.data.antialiasing;
						BackSpace.frames = Paths.getSparrowAtlas('Gallery/UI/backspace');
						BackSpace.animation.addByPrefix('idle', 'backspacetoexit', 24, true);
						BackSpace.animation.addByPrefix('idle_select', 'backspacetoexitwhite', 24, true);
						BackSpace.animation.addByPrefix('pressed', 'backspacePRESSED', 24, true);
						BackSpace.animation.play('idle', true, false, 24);

				//		desctext = new FlxText(0, 0, FlxG.width, "description test!");
				//		//desctext = GalleryData.image1Desc;
				//	menu_UI.add('desctext');
				//UI CODE END
		Background = new FlxSprite(GalleryData.BackgroundX, GalleryData.BackgroundY).loadGraphic(Paths.image('Gallery/UI/Background'));
		Background.scale.x = 1;
		Background.scale.y = 1;
		Background.antialiasing = ClientPrefs.data.antialiasing;

		add(Background);
		add(BackSpace);
		//	add(moverR);
		//	add(moverL);
	}
	override function update(elapsed:Float)
	{
			//SPAGHETTI!!!!!!!!!!
		//Mouse Dectection
			if(FlxG.mouse.overlaps(BackSpace))
			{
					Selected = true;
					NotSelected = false;
					//trace("mouse is over the backspace button");
			}
			else{
					Selected = false;
					NotSelected = true;
					//trace("mouse is no longer over the backspace button");
			}
		//Activates the pressed function
			if(FlxG.mouse.overlaps(BackSpace) && FlxG.mouse.justReleased)
			{
				Selected = false;
				NotSelected = true;
				Pressed = true;
			}
		//Same as last one, but works with backspace and no mouse, made for the keyboard only plebs
			if(controls.BACK)
			{
				Selected = false;
				NotSelected = true;
				Pressed = true;
			}
		//Plays the selected idle when its selected
			if(Selected == true && NotSelected == false)
			{
				BackSpace.animation.play('idle_select', true, false, 0);
			}
		//Plays the normal idle when its not selected
			if(Selected == false && NotSelected == true)
			{
				BackSpace.animation.play('idle', true, false, 0);
			}
		//The pressed function from earlier
			if(Pressed == true)
			{
				MusicBeatState.switchState(new MainMenuState());
				FlxG.sound.play(Paths.sound('cancelMenu'));
				BackSpace.animation.play('pressed', true, false, 0);
			}
	};
}