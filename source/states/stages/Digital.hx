package states.stages;

import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
import states.stages.objects.*;
import objects.Character;
import shaders.*;
import openfl.filters.BitmapFilter;

class Digital extends BaseStage
{

	public var Effect:BGSprite;

	public var stageCurtains:BGSprite;
	public var stageLight:BGSprite;
	public var stageFront:BGSprite;
	public var bg:BGSprite;
	public var CoolShader:OverlayShader = null;
	public var ShaderTrigger:Bool = false;

	override function create()
	{
		if(ClientPrefs.data.shaders) CoolShader = new OverlayShader();

		//reminder to sketch the bg ideas for implementation when art assets are created
		bg = new BGSprite('stageback', -600, -200, 0.9, 0.9);
		add(bg);
		stageFront = new BGSprite('stagefront', -650, 600, 0.9, 0.9);
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		stageFront.updateHitbox();
		add(stageFront);
		if(!ClientPrefs.data.lowQuality) {
			stageLight = new BGSprite('stage_light', -125, -100, 0.9, 0.9);
			stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
			stageLight.updateHitbox();
			add(stageLight);
			stageLight = new BGSprite('stage_light', 1225, -100, 0.9, 0.9);
			stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
			stageLight.updateHitbox();
			stageLight.flipX = true;
			add(stageLight);

			stageCurtains = new BGSprite('stagecurtains', -500, -300, 1.3, 1.3);
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			add(stageCurtains);
		}

	}
	override function eventPushed(event:objects.Note.EventNote)
	{
		switch(event.event)
		{
			case "Digital Bg Boom":
				Effect = new BGSprite('Effect', 0, 0, 0, 0, ['CoolBitBG'], false);
				Effect.scale.x = 1.5;
				Effect.scale.y = 1.5;
				Effect.screenCenter();
				Effect.visible = false;
				addBehindGF(Effect);
		}
	}

	override public function update(elapsed:Float)
		{
			super.update(elapsed);
			if(CRTShader != null && ShaderTrigger)
				{
					camGame.setFilters([new ShaderFilter(CoolShader)]);
				}
		}

	override function eventCalled(eventName:String, value1:String, value2:String, value3:String, flValue1:Null<Float>, flValue2:Null<Float>, flValue3:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
			case "Digital Bg Boom":
				if(flValue1 == null) flValue1 = 0;
				if(flValue2 == null) flValue2 = 0;
				if(value3 == null) value3 = 'Off';

				if(flValue1 == 0)
					{
						Effect.visible = false;
						gf.visible = true;
						dad.visible = true;
						stageLight.visible = true;
						stageCurtains.visible = true;
						bg.visible = true;
						stageFront.visible = true;
					}
				if(flValue1 == 1)
					{
						Effect.visible = true;
						gf.visible = false;
						dad.visible = false;
						stageFront.visible = false;
						stageCurtains.visible = false;
						stageLight.visible = false;
						bg.visible = false;
					}
				
				if(flValue2 == 1)
					{
						Effect.dance(true);
					}

				switch(value3.toLowerCase().trim()) {
					case 'On' | '1' | 'Yes':
						ShaderTrigger = true;
					case 'Off' | '0' | 'No':
						ShaderTrigger = false;
				}

		}
	}
}