import flixel.util.FlxAxes;

function eventTrigger(params)
{
  FlxG.game.shake(params[0], params[1], FlxAxes.X);
}

function returnDescription()
	return
		"If you play FNB (YOU SHOULD) your familiar with the shake for some songs.\nValue 1: Intensity\nValue 2: Duriation";
