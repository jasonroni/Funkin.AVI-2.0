function opponentNoteHit()
{
  	if (PlayState.health > 0.05)
    		PlayState.health -= 0.036;

	  var chrom:FlxRuntimeShader = new FlxRuntimeShader(File.getContent('./assets/shaders/aberration.frag'), null, 150);
	  var tiltShift:FlxRuntimeShader = new FlxRuntimeShader(File.getContent('./assets/shaders/tiltShift.frag'), null, 140));

	  PlayState.camGame.setFilters(
	  [
  		  new ShaderFilter(chrom),
  		  new ShaderFilter(tiltShift)
	  ]);
  
    // TODO: add a function that smooths out the shaders  
  	chrom.setFloat('aberration', 0.25);
  	chrom.setFloat('effectTime', 0.4);
  	tiltShift.setFloat('bluramount', 6);
  
  	new FlxTimer().start(0.02, function(tmr:FlxTimer){
    		chrom.setFloat('aberration', 0.07);
    		chrom.setFloat('effectTime', 0.2);
    		tiltShift.setFloat('bluramount', 0.001);
  	});
}
