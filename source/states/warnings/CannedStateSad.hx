// stolen from vs cartoon cat mwahahahaha

package states.warnings;

import flixel.text.FlxText;
import openfl.Assets;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.addons.text.FlxTypeText;
import flixel.FlxG;

using StringTools;

class CannedStateSad extends MusicBeatState
{
    var text:Array<String> = [
        'So uhh, this is unexpected. - nothing',
        'Yes, Funkin.AVI is cancelled. Mainly due lack of motivation, inactivity and etc... - nothing',
        'You know, have you ever asked what happend if cancelled mods actually released? - nothing',
        'I ask that same question too... - nothing',
        'Anyways, here it is, the cancelled build, enjoy... - start'
    ];

    var dialogue:String;
    var curDialogue:Int;

    var effect:String = 'nothing';

    var dialogueText:FlxTypeText;

    override public function create() 
    {
        if (FlxG.sound.music != null && FlxG.sound.music.playing)
            FlxG.sound.music.fadeOut(1.2, 0);
        
        dialogueText = new FlxTypeText(73, FlxG.height - 75, FlxG.width, "", 36);
        dialogueText.font = "Karma Suture";
        dialogueText.color = FlxColor.WHITE;
        dialogueText.sounds = [FlxG.sound.load(Paths.sound('dialogue/pixelText'), 0.6)];
        add(dialogueText);

        startDialogue();

        super.create();   
    }

    override public function update(elapsed:Float) 
    {
        super.update(elapsed);

        // here we go
        if (text[curDialogue+1] != null)
        {
            if (FlxG.keys.justPressed.ENTER)
            {
                curDialogue++;
                startDialogue(); 
                FlxG.sound.play(Paths.sound('base/menus/cancelMenu'));
            }
        }
    }

    function startDialogue()
	{
        cleanDialog();

		dialogueText.resetText(dialogue);
		dialogueText.start(0.04, true);

        switch (effect)
        {
            case 'start':
                new FlxTimer().start(5, function (tmr:FlxTimer)
                {
                    FlxTween.tween(dialogueText, {alpha: 0}, 0.5, {
                        ease: FlxEase.quadOut, 
                        onComplete: function (twn:FlxTween)
                        {
                            Main.switchState(this, new states.TitleState());
                        }
                    });
                });  
        }
	}

    function cleanDialog()
	{
        var data:Array<String> = text[curDialogue].split(" - ");
        dialogue = data[0];
        effect = data[1];
	}
}