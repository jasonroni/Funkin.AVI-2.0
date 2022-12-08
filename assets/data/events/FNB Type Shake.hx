import flixel.util.FlxAxes;

function eventTrigger(params)
{
  switch(params[0]){
      case 'x':
        men(Intensity, Duration);
      case 'y':
        women(Intensity, Duration);
      case 'xy':
        manfuckingawoman(Intensity, Duration);
  }
}

function men(Intensity:Float, Duration:Float){
  FlxG.game.shake(Intensity, Duration, FlxAxes.X);
}
      
function women(Intensity:Float, Duration:Float){
  FlxG.game.shake(Intensity, Duration, FlxAxes.X);
}
      
function manfuckingawoman(Intensity:Float, Duration:Float){
  FlxG.game.shake(Intensity, Duration, FlxAxes.X);
}

function returnDescription()
	return
		"If you play FNB (YOU SHOULD) your familiar with the shake for some songs.\nValue 1: Intensity\nValue 2: Duriation";
