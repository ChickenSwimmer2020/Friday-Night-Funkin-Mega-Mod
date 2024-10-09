package states;

import openfl.system.System;

class WarningsState extends MusicBeatState
{
	// arrayed offsets are surprisingly efficient on line space!
	var buttonOffsets:Array<Float>;
	var furryOffsets:Array<Float>;
	var flashOffsets:Array<Float>;

	// global thingys
	var CurWarning:String = null;

	// buttons images.
	var buttons:FlxSpriteGroup;
	var BACK:FlxSprite;
	var ENTER:FlxSprite;
	var SPACE:FlxSprite;
	var ESCAPE:FlxSprite;

	// flash warning images.
	var flash:FlxSpriteGroup;
	var flashscreen:FlxSprite;
	var flashwarnindicator:FlxSprite;
	var flashtext:FlxSpriteGroup;
	var flashtext1:FlxSprite;
	var flashtext2:FlxSprite;

	// furry warning images.
	var furry:FlxSpriteGroup;

	public var furbg:FlxSprite;
	public var furbf:FlxSprite;
	public var furwarnindicator:FlxSprite;

	var furtext:FlxSpriteGroup;

	public var furtext1:FlxSprite;
	public var furtext2:FlxSprite;

	override function create()
	{
		// global declarations
		// if(CurWarning == null) CurWarning = 'Flashing' tba
		if (CurWarning == null)
			CurWarning = 'Furry';
		buttonOffsets = new Array();
		// offset arrays are in standard X/Y format
		//               back      enter  esca     space     scale
		buttonOffsets = [280, 145, 0, 10, 80, 145, 210, 10, 0.5, 0.5];
		buttons = new FlxSpriteGroup(); // for quick loading and instant offsets
		BACK = new FlxSprite(buttonOffsets[0], buttonOffsets[1]);
		BACK.frames = Paths.getSparrowAtlas('Warnings/BACK');
		BACK.animation.addByPrefix('press', 'backspace_smash', 24, true);
		BACK.animation.play('press');
		BACK.scale.set(buttonOffsets[8], buttonOffsets[9]);
		BACK.updateHitbox();
		BACK.antialiasing = ClientPrefs.data.antialiasing;
		ENTER = new FlxSprite(buttonOffsets[2], buttonOffsets[3]);
		ENTER.frames = Paths.getSparrowAtlas('Warnings/ENTER');
		ENTER.animation.addByPrefix('press', 'enterbutton_smash', 24, true);
		ENTER.animation.play('press');
		ENTER.scale.set(buttonOffsets[8], buttonOffsets[9]);
		ENTER.updateHitbox();
		ENTER.antialiasing = ClientPrefs.data.antialiasing;
		ESCAPE = new FlxSprite(buttonOffsets[4], buttonOffsets[5]);
		ESCAPE.frames = Paths.getSparrowAtlas('Warnings/ESCAPE');
		ESCAPE.animation.addByPrefix('press', 'escapekey_smash', 24, true);
		ESCAPE.animation.play('press');
		ESCAPE.scale.set(buttonOffsets[8], buttonOffsets[9]);
		ESCAPE.updateHitbox();
		ESCAPE.antialiasing = ClientPrefs.data.antialiasing;
		SPACE = new FlxSprite(buttonOffsets[6], buttonOffsets[7]);
		SPACE.frames = Paths.getSparrowAtlas('Warnings/SPACE');
		SPACE.animation.addByPrefix('press', 'spacebar_smash', 24, true);
		SPACE.animation.play('press');
		SPACE.scale.set(buttonOffsets[8], buttonOffsets[9]);
		SPACE.updateHitbox();
		SPACE.antialiasing = ClientPrefs.data.antialiasing;
		buttons.add(BACK);
		buttons.add(ENTER);
		buttons.add(ESCAPE);
		buttons.add(SPACE);
		// furry items declarations
		furry = new FlxSpriteGroup();
		furtext = new FlxSpriteGroup();
		furryOffsets = new Array();
		//              txt1  txt2     bg
		furryOffsets = [0, 0, 0, 310, -160, -50];

		furbg = new FlxSprite(furryOffsets[4], furryOffsets[5]);
		furbg.frames = Paths.getSparrowAtlas('Warnings/FURRY_SEPERATOR');
		furbg.animation.addByPrefix('dastage', 'SEPERATOR_furry', 24, true);
		furbg.animation.play('dastage');
		furbg.antialiasing = ClientPrefs.data.antialiasing;
		furry.add(furbg);

		furtext1 = new FlxSprite(furryOffsets[0], furryOffsets[1]);
		furtext1.frames = Paths.getSparrowAtlas('Warnings/FURRY_TEXT1');
		furtext1.animation.addByPrefix('Shift', 'furrywarning_textOne', 24, true, false, false);
		furtext1.animation.play('Shift');
		furtext1.scale.set(0.5, 0.5);
		furtext1.updateHitbox();
		furtext1.antialiasing = ClientPrefs.data.antialiasing;
		furtext.add(furtext1);

		furtext2 = new FlxSprite(furryOffsets[2], furryOffsets[3]);
		furtext2.frames = Paths.getSparrowAtlas('Warnings/FURRY_TEXT2');
		furtext2.animation.addByPrefix('Shift', 'furrywarning_textTwo', 24, true, false, false);
		furtext2.animation.play('Shift');
		furtext2.scale.set(0.5, 0.5);
		furtext2.updateHitbox();
		furtext2.antialiasing = ClientPrefs.data.antialiasing;
		furtext.add(furtext2);

		// flash declarations
		flash = new FlxSpriteGroup();
		flashtext = new FlxSpriteGroup();
		flashtext.setPosition(-550, 0);
		flashOffsets = new Array();
		//              txt1  txt2     bg
		// originals    [0, 0, 0, 310, -160, -50];
		flashOffsets = [0, 0, 0, 310, /*-1000, -1000*/];

		// furbg = new FlxSprite(furryOffsets[4], furryOffsets[5]);
		// furbg.frames = Paths.getSparrowAtlas('Warnings/FURRY_SEPERATOR');
		// furbg.animation.addByPrefix('dastage', 'SEPERATOR_furry', 24, true);
		// furbg.animation.play('dastage');
		// furbg.antialiasing = ClientPrefs.data.antialiasing;
		// furry.add(furbg);

		flashtext1 = new FlxSprite(flashOffsets[0], flashOffsets[1]);
		flashtext1.frames = Paths.getSparrowAtlas('Warnings/FLASH_TEXT1');
		flashtext1.animation.addByPrefix('Shift', 'flashwarning_textOne', 24, true, false, false);
		flashtext1.animation.play('Shift');
		flashtext1.scale.set(0.5, 0.5);
		flashtext1.updateHitbox();
		flashtext1.antialiasing = ClientPrefs.data.antialiasing;
		flashtext.add(flashtext1);

		flashtext2 = new FlxSprite(flashOffsets[2], flashOffsets[3]);
		flashtext2.frames = Paths.getSparrowAtlas('Warnings/FLASH_TEXT2');
		flashtext2.animation.addByPrefix('Shift', 'flashwarning_textTwo', 24, true, false, false);
		flashtext2.animation.play('Shift');
		flashtext2.scale.set(0.5, 0.5);
		flashtext2.updateHitbox();
		flashtext2.antialiasing = ClientPrefs.data.antialiasing;
		flashtext.add(flashtext2);

		add(flash);
		add(flashtext);
		add(furry);
		add(furtext);
		add(buttons); // keep at bottom so it renders over everything
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		var back:Bool = controls.BACK;
		if (controls.ACCEPT || back && CurWarning == 'Furry')
		{
			if (!back)
			{
				furrygobyebye(0.5);
				Functions.wait(0.5, () ->
				{
					FlxTween.tween(flashtext, {x: 0}, 1, {
						ease: FlxEase.circOut,
						onComplete: function(huh:FlxTween)
						{
							trace('Flash Text Is Here');
						}
					});
					FlxTween.tween(buttons, {alpha: 1}, 1, {
						ease: FlxEase.linear,
						onComplete: function(huh:FlxTween)
						{
							trace('Buttons Are Back');
						}
					});
				});
				CurWarning == 'Flashing';
			}
			else
			{
				// BF.screenCenter();
				furry.visible = false;
				furtext.visible = false;
				buttons.visible = false;
				// WI.visible = false;
				new FlxTimer().start(1.83, function(tmr:FlxTimer)
				{
					CoolUtil.browserLoad('https://www.gamebanana.com/wips/79127');
					System.exit(0);
				});
			}
		}
		if (controls.ACCEPT && CurWarning == 'Flashing')
		{
			flashgobyebye(0.5);
			// henloflash(0.5);
			CurWarning == 'Final';
		}

		// if(CurWarning != null && CurWarning == 'Furry')
		//    {
		//
		//    }
	}

	public function furrygobyebye(speed:Float)
	{
		FlxTween.tween(furtext, {x: -550}, speed, {
			ease: FlxEase.circIn,
			onComplete: function(huh:FlxTween)
			{
				trace('Furry Text is Gone');
			}
		});
		FlxTween.tween(furbg, {y: 1000}, speed, {
			ease: FlxEase.circIn,
			onComplete: function(huh:FlxTween)
			{
				trace('BackGround is gone');
			}
		});
		FlxTween.tween(buttons, {alpha: 0}, speed, {
			ease: FlxEase.linear,
			onComplete: function(huh:FlxTween)
			{
				trace('Buttons Gone');
			}
		});
	}

	public function flashgobyebye(speed:Float)
	{
		FlxTween.tween(flashtext, {x: -550}, speed, {
			ease: FlxEase.circIn,
			onComplete: function(huh:FlxTween)
			{
				trace('Flash Text is Gone');
			}
		});
		// FlxTween.tween(furbg, {y: 1000}, speed, {
		//    ease: FlxEase.circIn,
		//    onComplete: function(huh:FlxTween)
		//    {
		//        trace('BackGround is gone');
		//    }
		// });
		FlxTween.tween(buttons, {alpha: 0}, speed, {
			ease: FlxEase.linear,
			onComplete: function(huh:FlxTween)
			{
				trace('Buttons Gone');
			}
		});
	}
}
