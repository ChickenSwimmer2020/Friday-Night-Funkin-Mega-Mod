package options;

import objects.Alphabet;

class MegaModOptions extends BaseOptionsMenu
{
	public function new()
	{
		title = 'MegaMod Options';
		// options	
		var option:Option = new Option('Show Furry Warning',
			'If unchecked, disables the Furry Warning Screen',
			'skipFurryWarn',
			'bool');
		addOption(option);
		
		var option:Option = new Option('Show Flash Warning',
			'If unchecked, disables the Flash Warning Screen',
			'skipFlashWarn',
			'bool',
		);
		addOption(option);

		var option:Option = new Option('Show Final Warning',
			'If unchecked, disables the Final Warning Screen',
			'skipFinalWarn',
			'bool');
		addOption(option);

		var option:Option = new Option('Show Intro Video',
		'If unchecked, disables the Intro Video',
		'skipIntroVideo',
		'bool'
		);
		addOption(option);
		

		//saved so i can easily make new slider options
		//var option:Option = new Option('Health Bar Opacity',
		//	'How much transparent should the health bar and icons be.',
		//	'healthBarAlpha',
		//	'percent');
		//option.scrollSpeed = 1.6;
		//option.minValue = 0.0;
		//option.maxValue = 1;
		//option.changeValue = 0.1;
		//option.decimals = 1;
		//addOption(option);
		super();
	}

	override function changeSelection(change:Int = 0)
	{
		super.changeSelection(change);
	}

	var changedMusic:Bool = false;
	function onChangePauseMusic()
	{
		if(ClientPrefs.data.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)));

		changedMusic = true;
	}

	override function destroy()
	{
		if(changedMusic && !OptionsState.onPlayState) FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
		super.destroy();
	}

	override function create()
	{
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Options", "Mega Mod");
		#end
	}
}
