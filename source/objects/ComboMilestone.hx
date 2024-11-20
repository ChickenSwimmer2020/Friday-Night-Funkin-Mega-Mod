package objects;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class ComboMilestone extends FlxTypedSpriteGroup<FlxSprite>
{
  var effectStuff:FlxSprite;

  var wasComboSetup:Bool = false;
  var daCombo:Int = 0;

  var grpNumbers:FlxTypedGroup<ComboMilestoneNumber>;

  var onScreenTime:Float = 0;

  public function new(x:Float, y:Float, daCombo:Int = 0)
  {
    super(x, y);

    this.daCombo = daCombo;
    
    effectStuff = new FlxSprite(0, 0);
    effectStuff.frames = Paths.getSparrowAtlas('comboMilestone');
    //effectStuff.animation.addByPrefix('funny', 'NOTE COMBO animation', 24, false);
    //effectStuff.animation.addByPrefix('ByeBye', 'NOTE COMBO leaving', 24, false);
    effectStuff.animation.addByIndices('funny', 'NOTE COMBO animation', [for(i in 0...18) i], "", 24, false, false, false);
    effectStuff.animation.addByIndices('ByeBye', 'NOTE COMBO animation', [19, 20, 21], "", 24, false, false, false);
    effectStuff.animation.play('funny');
    effectStuff.animation.finishCallback = function(nameThing) {
      kill();
    };
    effectStuff.setGraphicSize(Std.int(effectStuff.width * 0.7));
    effectStuff.antialiasing = ClientPrefs.data.antialiasing;
    effectStuff.scale.set(1.01,1.01);
    effectStuff.updateHitbox();
    add(effectStuff);

    grpNumbers = new FlxTypedGroup<ComboMilestoneNumber>();
    //add(grpNumbers);
  }

  override function update(elapsed:Float)
  {
    onScreenTime += elapsed;

    if (effectStuff.animation.curAnim.curFrame == 17) effectStuff.animation.play('ByeBye');
    effectStuff.animation.finishCallback = function(BroWhat) {
        kill();
    }

    if (effectStuff.animation.curAnim.curFrame == 2 && !wasComboSetup)
    {
      setupCombo(daCombo);
    }

    if (effectStuff.animation.curAnim.curFrame == 18)
    {
      grpNumbers.forEach(function(spr:ComboMilestoneNumber) {
        spr.animation.reset();
      });
    }

    if (effectStuff.animation.curAnim.curFrame == 20)
    {
      grpNumbers.forEach(function(spr:ComboMilestoneNumber) {
        spr.kill();
      });
    }

    super.update(elapsed);
  }

  function setupCombo(daCombo:Int)
  {
    FlxG.sound.play(Paths.sound('comboSound'));

    wasComboSetup = true;
    var loopNum:Int = 0;

    while (daCombo > 0)
    {
      var comboNumber:ComboMilestoneNumber = new ComboMilestoneNumber(450 - (100 * loopNum), 20 + 14 * loopNum, daCombo % 10);
      comboNumber.setGraphicSize(Std.int(comboNumber.width * 0.7));
      grpNumbers.add(comboNumber);
      comboNumber.antialiasing = ClientPrefs.data.antialiasing;
      add(comboNumber);

      loopNum += 1;

      daCombo = Math.floor(daCombo / 10);
    }
  }
}

class ComboMilestoneNumber extends FlxSprite
{
  public function new(x:Float, y:Float, digit:Int)
  {
    super(x - 20, y);

    var stringNum:String = Std.string(digit);
    frames = Paths.getSparrowAtlas('comboMilestoneNumbers');
    animation.addByPrefix(stringNum, stringNum, 24, false);
    animation.play(stringNum);
    updateHitbox();
  }

  var shiftedX:Bool = false;

  override function update(elapsed:Float)
  {
    if (animation.curAnim.curFrame == 2 && !shiftedX)
    {
      shiftedX = true;
      x += 20;
    }

    super.update(elapsed);
  }
}