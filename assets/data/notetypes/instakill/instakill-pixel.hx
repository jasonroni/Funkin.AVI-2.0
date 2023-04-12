function generateNote(newNote)
{
	if (Init.trueSettings.get('Disable Mechanics'))
	{
		var pixelData:Array<Int> = [4, 5, 6, 7];

		if (StringTools.startsWith(Init.trueSettings.get("Note Skin"), "quant"))
		{
			newNote.determineQuantIndex(newNote.strumTime, newNote);

			//
			newNote.loadGraphic(Paths.image("default/skins/quant/pixel/NOTE_quants", 'data/notetypes'), true, 17, 17);
			newNote.animation.add('leftScroll', [0 + (newNote.noteQuant * 4)]);
			// LOL downscroll thats so funny to me
			newNote.animation.add('downScroll', [1 + (newNote.noteQuant * 4)]);
			newNote.animation.add('upScroll', [2 + (newNote.noteQuant * 4)]);
			newNote.animation.add('rightScroll', [3 + (newNote.noteQuant * 4)]);
			newNote.playAnim(Receptor.actions[newNote.noteData] + 'Scroll');
		}
		else
		{
			newNote.loadGraphic(Paths.image("default/skins/default/pixel/NOTE_assets", 'data/notetypes'), true, 17, 17);
			newNote.animation.add(Receptor.colors[newNote.noteData] + 'Scroll', [pixelData[newNote.noteData]], 12);
			newNote.animation.play(Receptor.colors[newNote.noteData] + 'Scroll');
		}

		newNote.setGraphicSize(Std.int(newNote.width * PlayState.daPixelZoom));
		newNote.antialiasing = false;
		newNote.updateHitbox();
	}
	else
	{
		var pixelData:Array<Int> = [4, 5, 6, 7];

		newNote.loadGraphic(Paths.image("instakill/skins/pixel/KILLNOTE_assets", 'data/notetypes'), true, 17, 17);
		newNote.animation.add(Receptor.colors[newNote.noteData] + 'Scroll', [pixelData[newNote.noteData]], 12);
		newNote.animation.play(Receptor.colors[newNote.noteData] + 'Scroll');

		newNote.noteSuffix = "miss";
		newNote.ignoreNote = true;

		newNote.setGraphicSize(Std.int(newNote.width * PlayState.daPixelZoom));
		newNote.antialiasing = false;
		newNote.updateHitbox();
	}
}

function generateSplash(splashNote, noteData)
	splashNote.kill();

function generateSustain(newNote)
{
	if (Init.trueSettings.get('Disable Mechanics'))
	{
		var pixelData:Array<Int> = [4, 5, 6, 7];

		if (StringTools.startsWith(Init.trueSettings.get("Note Skin"), "quant"))
		{
			newNote.determineQuantIndex(newNote.strumTime, newNote);
			newNote.holdHeight = 0.862;

			//
			newNote.loadGraphic(Paths.image("default/skins/quant/pixel/HOLD_quants", 'data/notetypes'), true, 17, 6);
			newNote.animation.add('hold', [0 + (newNote.noteQuant * 4)]);
			newNote.animation.add('holdend', [1 + (newNote.noteQuant * 4)]);
			newNote.animation.add('rollhold', [2 + (newNote.noteQuant * 4)]);
			newNote.animation.add('rollend', [3 + (newNote.noteQuant * 4)]);

			newNote.playAnim('holdend');
			if (newNote.prevNote != null && newNote.prevNote.isSustainNote)
				newNote.prevNote.playAnim('hold');
		}
		else
		{
			newNote.loadGraphic(Paths.image("default/skins/default/pixel/HOLD_assets", 'data/notetypes'), true, 7, 6);
			newNote.animation.add(Receptor.colors[newNote.noteData] + 'holdend', [pixelData[newNote.noteData]]);
			newNote.animation.add(Receptor.colors[newNote.noteData] + 'hold', [pixelData[newNote.noteData] - 4]);
			newNote.animation.play(Receptor.colors[newNote.noteData] + 'holdend');
		}

		newNote.setGraphicSize(Std.int(newNote.width * PlayState.daPixelZoom));
		newNote.antialiasing = false;
		newNote.updateHitbox();

		if (newNote.canBeHit)
			newNote.kill();
	}
	else
	{
		var pixelData:Array<Int> = [4, 5, 6, 7];
	
		newNote.loadGraphic(Paths.image("instakill/skins/pixel/HOLD_assets", 'data/notetypes'), true, 7, 6);
		newNote.animation.add(Receptor.colors[newNote.noteData] + 'holdend', [pixelData[newNote.noteData]]);
		newNote.animation.add(Receptor.colors[newNote.noteData] + 'hold', [pixelData[newNote.noteData] - 4]);
		newNote.animation.play(Receptor.colors[newNote.noteData] + 'holdend');

		newNote.noteSuffix = "miss";
		newNote.ignoreNote = true;

		newNote.setGraphicSize(Std.int(newNote.width * PlayState.daPixelZoom));
		newNote.antialiasing = false;
		newNote.updateHitbox();
	}
}

function onStep(newNote, curStep:Int)
{
	if (Init.trueSettings.get('Disable Mechanics'))
	{
		if (newNote.mustPress)
		{
			if (newNote.isSustainNote)
			{
				newNote.kill();
			}
			newNote.kill();
		}
	}
}

function onHit(newNote)
{
	if (!newNote.canBeHit)
	{
		PlayState.health -= 0;
	}
	else
	{
		PlayState.health -= 5000;
	}
}
