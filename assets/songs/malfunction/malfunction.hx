var chrom:FlxRuntimeShader;
var tiltShift:FlxRuntimeShader;
var chromHUD:FlxRuntimeShader;

function opponentNoteHit()
{
  	if (PlayState.opponent.curCharacter == 'glitched-mickey-new-pixel')
	{
	if (!Init.trueSettings.get('Disable Screen Shaders'))
	{
		chrom = new FlxRuntimeShader(File.getContent('./assets/shaders/aberration.frag'), null, 150);
		chromHUD = new FlxRuntimeShader(File.getContent('./assets/shaders/aberrationLegacy.frag'), null, 150);
		tiltShift = new FlxRuntimeShader(File.getContent('./assets/shaders/tiltShift.frag'), null, 140);

		if (Init.trueSettings.get('Epilepsy Mode')) {
		PlayState.camGame.setFilters(
		[
  			new ShaderFilter(chrom),
			new ShaderFilter(chromHUD),
  			new ShaderFilter(tiltShift)
		]);

		PlayState.camHUD.setFilters(
		[
			new ShaderFilter(chromHUD),
			new ShaderFilter(tiltShift)
		]);

		for(hud in PlayState.strumHUD)
			hud.setFilters(
			[
				new ShaderFilter(chromHUD),
				new ShaderFilter(tiltShift)
			]);
		}
 
  		chrom.setFloat('aberration', 0.25);
  		chrom.setFloat('effectTime', 0.4);
		chromHUD.setFloat('rOfffset', 0.02);
		chromHUD.setFloat('bOffset', 0.02);
  		tiltShift.setFloat('bluramount', 6.0);
  
		// unoptimized asf, but it works
  		new FlxTimer().start(0.01, function(tmr:FlxTimer){
    			chrom.setFloat('aberration', 0.225);
	    		chrom.setFloat('effectTime', 0.35);
			chromHUD.setFloat('rOfffset', 0.015);
			chromHUD.setFloat('bOffset', 0.015);
    			tiltShift.setFloat('bluramount', 5);
  		});
		new FlxTimer().start(0.02, function(tmr:FlxTimer){
    			chrom.setFloat('aberration', 0.2);
    			chrom.setFloat('effectTime', 0.3);
			chromHUD.setFloat('rOfffset', 0.01);
			chromHUD.setFloat('bOffset', 0.01);
    			tiltShift.setFloat('bluramount', 4);
  		});
		new FlxTimer().start(0.03, function(tmr:FlxTimer){
    			chrom.setFloat('aberration', 0.175);
    			chrom.setFloat('effectTime', 0.25);
			chromHUD.setFloat('rOfffset', 0.005);
			chromHUD.setFloat('bOffset', 0.005);
    			tiltShift.setFloat('bluramount', 3);
  		});
		new FlxTimer().start(0.04, function(tmr:FlxTimer){
    			chrom.setFloat('aberration', 0.15);
    			chrom.setFloat('effectTime', 0.2);
    			tiltShift.setFloat('bluramount', 2);
  		});
		new FlxTimer().start(0.05, function(tmr:FlxTimer){
    			chrom.setFloat('aberration', 0.125);
    			chrom.setFloat('effectTime', 0.15);
    			tiltShift.setFloat('bluramount', 1);
  		});
		new FlxTimer().start(0.06, function(tmr:FlxTimer){
    			chrom.setFloat('aberration', 0.1);
    			chrom.setFloat('effectTime', 0.1);
    			tiltShift.setFloat('bluramount', 0.0);
			PlayState.camHUD.setFilters(
			[
				new ShaderFilter(chromHUD)
			]);
			for(hud in PlayState.strumHUD)
				hud.setFilters(
				[
						new ShaderFilter(chromHUD)
				]);
  		});
		new FlxTimer().start(0.07, function(tmr:FlxTimer){
    			chrom.setFloat('aberration', 0.1);
    			chrom.setFloat('effectTime', 0.1);
    			tiltShift.setFloat('bluramount', 0.0);
			PlayState.camHUD.setFilters(
			[
				new ShaderFilter(chromHUD)
			]);
			for(hud in PlayState.strumHUD)
				hud.setFilters(
				[
					new ShaderFilter(chromHUD)
				]);
  		});
		new FlxTimer().start(0.08, function(tmr:FlxTimer){
    			chrom.setFloat('aberration', 0.1);
    			chrom.setFloat('effectTime', 0.1);
    			tiltShift.setFloat('bluramount', 0.0);
			PlayState.camHUD.setFilters(
			[
				new ShaderFilter(chromHUD)
			]);
			for(hud in PlayState.strumHUD)
				hud.setFilters(
				[
					new ShaderFilter(chromHUD)
				]);
  		});
		new FlxTimer().start(0.09, function(tmr:FlxTimer){
    			chrom.setFloat('aberration', 0.1);
    			chrom.setFloat('effectTime', 0.1);
    			tiltShift.setFloat('bluramount', 0.0);
			PlayState.camHUD.setFilters(
			[
				new ShaderFilter(chromHUD)
			]);
			for(hud in PlayState.strumHUD)
				hud.setFilters(
				[
					new ShaderFilter(chromHUD)
				]);
  		});
	}
	}
}
