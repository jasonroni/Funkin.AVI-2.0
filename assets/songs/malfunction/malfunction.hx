var chrom:FlxRuntimeShader;
var tiltShift:FlxRuntimeShader;

function opponentNoteHit()
{
  	if (PlayState.health > 0.05)
    		PlayState.health -= 0.036;

	chrom = new FlxRuntimeShader(File.getContent('./assets/shaders/aberration.frag'), null, 150);
	tiltShift = new FlxRuntimeShader(File.getContent('./assets/shaders/tiltShift.frag'), null, 140);

	PlayState.camGame.setFilters(
	[
  		new ShaderFilter(chrom),
  		new ShaderFilter(tiltShift)
	]);
  
  	chrom.setFloat('aberration', 0.25);
  	chrom.setFloat('effectTime', 0.4);
  	tiltShift.setFloat('bluramount', 6);
  
	// okay, this is better, but it's still broken :/
  	new FlxTimer().start(0.01, function(tmr:FlxTimer){
    		chrom.setFloat('aberration', 0.225);
    		chrom.setFloat('effectTime', 0.35);
    		tiltShift.setFloat('bluramount', 5);
  	});
	new FlxTimer().start(0.02, function(tmr:FlxTimer){
    		chrom.setFloat('aberration', 0.2);
    		chrom.setFloat('effectTime', 0.3);
    		tiltShift.setFloat('bluramount', 4);
  	});
	new FlxTimer().start(0.03, function(tmr:FlxTimer){
    		chrom.setFloat('aberration', 0.175);
    		chrom.setFloat('effectTime', 0.25);
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
    		tiltShift.setFloat('bluramount', 0.001);
  	});
}
