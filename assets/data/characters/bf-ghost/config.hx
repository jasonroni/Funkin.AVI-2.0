function loadAnimations()
{
	addByPrefix('idle', 'BlessBf idle', 24);
	addByPrefix('singUP', 'BlessBf up', 24, false);
	addByPrefix('singLEFT', 'BlessBf left', 24, false);
	addByPrefix('singRIGHT', 'BlessBf right', 24, false);
	addByPrefix('singDOWN', 'BlessBf down', 24, false);

	addOffset('idle', 0, 0);
	addOffset('singUP', -47, 28);
	addOffset('singLEFT', 60, 0);
	addOffset('singRIGHT', -48, -5);
	addOffset('singDOWN', 0, 70);

	playAnim('idle');

	characterData.antialiasing = true;
	characterData.flipX = true;

	setBarColor([49, 176, 209]);
	setCamOffsets(380, 580);
	setOffsets(0, 0);
	setGraphicSize(get('width') * 0.5);
}