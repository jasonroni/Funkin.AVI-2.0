function generateNote(newNote)
{
	if (Init.trueSettings.get('Disable Mechanics'))
	{
		var stringSect = Receptor.colors[newNote.noteData];
		var dirSect = Receptor.actions[newNote.noteData];

		if (StringTools.startsWith(Init.trueSettings.get("Note Skin"), "quant"))
		{
			newNote.determineQuantIndex(newNote.strumTime, newNote);

			//
			newNote.loadGraphic(Paths.image("default/skins/quant/base/NOTE_quants", 'data/notetypes'), true, 157, 157);
			newNote.animation.add('leftScroll', [0 + (newNote.noteQuant * 4)]);
			// LOL downscroll thats so funny to me
			newNote.animation.add('downScroll', [1 + (newNote.noteQuant * 4)]);
			newNote.animation.add('upScroll', [2 + (newNote.noteQuant * 4)]);
			newNote.animation.add('rightScroll', [3 + (newNote.noteQuant * 4)]);
			newNote.playAnim(dirSect + 'Scroll');
		}
		else
		{
			newNote.frames = Paths.getSparrowAtlas(getSkinPath('NOTE_assets', 'default'), 'data/notetypes');
			newNote.animation.addByPrefix(stringSect + 'Scroll', stringSect + '0');
			newNote.playAnim(stringSect + 'Scroll');
		}

		newNote.setGraphicSize(Std.int(newNote.width * 0.7));
		newNote.antialiasing = true;
		newNote.updateHitbox();
	}
	else
	{
		var stringSect = Receptor.colors[newNote.noteData];
		var dirSect = Receptor.actions[newNote.noteData];
	
		newNote.frames = Paths.getSparrowAtlas('KILLNOTE_assets', 'data/notetypes/instakill/skins/base');
		newNote.animation.addByPrefix(stringSect + 'Scroll', stringSect + '0');
		newNote.playAnim(stringSect + 'Scroll');

		newNote.noteSuffix = "miss";
		newNote.ignoreNote = true;

		newNote.setGraphicSize(Std.int(newNote.width * 2.3));
		newNote.antialiasing = true;
		newNote.updateHitbox();
	}
}

function generateSplash(splashNote, noteData)
{
	if (Init.trueSettings.get('Disable Mechanics'))
	{
		splashNote.kill();
	}
	else
	{
		splashNote.frames = Paths.getSparrowAtlas('KILLnoteSplashes', 'data/notetypes/instakill/skins/base');
		splashNote.animation.addByPrefix('anim1', 'note splash ' + Receptor.colors[noteData] + ' 1', 24, false);
		splashNote.animation.addByPrefix('anim2', 'note splash ' + Receptor.colors[noteData] + ' 2', 24, false);

		splashNote.addOffset('anim1', 65, 60);
		splashNote.addOffset('anim2', 65, 60);
		splashNote.updateHitbox();

		splashNote.playAnim('anim' + FlxG.random.int(1, 2));
		splashNote.alpha = Init.trueSettings.get("Splash Opacity") * 0.01;
	}
}

function generateSustain(newNote)
{
	if (Init.trueSettings.get('Disable Mechanics'))
	{
		var stringSect = Receptor.colors[newNote.noteData];
		var dirSect = Receptor.actions[newNote.noteData];

		if (StringTools.startsWith(Init.trueSettings.get("Note Skin"), "quant"))
		{
			newNote.determineQuantIndex(newNote.strumTime, newNote);

			//
			newNote.loadGraphic(Paths.image("default/skins/quant/base/NOTE_quants", 'data/notetypes'), true, 157, 157);
			newNote.animation.add('leftScroll', [0 + (newNote.noteQuant * 4)]);
			// LOL downscroll thats so funny to me
			newNote.animation.add('downScroll', [1 + (newNote.noteQuant * 4)]);
			newNote.animation.add('upScroll', [2 + (newNote.noteQuant * 4)]);
			newNote.animation.add('rightScroll', [3 + (newNote.noteQuant * 4)]);
			newNote.playAnim(dirSect + 'Scroll');
		}
		else
		{
			newNote.frames = Paths.getSparrowAtlas(getSkinPath('NOTE_assets', 'default'), 'data/notetypes');
			newNote.animation.addByPrefix(stringSect + 'Scroll', stringSect + '0');
			newNote.playAnim(stringSect + 'Scroll');
		}

		newNote.setGraphicSize(Std.int(newNote.width * 0.7));
		newNote.antialiasing = true;
		newNote.updateHitbox();
	}
	else
	{
		var stringSect = Receptor.colors[newNote.noteData];

		newNote.frames = Paths.getSparrowAtlas('KILLNOTE_assets', 'data/notetypes/instakill/skins/base');
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
}

function onStep(newNote, curStep:Int)
{
	if (Init.trueSettings.get('Disable Mechanics'))
	{
		if (newNote.mustPress)
		{
			newNote.kill();
		}
	}
}

function onHit(newNote)
{
	if (!Init.trueSettings.get('Disable Mechanics'))
	{
		if (!newNote.canBeHit)
		{
			PlayState.health -= 0;
		}
		else
		{
			PlayState.health -= 5000; // there ain't no way you surviving this lmfao
		}
	}
}
