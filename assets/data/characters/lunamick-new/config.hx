function loadAnimations()
{
	addByPrefix('idle', 'Mickey2 Idle', 24);

	addByPrefix('singUP', 'Mickey2 Up', 24, false);
	addByPrefix('singLEFT', 'Mickey2 Left', 24, false);
	addByPrefix('singRIGHT', 'Mickey2 Right', 24, false);
	addByPrefix('singDOWN', 'Mickey2 Down', 24, false);

	addOffset('idle', -5, 0);

	addOffset('singUP', 0, 50);
	addOffset('singLEFT', -18, 50);
	addOffset('singRIGHT', 0, 60);
	addOffset('singDOWN', 10, 52);

	playAnim('idle');

	characterData.antialiasing = true;
	characterData.flipX = false;

	setBarColor([49, 176, 209]);
	setCamOffsets(420, 370);
    setOffsets(-690, 2000);
	setGraphicSize(get('width') * 0.6);
}