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

class StoryMenu extends MusicBeatState {

	var unfinishedText:FlxText;

    	var storyCats:Array<String>;
	var storyCateBanners:FlxSprite;
	var grpCats:FlxTypedGroup<Alphabet>;
	var curSelected:Int = 0;
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
			
		storyCats = ['Main Episodes', 'Bonus Episodes'];

        BG = new FlxSprite().loadGraphic(Paths.image('menus/base/menuDesat'));
		BG.color = FlxColor.GRAY;
		BG.updateHitbox();
		BG.screenCenter();
		add(BG);

		#if desktop
		// Updating Discord Rich Presence
		Discord.changePresence("PICKING CATEGORY", "Story: Category Menu", 'icon', 'tape');
		#end

		Application.current.window.title = "Funkin.avi - Story: Category Menu";

        grpCats = new FlxTypedGroup<Alphabet>();
		add(grpCats);
        for (i in 0...storyCats.length)
        {
			var catsText:Alphabet = new Alphabet(0, (70 * i) + 250, storyCats[i], true, false);
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
					Main.switchState(this, new states.menus.story.MainStoryState());
                		case 1:
					Main.switchState(this, new states.menus.story.SideStoryState());
			}
        }

        super.update(elapsed);
    }

    function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = storyCats.length - 1;
		if (curSelected >= storyCats.length)
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
	}
}
