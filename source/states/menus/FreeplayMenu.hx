package states.menus;

import base.dependency.Discord;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.input.keyboard.FlxKey;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.BitmapFilter;
import openfl.utils.Assets as OpenFlAssets;
import openfl.filters.ShaderFilter;
import objects.fonts.Alphabet;

using StringTools;

class FreeplayMenu extends MusicBeatState {

	var unfinishedText:FlxText;

    	var freeplayCats:Array<String>;
	var fpCateBanners:FlxSprite;
	var grpCats:FlxTypedGroup<Alphabet>;
	var curSelected:Int = 0;
	var noFreeplay:FlxText;
	var BG:FlxSprite;

	var defaultShader:FlxRuntimeShader;
	var defaultShader2:FlxRuntimeShader;
	
    override function create(){

		super.create();

		defaultShader = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/grayScale.frag'), null, 140);
		defaultShader2 = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/monitor.frag'), null, 140);
		FlxG.camera.setFilters(
			[
				new openfl.filters.ShaderFilter(defaultShader),
				new openfl.filters.ShaderFilter(defaultShader2)
			]);
			
		/*if(FPClientPrefs.episode2FPLock == 'unlocked' && FPClientPrefs.malfunctionLock == 'beaten' && FPClientPrefs.crossinLock == 'beaten' && FPClientPrefs.warLock == 'beaten' && FPClientPrefs.sinsLock == 'beaten' && FPClientPrefs.huntedLock == 'beaten' && FPClientPrefs.blessLock == 'beaten' && FPClientPrefs.scrappedLock == 'beaten' && FPClientPrefs.mercyLock == 'beaten' && FPClientPrefs.oldisolateLock == 'beaten' && FPClientPrefs.betaisolateLock == 'beaten') //omfg, I hate this, why can't it just work some other, much more SIMPLER way?
		{
			if(ClientPrefs.language == "Spanish") freeplayCats = ['Legado', 'Jugar', 'Un Mensaje Para It', 'Cubiertas'];
			else freeplayCats = ['Legacy', 'Episodes', 'Extras', 'Covers'];
		}else*/ freeplayCats = ['Episodes', 'Extras', 'Legacy'];

        BG = new FlxSprite().loadGraphic(Paths.image('menus/base/menuDesat'));
		BG.color = FlxColor.GRAY;
		BG.updateHitbox();
		BG.screenCenter();
		add(BG);

		#if desktop
		// Updating Discord Rich Presence
		Discord.changePresence("PICKING CATEGORY", "Freeplay: Category Menu", 'icon', 'disc-player');
		#end

		Application.current.window.title = "Funkin.avi - Freeplay: Category Menu";

        grpCats = new FlxTypedGroup<Alphabet>();
		add(grpCats);
        for (i in 0...freeplayCats.length)
        {
			var catsText:Alphabet = new Alphabet(0, (70 * i) + 250, freeplayCats[i], true, false);
			catsText.isMenuItem = true;
			catsText.targetY = i;
			grpCats.add(catsText);
		}

			unfinishedText = new FlxText(907, FlxG.height - 54, 0, "Currently, The category Menu is Unfinished, The Final Verion Will Be Different!", 25);
			unfinishedText.scrollFactor.set();
			unfinishedText.screenCenter(X);
			unfinishedText.setFormat(Paths.font("NewWaltDisneyFontRegular-BPen.ttf"), 25, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			add(unfinishedText);

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

        changeSelection();
    }

    override public function update(elapsed:Float){

		var up_p = Controls.getPressEvent("ui_up");
		var down_p = Controls.getPressEvent("ui_down");

		if (up_p && curSelected != 0) 
			changeSelection(-1);
		if (down_p && curSelected != 2) 
			changeSelection(1);
		
		if ((Controls.getPressEvent("back"))) {
			Main.switchState(this, new states.menus.MainMenu());
		}


        if ((Controls.getPressEvent("accept"))){
            switch(curSelected){
                case 0:
					Main.switchState(this, new states.menus.freeplay.FreeplayState());
                case 1:
					Main.switchState(this, new states.menus.freeplay.ExtrasState());
				case 2:
					Main.switchState(this, new states.menus.freeplay.LegacyState());
			}
        }

        super.update(elapsed);
    }

    function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = freeplayCats.length - 1;
		if (curSelected >= freeplayCats.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpCats.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
			}
		}
		//FlxG.sound.play(Paths.sound('funkinAVI/menu/scroll_sfx'));
	    
	    	//I'll come up with a replacement with the code that used to be here
	}
}
