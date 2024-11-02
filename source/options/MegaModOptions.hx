package options;

class MegaModOptions extends BaseOptionsMenu {
    public function new() {
        super();
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
    }
}