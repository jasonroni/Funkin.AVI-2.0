var chromHUD:FlxRuntimeShader;

function opponentNoteHit()
{
  	if (PlayState.health > 0.05)
    		PlayState.health -= 0.02;

	chromHUD = new FlxRuntimeShader(File.getContent('./assets/shaders/aberrationLegacy.frag'), null, 150);

	PlayState.camGame.setFilters(
	[
		new ShaderFilter(chromHUD)
	]);

	PlayState.camHUD.setFilters(
	[
		new ShaderFilter(chromHUD)
	]);

	for(hud in PlayState.strumHUD)
		hud.setFilters(
		[
			new ShaderFilter(chromHUD)
		]);
  
	chromHUD.setFloat('rOfffset', 0.02);
	chromHUD.setFloat('bOffset', 0.02);
  
	// unoptimized asf, but it works
  	new FlxTimer().start(0.01, function(tmr:FlxTimer){
        chromHUD.setFloat('rOfffset', 0.015);
        chromHUD.setFloat('bOffset', 0.015);
  	});
	new FlxTimer().start(0.02, function(tmr:FlxTimer){
        chromHUD.setFloat('rOfffset', 0.01);
        chromHUD.setFloat('bOffset', 0.01);
  	});
	new FlxTimer().start(0.03, function(tmr:FlxTimer){
        chromHUD.setFloat('rOfffset', 0.005);
        chromHUD.setFloat('bOffset', 0.005);
  	});
}
