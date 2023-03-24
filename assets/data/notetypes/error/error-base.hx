function generateNote(newNote)
{
	var stringSect = Receptor.colors[newNote.noteData];
	var dirSect = Receptor.actions[newNote.noteData];
	
	newNote.frames = Paths.getSparrowAtlas('ERRORNOTE_assets', 'data/notetypes/error/skins/base');
	newNote.animation.addByPrefix(stringSect + 'Scroll', stringSect + '0');
	newNote.playAnim(stringSect + 'Scroll');

	newNote.noteSuffix = "miss";
	newNote.ignoreNote = true;

	newNote.setGraphicSize(Std.int(newNote.width * 2.3));
	newNote.antialiasing = true;
	newNote.updateHitbox();
}

function generateSplash(splashNote, noteData)
	splashNote.kill();

function generateSustain(newNote)
{
	var stringSect = Receptor.colors[newNote.noteData];

	newNote.frames = Paths.getSparrowAtlas('ERRORNOTE_assets', 'data/notetypes/error/skins/base');
	newNote.animation.addByPrefix(stringSect + 'holdend', stringSect + ' hold end');
	newNote.animation.addByPrefix(stringSect + 'hold', stringSect + ' hold piece');
	newNote.animation.addByPrefix('purpleholdend', 'pruple end hold'); // PA god dammit.
	newNote.setGraphicSize(Std.int(newNote.width * 0.8));

	newNote.playAnim(stringSect + 'holdend');
	if (newNote.prevNote != null && newNote.prevNote.isSustainNote)
		newNote.prevNote.playAnim(stringSect + 'hold');

	newNote.noteSuffix = "miss";
	newNote.ignoreNote = true;

	newNote.antialiasing = true;
	newNote.updateHitbox();
}

function onHit(newNote)
{
	PlayState.health -= 0.012;
	//game.updateMalfunctionLives();
}
