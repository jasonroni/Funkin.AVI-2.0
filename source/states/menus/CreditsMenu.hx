package states.menus;

import base.song.Conductor;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.addons.display.FlxGridOverlay;
import flixel.tweens.*;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.FlxSprite;

class CreditsMenu extends MusicBeatState 
{
    // Also the number is for identificate the current selected
    // Name, Icon, Works, Description, icon X, icon Y, Size, Goofy ahh long text
    public static var creditMap:Map<Int, Array<Dynamic>> = [
        0 => ['Yama haki / Toko', 'toko', 'Owner, Director, Composer, PlayTester', 'Now THIS is how you delusional', -320, -140, 0.55, false],
        1 => ['DEMOLITIONDON96', 'don', 'Director, Composer, Main coder, Artist, Animator, Charter', 'Shut the fuck up you lame ass Psych engine kiddo', -320, -140, 0.55, false],
        2 => ['Domingo', 'domingo', 'Director, Main Artist, Animator, Cutscenes, PlayTester', "A realistic depiction of working on Funkin.Avi!!
In all seriousness this mod has taken so long to finish its update, I think it was about a year already… 
OH WAIT by the time, June 12, 2023, I'm writing this I'm pretty sure it has been exactly 1 year since we have uploaded the very first demo of the mod. 
We have come such a long way and I'm happy with what we've been able to achieve and the story hasn't even reached its climax. 
Thank you for playing!
        ", -320, -140, 0.55, true],
    ];

    var curSelected:Int = 0;

    var creditIconSprite:FlxSprite;
    var creditDescText:FlxText;
    var creditNameText:FlxText;
    var creditWorkText:FlxText;
    var backdrop:FlxBackdrop;
    var background:FlxSprite;
    var box:FlxSprite;
    var daStrip:FlxSprite;
    var creditIconText:FlxSprite;

    var maxLength = 1;

    var path:String;

    override function create() 
    {
        FlxG.stage.window.title = "Funkin.avi - Credit Menu";

        path = 'menus/Funkin_avi/credits';

        FlxG.sound.playMusic(Paths.music('credits'));

        Conductor.changeBPM(164);

        background = new FlxSprite().loadGraphic(Paths.image('$path/background'));
        background.screenCenter();
        add(background);

        // thank you shadow mario fnf
        backdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0xFFFFFF, 0x33FFFFFF));
		backdrop.velocity.set(40, 40);
		backdrop.alpha = 0;
        backdrop.setGraphicSize(Std.int(backdrop.width * 0.6));
		FlxTween.tween(backdrop, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		add(backdrop);

        daStrip = new FlxSprite().loadGraphic(Paths.image('$path/filmstrip'));
        daStrip.screenCenter();
        daStrip.setGraphicSize(Std.int(daStrip.width * 0.8));
        add(daStrip);

        box = new FlxSprite().loadGraphic(Paths.image('$path/box'));
        box.screenCenter().x -= 80;
        box.setGraphicSize(Std.int(box.width * 0.6));
        add(box);

        creditDescText = new FlxText(FlxG.width * 0.52, FlxG.height * 0.6, 500, creditMap[curSelected][3]);
        creditDescText.setFormat(Paths.font('vcr'), 40, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        creditDescText.borderSize = 1.3;
        add(creditDescText);

        creditNameText = new FlxText(FlxG.width * 0.22, FlxG.height * 0.3, FlxG.width, creditMap[curSelected][0]);
        creditNameText.setFormat(Paths.font('vcr'), 70, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        creditNameText.borderSize = 1.3;
        add(creditNameText);

        creditWorkText = new FlxText(FlxG.width * 0.52, FlxG.height * 0.41, 500, creditMap[curSelected][2]);
        creditWorkText.setFormat(Paths.font('vcr'), 30, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        creditWorkText.borderSize = 1.3;
        add(creditWorkText);

        creditIconSprite = new FlxSprite(creditMap[curSelected][4], creditMap[curSelected][5]).loadGraphic(Paths.image('$path/icons/${creditMap[curSelected][1]}'));
        creditIconSprite.setGraphicSize(Std.int(creditIconSprite.width * creditMap[curSelected][6]));
        add(creditIconSprite);

        changeSelection();

        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        ForeverTools.cameraBumpingZooms(FlxG.camera, 1);

        if (Controls.getPressEvent("ui_up"))
            {
                changeSelection(-1);
            } else if (Controls.getPressEvent("ui_down")) {
                changeSelection(1);
            }

        if (Controls.getPressEvent("back"))
            {
                Main.switchState(this, new MainMenu());
            }
    }

    override function destroy() {
        super.destroy();

        ForeverTools.resetMenuMusic();
    }

    private function changeSelection(newSelect:Int = 0) 
    {
        curSelected += newSelect;

        creditNameText.text = creditMap[curSelected][0] != null ? creditMap[curSelected][0] : 'unknown';
        creditDescText.text = creditMap[curSelected][3] != null ? creditMap[curSelected][3] : 'unknown';
        creditWorkText.text = creditMap[curSelected][2] != null ? creditMap[curSelected][2] : 'has not worked';
        creditIconSprite.loadGraphic(Paths.image('$path/icons/${creditMap[curSelected][1]}'));
        creditIconSprite.setGraphicSize(Std.int(creditIconSprite.width * creditMap[curSelected][6]));
        creditIconSprite.setPosition(creditMap[curSelected][4], creditMap[curSelected][5]);

        if (newSelect != 0) FlxG.sound.play(Paths.sound('base/menus/scrollMenu'), 0.6);

        // guys this is a bool i promise
        if(creditMap[curSelected][7])
            {
                creditNameText.y = FlxG.height * 0.1;
                creditWorkText.y = FlxG.height * 0.21;
                creditDescText.fieldWidth = 1000;
                creditDescText.x = FlxG.width * 0.32;
                creditDescText.y = FlxG.height * 0.16;
                creditDescText.scale.set(0.6, 0.6);
            } else { // reload reasons
                creditDescText.fieldWidth = 500;
                creditDescText.x = FlxG.width * 0.52;
                creditDescText.y = FlxG.height * 0.6;
                creditDescText.scale.set(1, 1);
                creditNameText.y = FlxG.height * 0.3;
                creditWorkText.y = FlxG.height * 0.41;
            }

        trace('huh: credits edition');
    }
}
