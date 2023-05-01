function returnDescription()
    return "Changes the scroll speed mid-song";

function eventTrigger(params) {
    var val1 = params[0];
	if (Math.isNaN(val1) || val1 <= 0)
		val1 = 1;
	var val2 = params[1];
	if (Math.isNaN(val2) || val2 <= 0)
		val2 = 0;
	//
	var newValue:Float = PlayState.SONG.speed * val1;
	if (val2 <= 0)
		PlayState.main.songSpeed = newValue;
	else {
		PlayState.main.songSpeedTween = FlxTween.tween(PlayState.main, {songSpeed: newValue}, val2 * (Conductor.stepCrochet / 1000), {
            ease: FlxEase.linear,
            onComplete: function(twn:FlxTween) 
            {
                PlayState.main.songSpeedTween = null;
            }
        });
	}
	trace('changing scroll speed');
}
