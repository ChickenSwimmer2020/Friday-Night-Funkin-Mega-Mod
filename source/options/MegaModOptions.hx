package options;

class MegaModOptions extends BaseOptionsMenu {
    public function new() {
        title = Language.getPhrase('megamod_options_menu', 'MegaMod Options');
		rpcTitle = 'MegaMod Options Menu';

        var option:Option = new Option('Mechanics',
		'If checked, mechanics are enabled',
		'GamePlayMechanics',
		BOOL);
		addOption(option);

		var option:Option = new Option('Overlays',
		'If checked, overlays for the healthbar/timebar are enabled',
		'Overlays',
		BOOL);
		addOption(option);

		var option:Option = new Option('Additional song data files',
		'If Checked, additional song data files will be loaded',
		'AdditionalEffects',
		BOOL);
		addOption(option);

		var option:Option = new Option('Show Combo Milestone',
		'If Checked, The combo milestone graphic from FNF will be activated',
		'showComboMilestone',
		BOOL);
		addOption(option);


        super();
    }
}