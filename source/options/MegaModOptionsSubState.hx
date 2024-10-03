package options;

class MegaModOptionsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'MegaMod Options';

		var option:Option = new Option('Mechanics',
		'If checked, mechanics are enabled',
		'GamePlayMechanics',
		'bool'
		);
		addOption(option);

		var option:Option = new Option('Overlays',
		'If checked, overlays for the healthbar/timebar are enabled',
		'Overlays',
		'bool'
		);
		addOption(option);

		var option:Option = new Option('Additional song data files',
		'If Checked, additional song data files will be loaded',
		'AdditionalEffects',
		'bool'
		);
		addOption(option);

		////I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		//var option:Option = new Option('Downscroll', //Name
		//	'If checked, notes go Down instead of Up, simple enough.', //Description
		//	'downScroll', //Save data variable name
		//	'bool'); //Variable type
		//addOption(option);

		//var option:Option = new Option('Hitsound Volume',
		//	'Funny notes does \"Tick!\" when you hit them.',
		//	'hitsoundVolume',
		//	'percent');
		//addOption(option);
		//option.scrollSpeed = 1.6;
		//option.minValue = 0.0;
		//option.maxValue = 1;
		//option.changeValue = 0.1;
		//option.decimals = 1;
		//option.onChange = onChangeHitsoundVolume;

		//var option:Option = new Option('Rating Offset',
		//	'Changes how late/early you have to hit for a "Sick!"\nHigher values mean you have to hit later.',
		//	'ratingOffset',
		//	'int');
		//option.displayFormat = '%vms';
		//option.scrollSpeed = 20;
		//option.minValue = -30;
		//option.maxValue = 30;
		//addOption(option);

		super();
	}

	//function onChangeHitsoundVolume()
	//	FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.data.hitsoundVolume);

	//function onChangeAutoPause()
	//	FlxG.autoPause = ClientPrefs.data.autoPause;
	override function create()
		{
			#if DISCORD_ALLOWED
			DiscordClient.changePresence("Options", "MegaMod Option\'s");
			#end
			if(FlxG.sound.music != null)
				{
					FlxG.sound.music.stop();
					FlxG.sound.playMusic(Paths.music('Settings/SMFull'), 4);
				}
		}
}