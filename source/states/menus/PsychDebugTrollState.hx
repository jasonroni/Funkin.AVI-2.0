package states.menus;

import base.dependency.Discord;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import states.MusicBeatState;

class PsychDebugTrollState extends MusicBeatState 
{
   var background:FlxSprite; // for some reason, the game would crash without it

   var noBitchCam:FlxCamera;
   var bgCam:FlxCamera;

   var upText:FlxText;
   var downText:FlxText;

   var monitor:FlxRuntimeShader;
   var bloom:FlxRuntimeShader;

   override public function create() 
	{
      	noBitchCam = new FlxCamera();
      	bgCam = new FlxCamera();
      	bgCam.bgColor.alpha = 0;

      	FlxG.cameras.reset(noBitchCam);
      	FlxG.cameras.add(bgCam, false);
      	FlxG.cameras.setDefaultDrawTarget(noBitchCam, true);
	   
		#if DISCORD_RPC
		Discord.changePresence('PSYCH ENGINE KID DETECTED', 'Get a load of this loser lmfao', 'troll', 'psych');
		#end

      	super.create();

      	bloom = new FlxRuntimeShader(Shaders.bloom, null, 120);
      	monitor = new FlxRuntimeShader(Shaders.monitorFilter, null, 140);

		// me when the uhhhh
      	if (!Init.trueSettings.get('Disable Screen Shaders'))
		{
			noBitchCam.setFilters([
				new openfl.filters.ShaderFilter(bloom),
			 	new openfl.filters.ShaderFilter(monitor)
		  	]);
		}

        background = new FlxSprite(0, 0).makeGraphic(1, 1, FlxColor.BLACK);
		background.scale.set(FlxG.width * 4, FlxG.height * 4);
        background.cameras = [bgCam];

      	var eyes:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/Funkin_avi/NEWmenu/HahaSadBoi'));
		eyes.scrollFactor.set(0, 0);
		eyes.screenCenter();
		eyes.updateHitbox();
		eyes.antialiasing = true;
		add(eyes);
	   
		upText = new FlxText(0, 20, 0, 'Lmao, you thought this was on Psych Engine?', 32);
		upText.setFormat(Paths.font('DisneyFont'), 50, EngineTools.setTextAlign('center'), FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		upText.screenCenter(X);
		add(upText);

		downText = new FlxText(0, 560, 0, 'It\'s on Another Engine ya bum, silly Psych Engine kid.\n(Press ESC to leave)', 32);
		downText.setFormat(Paths.font('DisneyFont'), 50, EngineTools.setTextAlign('center'), FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		downText.screenCenter(X);
		add(downText);

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

   override public function update(elapsed:Float) 
	{
      if(Controls.getPressEvent("back"))
         {
            lime.app.Application.current.window.alert('Psych engine loser, laugh at this user');
            Main.switchState(this, new MainMenu());
         }

         super.update(elapsed);
   }
}
