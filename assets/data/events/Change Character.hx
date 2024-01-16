function loadedEventAction(params)
{
	switch (params[0])
	{
		case 'bf', 'boyfriend', 'player', '0':
			PlayState.playerMap.set(params[1], new Character(true).setCharacter(770, 450, params[1]));
		case 'gf', 'girlfriend', 'spectator', '2':
			PlayState.spectatorMap.set(params[1], new Character().setCharacter(300, 100, params[1]));
		default:
			PlayState.opponentMap.set(params[1], new Character().setCharacter(100, 100, params[1]));
	}
}

function eventTrigger(params)
{
	var changeTimer:FlxTimer;
	var timer:Float = Std.parseFloat(params[2]);
	if (Math.isNaN(timer))
		timer = 0;

	changeTimer = new FlxTimer().start(timer, function(tmr:FlxTimer)
	{
		switch (params[0])
		{
			case 'bf', 'boyfriend', 'player', '0':
				PlayState.boyfriend.setCharacter(770, 450, params[1]);
				if (Init.trueSettings.get('HUD Style') == 'classic' && PlayState.uiHUD != null && PlayState.uiHUD.exists) PlayState.uiHUD.iconP1.updateIcon(params[1], true);
				if (Init.trueSettings.get('HUD Style') == 'spectra' && PlayState.spectraHUD != null && PlayState.spectraHUD.exists) PlayState.spectraHUD.iconP1.updateIcon(params[1], true);
				if (Init.trueSettings.get('HUD Style') == 'psych' && PlayState.psychHUD != null && PlayState.psychHUD.exists) PlayState.psychHUD.iconP1.updateIcon(params[1], true);
				if (Init.trueSettings.get('HUD Style') == 'kade' && PlayState.kadeHUD != null && PlayState.kadeHUD.exists) PlayState.kadeHUD.iconP1.updateIcon(params[1], true);
				if (Init.trueSettings.get('HUD Style') == 'vanilla' && PlayState.vanillaHUD != null && PlayState.vanillaHUD.exists) PlayState.vanillaHUD.iconP1.updateIcon(params[1], true);
				if (PlayState.SONG.song == 'Cycled Sins') PlayState.cycledSinsHUD.iconP1.updateIcon(params[1], true);
				if (PlayState.SONG.song == 'Devilish Deal' || PlayState.SONG.song == 'Isolated' || PlayState.SONG.song == 'Lunacy' || PlayState.SONG.song == 'Delusional') PlayState.episode1HUD.iconP1.updateIcon(params[1], true);
				PlayState.boyfriend.dance(true);

				if (PlayState.playerMap.get(params[1]) != null)
					PlayState.playerMap.remove(params[1]);
			case 'gf', 'girlfriend', 'spectator', '2':
				PlayState.gf.setCharacter(300, 100, params[1]);
				PlayState.gf.dance(true);

				if (PlayState.spectatorMap.get(params[1]) != null)
					PlayState.spectatorMap.remove(params[1]);

			default:
				PlayState.opponent.setCharacter(100, 100, params[1]);
				if (Init.trueSettings.get('HUD Style') == 'classic' && PlayState.uiHUD != null && PlayState.uiHUD.exists) PlayState.uiHUD.iconP2.updateIcon(params[1], false);
				if (Init.trueSettings.get('HUD Style') == 'spectra' && PlayState.spectraHUD != null && PlayState.spectraHUD.exists) PlayState.spectraHUD.iconP2.updateIcon(params[1], false);
				if (Init.trueSettings.get('HUD Style') == 'psych' && PlayState.psychHUD != null && PlayState.psychHUD.exists) PlayState.psychHUD.iconP2.updateIcon(params[1], false);
				if (Init.trueSettings.get('HUD Style') == 'kade' && PlayState.kadeHUD != null && PlayState.kadeHUD.exists) PlayState.kadeHUD.iconP2.updateIcon(params[1], false);
				if (Init.trueSettings.get('HUD Style') == 'vanilla' && PlayState.vanillaHUD != null && PlayState.vanillaHUD.exists) PlayState.vanillaHUD.iconP2.updateIcon(params[1], false);
				if (PlayState.SONG.song == 'Cycled Sins') PlayState.cycledSinsHUD.iconP2.updateIcon(params[1], false);
				if (PlayState.SONG.song == 'Devilish Deal' || PlayState.SONG.song == 'Isolated' || PlayState.SONG.song == 'Lunacy' || PlayState.SONG.song == 'Delusional') PlayState.episode1HUD.iconP2.updateIcon(params[1], false);
				PlayState.opponent.dance(true);

				if (PlayState.opponentMap.get(params[1]) != null)
					PlayState.opponentMap.remove(params[1]);
		}
		if (Init.trueSettings.get('HUD Style') == 'classic' && PlayState.uiHUD != null && PlayState.uiHUD.exists) PlayState.uiHUD.reloadHealthBar();
		if (Init.trueSettings.get('HUD Style') == 'spectra' && PlayState.spectraHUD != null && PlayState.spectraHUD.exists) PlayState.spectraHUD.reloadHealthBar();
		if (Init.trueSettings.get('HUD Style') == 'psych' && PlayState.psychHUD != null && PlayState.psychHUD.exists) PlayState.psychHUD.reloadHealthBar();
		if (Init.trueSettings.get('HUD Style') == 'kade' && PlayState.kadeHUD != null && PlayState.kadeHUD.exists) PlayState.kadeHUD.reloadHealthBar();
		if (Init.trueSettings.get('HUD Style') == 'vanilla' && PlayState.vanillaHUD != null && PlayState.vanillaHUD.exists) PlayState.vanillaHUD.reloadHealthBar();
		if (PlayState.SONG.song == 'Cycled Sins') PlayState.cycledSinsHUD.reloadHealthBar();
		if (PlayState.SONG.song == 'Devilish Deal' || PlayState.SONG.song == 'Isolated' || PlayState.SONG.song == 'Lunacy' || PlayState.SONG.song == 'Delusional') PlayState.episode1HUD.reloadHealthBar();
		PlayState.stageBuild.repositionPlayers(PlayState.curStage, PlayState.boyfriend, PlayState.gf, PlayState.opponent, PlayState.opponentSecondary);
	});
}

function returnDescription()
	return
		"Sets the current Character to a new one\nValue 1: Character to change (dad, bf, gf, defaults to dad)\nValue 2: New character's name\nValue 3: Delay to Change Characters (in Milliseconds)";

function returnValue3()
	return true;
