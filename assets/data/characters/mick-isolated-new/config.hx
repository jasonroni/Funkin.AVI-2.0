function loadAnimations()
	{
		setFrames("mick-isolated-new", "images/characters");
		addByPrefix('idle', 'idle', 9, false);
		addByPrefix('singLEFT', 'left', 9, false);
		addByPrefix('singDOWN', 'down', 9, false);
		addByPrefix('singUP', 'up', 9, false);
		addByPrefix('singRIGHT', 'right', 9, false);
	
		if (!isPlayer)
		{
			addOffset("idle", 0, 0);
			addOffset("singLEFT", 22, 0);
			addOffset("singDOWN", 17, 0);
			addOffset("singUP", 8, 0);
			addOffset("singRIGHT", 50, 0);
			characterData.camOffsets = [90, 60];
			characterData.offsets = [0, -350];
		}
	
		playAnim('idle');
	}
	