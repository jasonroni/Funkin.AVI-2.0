function generateReceptor(receptor)
{
	// probably gonna revise this and make it possible to add other arrow types but for now it's just pixel and normal
	var stringSect:String = '';
	// call arrow type I think
	stringSect = Receptor.actions[receptorData];

	receptor.frames = Paths.getSparrowAtlas(EngineTools.returnSkinAsset('$framesArg', assetModifier, 'default',
		'$noteType/skins', 'data/notetypes'),
		'data/notetypes');

	receptor.animation.addByPrefix('static', 'arrow' + stringSect.toUpperCase());
	receptor.animation.addByPrefix('pressed', stringSect + ' press', 24, false);
	receptor.animation.addByPrefix('confirm', stringSect + ' confirm', 24, false);

	receptor.antialiasing = true;
	switch (PlayState.noteSkinType)
	{
		case 'VANILLA':
			receptor.setGraphicSize(Std.int(receptor.width * 0.7));
		default:
			if (receptor.strumData == 0)
				receptor.setGraphicSize(Std.int(receptor.width * 0.62));
			else
				receptor.setGraphicSize(Std.int(receptor.width * 0.6));
	}

	// set little offsets per note!
	// so these had a little problem honestly and they make me wanna off(set) myself so the middle notes basically
	// have slightly different offsets than the side notes (which have the same offset)

	var offsetMiddleX = 0;
	var offsetMiddleY = 0;
	if (receptorData > 0 && receptorData < 3)
	{
		offsetMiddleX = 2;
		offsetMiddleY = 2;
		if (receptorData == 1)
		{
			offsetMiddleX -= 1;
			offsetMiddleY += 2;
		}
	}

	switch (PlayState.noteSkinType)
	{
		case 'VANILLA':
			receptor.addOffset('static');
			receptor.addOffset('pressed', -2, -2);
			receptor.addOffset('confirm', 36 + offsetMiddleX, 36 + offsetMiddleY);
		case 'CARTOON':
			switch (receptor.strumData)
			{
				case 0:
					receptor.addOffset('confirm', 49 + offsetMiddleX, 36 + offsetMiddleY);
					receptor.addOffset('static', 11, -5);
					receptor.addOffset('pressed', 9, -7);
				case 1:
					receptor.addOffset('confirm', 42 + offsetMiddleX, 38 + offsetMiddleY);
					receptor.addOffset('static');
					receptor.addOffset('pressed', -4, -4);
				case 2:
					receptor.addOffset('confirm', 36 + offsetMiddleX, 40 + offsetMiddleY);
					receptor.addOffset('static');
					receptor.addOffset('pressed', -5, -4);
				case 3:
					receptor.addOffset('confirm', 36 + offsetMiddleX, 36 + offsetMiddleY);
					receptor.addOffset('static');
					receptor.addOffset('pressed', -4, -4);
			}
		case 'MERCY':
			switch (receptor.strumData)
			{
				case 0:
					receptor.addOffset('confirm', 49 + offsetMiddleX, 36 + offsetMiddleY);
					receptor.addOffset('static', 9, -5);
					receptor.addOffset('pressed', 11, -2);
				case 1:
					receptor.addOffset('confirm', 42 + offsetMiddleX, 36 + offsetMiddleY);
					receptor.addOffset('static');
					receptor.addOffset('pressed', 1, 1);
				case 2:
					receptor.addOffset('confirm', 36 + offsetMiddleX, 40 + offsetMiddleY);
					receptor.addOffset('static');
					receptor.addOffset('pressed', 1, 1);
				case 3:
					receptor.addOffset('confirm', 36 + offsetMiddleX, 36 + offsetMiddleY);
					receptor.addOffset('static');
					receptor.addOffset('pressed', 1, 1);
			}
		default:
			switch (receptor.strumData)
			{
				case 0:
					receptor.addOffset('confirm', 49 + offsetMiddleX, 36 + offsetMiddleY);
					receptor.addOffset('static', 9, -5);
					receptor.addOffset('pressed', 6, -7);
				case 1:
					receptor.addOffset('confirm', 42 + offsetMiddleX, 36 + offsetMiddleY);
					receptor.addOffset('static');
					receptor.addOffset('pressed', -4, -4);
				case 2:
					receptor.addOffset('confirm', 36 + offsetMiddleX, 40 + offsetMiddleY);
					receptor.addOffset('static');
					receptor.addOffset('pressed', -5, -4);
				case 3:
					receptor.addOffset('confirm', 36 + offsetMiddleX, 36 + offsetMiddleY);
					receptor.addOffset('static');
					receptor.addOffset('pressed', -4, -4);
			}
	}
	receptor.playAnim('static');
}

var scaleShit:Float = 0.7;

function generateNote(newNote)
{
	var stringSect = Receptor.colors[newNote.noteData];
	var dirSect = Receptor.actions[newNote.noteData];

		switch (PlayState.noteSkinType)
		{
			case 'VANILLA':
				scaleShit = 0.7;
			default:
				scaleShit = 0.63;
		}

		newNote.frames = Paths.getSparrowAtlas(getSkinPath('NOTE_assets-' + PlayState.noteSkinType, 'default'), 'data/notetypes');
		newNote.animation.addByPrefix(stringSect + 'Scroll', stringSect + '0');
		newNote.playAnim(stringSect + 'Scroll');

	newNote.setGraphicSize(Std.int(newNote.width * scaleShit));
	newNote.antialiasing = true;
	newNote.updateHitbox();
}

function generateSustain(newNote)
{
	var stringSect = Receptor.colors[newNote.noteData];

	switch (PlayState.noteSkinType)
		{
			case 'VANILLA':
				scaleShit = 0.7;
			default:
				scaleShit = 0.63;
		}

		newNote.frames = Paths.getSparrowAtlas(getSkinPath('NOTE_assets-' + PlayState.noteSkinType, 'default'), 'data/notetypes');
		newNote.animation.addByPrefix(stringSect + 'holdend', stringSect + ' hold end');
		newNote.animation.addByPrefix(stringSect + 'hold', stringSect + ' hold piece');
		newNote.animation.addByPrefix('purpleholdend', 'pruple end hold'); // PA god dammit.
		newNote.setGraphicSize(Std.int(newNote.width * scaleShit));

		newNote.playAnim(stringSect + 'holdend');
		if (newNote.prevNote != null && newNote.prevNote.isSustainNote)
			newNote.prevNote.playAnim(stringSect + 'hold');

	newNote.antialiasing = true;
	newNote.updateHitbox();
}

function generateSplash(noteSplash, noteData)
{
	if (Init.trueSettings.get("UI Skin") == "forever")
	{
		noteSplash.loadGraphic(Paths.image(getSkinPath('noteSplashes', 'default'), 'data/notetypes'), true, 210, 210);
		noteSplash.animation.add('anim1', [
			(noteData * 2 + 1),
			8 + (noteData * 2 + 1),
			16 + (noteData * 2 + 1),
			24 + (noteData * 2 + 1),
			32 + (noteData * 2 + 1)
		], 24, false);
		noteSplash.animation.add('anim2', [
			(noteData * 2),
			8 + (noteData * 2),
			16 + (noteData * 2),
			24 + (noteData * 2),
			32 + (noteData * 2)
		], 24, false);

		noteSplash.addOffset('anim1', 25, 25);
		noteSplash.addOffset('anim2', 25, 25);
	}
	else
	{
		noteSplash.frames = Paths.getSparrowAtlas(getSkinPath('noteSplashesOG', 'default'), 'data/notetypes');
		noteSplash.animation.addByPrefix('anim1', 'note impact 1 ' + Receptor.colors[noteData], 24, false);
		noteSplash.animation.addByPrefix('anim2', 'note impact 2 ' + Receptor.colors[noteData], 24, false);
		noteSplash.animation.addByPrefix('anim1', 'note impact 1  blue', 24, false); // HE DID IT AGAIN EVERYONE;

		noteSplash.addOffset('anim1', 65, 60);
		noteSplash.addOffset('anim2', 65, 60);
		noteSplash.updateHitbox();
	}

	noteSplash.playAnim('anim' + FlxG.random.int(1, 2));
	noteSplash.alpha = Init.trueSettings.get("Splash Opacity") * 0.01;
}

function getSkinPath(skin:String, path:String):String
{
	var noteSkin = Init.trueSettings.get("Note Skin");
	return EngineTools.returnSkinAsset(skin, 'base', noteSkin, 'default/skins', path);
}
