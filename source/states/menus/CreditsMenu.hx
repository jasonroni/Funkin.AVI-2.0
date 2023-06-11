package states.menus;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.addons.display.FlxGridOverlay;
import flixel.tweens.*;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.FlxSprite;

class CreditsMenu extends MusicBeatState 
{
    public static var creditDesc:Map<Int, String> = [
        0 => 'hello, this is a test.'
    ];

    public static var creditIcon:Map<Int, String> = [
        0 => 'test'
    ];

    var curSelected:Int = 0;

    var creditIconSprite:FlxSprite;

    var creditDescText:FlxText;

    var backdrop:FlxBackdrop;

    var background:FlxSprite;

    var daStrip:FlxSprite;

    override function create() 
    {
        FlxG.stage.window.title = "Funkin.avi - Credit Menu";

        var path = 'menus/Funkin_avi/credits';

        FlxG.sound.playMusic(Paths.music('totally_placeholder_music'));

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

        creditDescText = new FlxText(FlxG.width * 0.22, FlxG.height * 0.46, FlxG.width, creditDesc[curSelected]);
        creditDescText.setFormat(Paths.font('vcr'), 40, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        creditDescText.borderSize = 1.25;
        add(creditDescText);

        changeSelection();

        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Controls.getPressEvent("ui_up"))
            {
                changeSelection(-1);
            } else if ( Controls.getPressEvent("ui_down")) {
                changeSelection(1);
            }

        if (Controls.getPressEvent("back"))
            {
                ForeverTools.resetMenuMusic();
                Main.switchState(this, new MainMenu());
            }
    }

    private function changeSelection(newSelect:Int = 0) 
    {
        curSelected += newSelect;

        creditDescText.text = creditDesc[curSelected] != null ? creditDesc[curSelected] : 'unknown';

        trace('huh: credits edition');
    }
}
