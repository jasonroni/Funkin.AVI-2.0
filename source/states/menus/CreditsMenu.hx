package states.menus;

import sys.io.File;
import openfl.filters.ShaderFilter;
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
    /**
	* ## Custom Credits Mapping System
	* 
	* Numbers are the current selected mapping the menu will display when it uses the number
	* It kinda goes something like this:
    	* curSelected => [Name of Contributor, Icon, Work They've Done, Description/Quote, X Value of Icon, Y Value of Icon, Size of Icon, Bool for in case someone has a stupidly long description]
	*/
    public static var creditArray:Array<Dynamic> = [
        ['Yama haki / Toko', 'toko', 'Creator, Owner, Director, Composer, PlayTester', 'Now THIS is how you delusional', -320, -140, 0.55, false],
        ['DEMOLITIONDON96', 'don', 'Director, Composer, Main Programmer, Artist, Animator, Charter', 'Shut the fuck up you lame ass Psych engine kiddo.', -320, -140, 0.55, false],
        ['Domingo', 'domingo', 'Director, Main Artist, Animator, Cutscenes, PlayTester', "A realistic depiction of working on Funkin.Avi!!
		In all seriousness this mod has taken so long to finish its update, I think it was about a year already… 
		OH WAIT by the time, June 12, 2023, I'm writing this I'm pretty sure it has been exactly 1 year since we have uploaded the very first demo of the mod. 
		We have come such a long way and I'm happy with what we've been able to achieve and the story hasn't even reached its climax. 
		Thank you for playing!", -320, -140, 0.55, true],
	    ['KKCopinXD', 'kopin', 'Co-Director, Icon Artist & Concept Menu Artist', "if it wasn't for Coolye3ted I wouldn't be here on this Mod to be able to work on it 
		I've been here since 1.5 and It's an honor to be here working for this amazing team, 
		I made a lot of friends I appreciate being able to be friends with them I hope you enjoyed the update we all worked hard to finish it! YIPPEEEEEEE-
		\nI made Malfuntion background, all MOD icons ( except Hunter Goofy ) all OST arts, dubbed Relapse Mouse and Malfuntion countdowns and I made FreePlay Concept", 50, 40, 1, true],
	    ['HanaCat', 'hana', 'Artist & Charter', 'i am the charter of devilish-deal!11!1! and also animator some character1!1!1!1! and you are so isolated!1!1', 50, 40, 1, false],
	    ['RetroJogador', 'joga', 'Composed Main Menu, Both Joke Songs, & Made Menu Art', "Btw I really enjoyed joining the mod team and ending this amazing update, 
	      	along the way I met and made a lot of cool friends. Changing the subject, 
	      	I was responsible for making the Menu Music, Pause Music, Sanguis Muris and others, Arts I practically created the main menu, hud and Others, 
	      	and I gave the voice to Mrs Smile in V2, Change the World, My Final Message: YIPPEEE- ", -320, -140, 0.55, true],
	    ['IPhantom_Sprite', 'iphantom', 'Cutscenes, Icon Art for Hunter Goofy, Mother of Miserable Funk', "holy crap its mother of miserable funk", -320, -140, 0.55, false],
        ['theonlyshittyre.', 'shitty', 'Hunter Goofy.', "I've been on this mod for a long time, when I arrived, 
		the quality of the mod was still pretty questionable, 
	      	but im pretty proud of what this mod has become, like.. bro this gotta be my fav mod in fnf community and im not saying that cuz i work here, lol. 
		Well, im pretty happy to say that my balls are itchy, have a good day.",  50, 40, 1, true],
	8 => ['AustinTheRedDragon', 'austin', 'Artist, Owner of Mr. Smiles & Professionally Horny', 'I am not an alligator' /*yes you are :trollface: -don*/, -320, -140, 0.55, false],
	9 => ['The Gamerchoice', 'gamerchoice', 'Concept Artist & Playtester', 'where are the men???1?! * has an erection *', -320, -140, 0.55, false],
	10 => ['FR3SHMoure', 'fresh', "Composer that's mostly well known for Delusional", 'the swagging of 68', -320, -140, 0.55, false],
	11 => ['Dreupy', 'dreupy', 'Charter', 'MICKEY DIES????', -320, -140, 0.55, false],
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

    var cool_1980_shader:FlxRuntimeShader;

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

        creditDescText = new FlxText(FlxG.width * 0.52, FlxG.height * 0.6, 500, creditArray[curSelected][3]);
        creditDescText.setFormat(Paths.font('vcr'), 40, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        creditDescText.borderSize = 1.3;
        add(creditDescText);

        creditNameText = new FlxText(FlxG.width * 0.22, FlxG.height * 0.3, FlxG.width, creditArray[curSelected][0]);
        creditNameText.setFormat(Paths.font('vcr'), 70, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        creditNameText.borderSize = 1.3;
        add(creditNameText);

        creditWorkText = new FlxText(FlxG.width * 0.52, FlxG.height * 0.41, 500, creditArray[curSelected][2]);
        creditWorkText.setFormat(Paths.font('vcr'), 30, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        creditWorkText.borderSize = 1.3;
        add(creditWorkText);

        creditIconSprite = new FlxSprite(creditArray[curSelected][4], creditArray[curSelected][5]).loadGraphic(Paths.image('$path/icons/${creditArray[curSelected][1]}'));
        creditIconSprite.setGraphicSize(Std.int(creditIconSprite.width * creditArray[curSelected][6]));
        add(creditIconSprite);

        changeSelection();

        super.create();

        cool_1980_shader = new FlxRuntimeShader(File.getContent('./assets/shaders/1980_shader.frag'), null, 140);

        if(!Init.trueSettings.get('Disable Screen Shaders')) FlxG.camera.setFilters([
            new ShaderFilter(cool_1980_shader),
            new ShaderFilter(new FlxRuntimeShader(File.getContent('./assets/shaders/monitor.frag'), null, 140))
        ]);

        if(!Init.trueSettings.get('Low Quality')) {
			var scratchStuff:FlxSprite = new FlxSprite();
			scratchStuff.frames = Paths.getSparrowAtlas('filters/scratchShit');
			scratchStuff.animation.addByPrefix('idle', 'scratch thing 1', 24, true);
			scratchStuff.animation.play('idle');
			scratchStuff.screenCenter();
			scratchStuff.scale.x = 1.1;
			scratchStuff.scale.y = 1.1;
			add(scratchStuff);

			var grain:FlxSprite = new FlxSprite();
			grain.frames = Paths.getSparrowAtlas('filters/Grainshit');
			grain.animation.addByPrefix('idle', 'grains 1', 24, true);
			grain.animation.play('idle');
			grain.screenCenter();
			grain.scale.x = 1.1;
			grain.scale.y = 1.1;
			add(grain);
		}
    }

    var shaderTime:Float = 0;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        shaderTime += elapsed;

        if(!Init.trueSettings.get('Disable Screen Shaders'))
            {
                cool_1980_shader.setFloat('iTime', shaderTime);
            }

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

            // maybe this prevents the crash issue??????
            if (curSelected < 0) curSelected = 7;
            else if (curSelected > 7) curSelected = 0;
    }

    override function destroy() {
        super.destroy();

        ForeverTools.resetMenuMusic();
    }

    private function changeSelection(newSelect:Int = 0) 
    {
        curSelected += newSelect;
        if (curSelected < 0)
            curSelected = creditArray.length - 1;
        if (curSelected >= creditArray.length)
            curSelected = 0;

        creditNameText.text = creditArray[curSelected][0] != null ? creditArray[curSelected][0] : 'unknown';
        creditDescText.text = creditArray[curSelected][3] != null ? creditArray[curSelected][3] : 'unknown';
        creditWorkText.text = creditArray[curSelected][2] != null ? creditArray[curSelected][2] : 'has not worked';
        creditIconSprite.loadGraphic(Paths.image('$path/icons/${creditArray[curSelected][1]}'));
        creditIconSprite.setGraphicSize(Std.int(creditIconSprite.width * creditArray[curSelected][6]));
        creditIconSprite.setPosition(creditArray[curSelected][4], creditArray[curSelected][5]);

        if (newSelect != 0) FlxG.sound.play(Paths.sound('base/menus/scrollMenu'), 0.6);

        // guys this is a bool i promise
        if(creditArray[curSelected][7])
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
