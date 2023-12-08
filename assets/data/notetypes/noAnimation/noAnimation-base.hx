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
	newNote.noAnim = true;
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
	newNote.noAnim = true;
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
