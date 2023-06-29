package states.menus.freeplay;

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

class FreeplayCategories extends MusicBeatState {

	var unfinishedText:FlxText;
    	var freeplayCats:Array<String>;
	var fpCateBanners:FlxSprite;
	var grpCats:FlxTypedGroup<FlxSprite>;
	var curSelected:Int = 0;
	var noFreeplay:FlxText;
	var BG:FlxSprite;
	var defaultShader2:FlxRuntimeShader;
	
   	 override function create(){

		super.create();

		defaultShader2 = new FlxRuntimeShader(Shaders.monitorFilter, null, 140);
		FlxG.camera.setFilters(
			[
				new openfl.filters.ShaderFilter(defaultShader2)
			]);
			
		/*if (GameData.coversCategoryLock == 'unlocked')
		{
			freeplayCats = ['Episodes', 'Extras', 'Legacy', 'Covers']; // probably won't be used till V3 most likely unless Yama decides we add this category thing
		}else*/ 
	    		freeplayCats = ['episodes', 'extras', 'legacy'];
    		//}

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

       		grpCats = new FlxTypedGroup<FlxSprite>();
		add(grpCats);

		// so what if it's just a cheap copy and paste of the main menu items? if it works, it works bitch /jjjjjjjjjjj (don)
		for (i in 0...freeplayCats.length)
		{
			var offset:Float = 108 - (Math.max(freeplayCats.length, 4) - 4) * 80;
			var catsBanners:FlxSprite = new FlxSprite(0, (i * 100)  + offset).loadGraphic(Paths.image("menus/Funkin_avi/freeplay/categoryAssets/" + freeplayCats[i]));
			catsBanners.scale.set(0.6, 0.6);
			catsBanners.ID = i;
			catsBanners.screenCenter(X);
			catsBanners.y += 158 + (0 * 25) - 200;
			grpCats.add(catsBanners);

			var scr:Float = (freeplayCats.length - 4) * 0.135;
			catsBanners.scrollFactor.set(0, scr);
			catsBanners.antialiasing = true;
			catsBanners.updateHitbox();
		}

			unfinishedText = new FlxText(907, FlxG.height - 54, 0, "Currently, The category Menu is Unfinished, The Final Verion Will Be Different!", 25);
			unfinishedText.scrollFactor.set();
			unfinishedText.screenCenter(X);
			unfinishedText.setFormat(Paths.font("NewWaltDisneyFontRegular-BPen.ttf"), 25, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			add(unfinishedText);

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

        updateSelection();
    }

	var counterControl:Float = 0;

    override public function update(elapsed:Float){

		var up = Controls.getPressEvent("ui_up", "pressed");
		var down = Controls.getPressEvent("ui_down", "pressed");
		var up_p = Controls.getPressEvent("ui_up");
		var down_p = Controls.getPressEvent("ui_down");
		var controlArray:Array<Bool> = [up, down, up_p, down_p];

		if ((controlArray.contains(true)))
		{

			for (i in 0...controlArray.length)
			{
				// here we check which keys are pressed
				if (controlArray[i] == true)
				{
					/*
						i > 1 is single pressá
						up is 2, down is 3
					 */

					var changeValue:Int = 0;

					if (i > 1)
					{
						if (i == 2 && curSelected != 0)
							changeValue -= 1;
						else if (i == 3 && curSelected != 2)
							changeValue += 1;

						FlxG.sound.play(Paths.sound('base/menus/scrollMenu'));
					}

					curSelected = FlxMath.wrap(Math.floor(curSelected) + changeValue, 0, freeplayCats.length - 1);
				}
				//
			}
		}
		else
		{
			// reset variables
			counterControl = 0;
		}
		
		if ((Controls.getPressEvent("back"))) {
			Main.switchState(this, new states.menus.MainMenu());
		}


        if ((Controls.getPressEvent("accept"))){
            	states.menus.freeplay.FreeplaySongs.freeplayMenuList = curSelected;
		Main.switchState(this, new states.menus.freeplay.FreeplaySongs());
        }

		if (Math.floor(curSelected) != lastCurSelected)
			updateSelection();

        super.update(elapsed);
    }

	var lastCurSelected:Int = 0;

	private function updateSelection()
	{
		// reset all selections
		grpCats.forEach(function(spr:FlxSprite)
		{
			if (!Init.trueSettings.get('Disable Screen Shaders')) spr.shader = null;
			spr.alpha = 0.45;
			spr.updateHitbox();
		});

		if (grpCats.members[Math.floor(curSelected)].alpha == 0.45)
		{
			grpCats.members[Math.floor(curSelected)].alpha = 1;
		}

		grpCats.members[Math.floor(curSelected)].updateHitbox();

		lastCurSelected = Math.floor(curSelected);
	}
}
