package states.menus;

import base.dependency.Discord;
import base.dependency.FeatherDeps.ScriptHandler;
import globals.Paths;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import states.MusicBeatState;
import flixel.addons.display.FlxRuntimeShader;

using StringTools;

class SexState extends MusicBeatState 
{
   
   var youGetNoBitches:FlxSprite; // Megamind is fucking peak, go watch it

   var background:FlxSprite; // for some reason, the game would crash without it

   var noBitchCam:FlxCamera;
   var bgCam:FlxCamera;

   var upText:FlxText;
   var megaText:FlxText;
   var downText:FlxText;

   var monitor:FlxRuntimeShader;
   var bloom:FlxRuntimeShader;

   override function create() {

      noBitchCam = new FlxCamera();
      bgCam = new FlxCamera();
      bgCam.bgColor.alpha = 0;

      FlxG.cameras.reset(noBitchCam);
      FlxG.cameras.add(bgCam, false);
      FlxG.cameras.setDefaultDrawTarget(noBitchCam, true);

      super.create();

      bloom = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/bloom.frag'), null, 120);
      monitor = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/monitor.frag'), null, 140);

      noBitchCam.setFilters([
            new openfl.filters.ShaderFilter(bloom),
            new openfl.filters.ShaderFilter(monitor)
         ]);

         background = new FlxSprite(0, 0).makeGraphic(FlxG.width, 1000, FlxColor.BLACK);
         background.scale.set(5, 5);
         background.cameras = [bgCam];

        /* youGetNoBitches = new FlxSprite();
         //youGetNoBitches.loadGraphic(Paths.image('menus/Funkin_avi/noBitches'));
         youGetNoBitches.loadGraphic(sys.io.File.getContent('./assets/images/menus/Funkin_avi/noBitches.png'));
         youGetNoBitches.screenCenter();
         add(youGetNoBitches);*/

    /*  var megaMind:FlxSprite = new FlxSprite();
      megaMind.*/

      var eyes:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/Funkin_avi/NEWmenu/HahaSadBoi'));
		eyes.scrollFactor.set(0, 0);
		eyes.screenCenter();
		eyes.updateHitbox();
		eyes.antialiasing = true;
		add(eyes);

         upText = new FlxText(0, 20, 0, 'Lmao, you thought this was on Psych Engine?', 32);
         upText.setFormat(Paths.font('DisneyFont'), 50, ForeverTools.setTextAlign('center'), FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
         upText.screenCenter(X);
         add(upText);

         downText = new FlxText(0, 560, 0, 'Man, these psych kids be down bad rn lmfao.\n(Press ESC to leave)', 32);
         downText.setFormat(Paths.font('DisneyFont'), 50, ForeverTools.setTextAlign('center'), FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
         downText.screenCenter(X);
         add(downText);

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

   override function update(elapsed:Float) {

      if(Controls.getPressEvent("back"))
         {
            lime.app.Application.current.window.alert('Bro think there was sex', 'L moment');
            Main.switchState(this, new MainMenu());
         }

         super.update(elapsed);
   }
}