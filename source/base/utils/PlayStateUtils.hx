package base.utils;

import lime.app.Application;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import base.song.Conductor;
import flixel.math.FlxMath;
import flixel.tweens.*;
import flixel.FlxG;
import states.PlayState;
import openfl.filters.ShaderFilter;

/**
 * A class made for organize and separate all `PlayState` content
*/
class PlayStateUtils extends PlayState // extending the class itself incase crashes
{
    public static var instance:PlayStateUtils = new PlayStateUtils();

    /*
    * A function made to initialize your shaders with, only for song-specific initiation atm
    * 
    *  @author DEMOLITIONDON96 ft. Jason
    */
    public static function initializeShaders()
		{
			switch (PlayState.SONG.song)
			{
				case 'Malfunction':
					if(!Init.trueSettings.get('Low Quality'))
					{
						PlayState.camGame.setFilters(
						[
							new ShaderFilter(PlayState.chromZoomShader),
							new ShaderFilter(PlayState.blurShader)
						]);
						PlayState.camHUD.setFilters(
						[
							new ShaderFilter(PlayState.chromNormalShader),
							new ShaderFilter(PlayState.blurShader)
						]);
						for (i in PlayState.strumHUD)
						{
							i.setFilters(
							[
								new ShaderFilter(PlayState.chromNormalShader),
								new ShaderFilter(PlayState.blurShader)
							]);
						}
		
						new flixel.util.FlxTimer().start(5, function(tmr)
						{
							PlayState.camGame.setFilters([new ShaderFilter(PlayState.chromZoomShader)]);
							PlayState.camHUD.setFilters([new ShaderFilter(PlayState.chromNormalShader)]);
							for (i in PlayState.strumHUD) i.setFilters([new ShaderFilter(PlayState.chromNormalShader)]);
						});
					}
				case 'Malfunction Legacy':
					if(!Init.trueSettings.get('Low Quality'))
					{
						PlayState.camGame.setFilters(
						[
							new ShaderFilter(PlayState.chromNormalShader),
							new ShaderFilter(PlayState.blurShader)
						]);
						PlayState.camHUD.setFilters(
						[
							new ShaderFilter(PlayState.chromNormalShader),
							new ShaderFilter(PlayState.blurShader)
						]);
						for (i in PlayState.strumHUD)
						{
							i.setFilters(
							[
								new ShaderFilter(PlayState.chromNormalShader),
								new ShaderFilter(PlayState.blurShader)
							]);
						}
					}
				case 'Devilish Deal' | 'Isolated' | 'Lunacy' | 'Delusional' | 'Delusion':
					if (!Init.trueSettings.get('Low Quality'))
					{
						PlayState.camGame.setFilters([
                            new ShaderFilter(PlayState.redVignette),
							new ShaderFilter(PlayState.dramaticCamMovement),
							new ShaderFilter(PlayState.bloomEffect),
							new ShaderFilter(PlayState.monitorFilter),
							new ShaderFilter(PlayState.chromZoomShader),
							new ShaderFilter(PlayState.chromNormalShader)
						]);
						PlayState.camHUD.setFilters([new ShaderFilter(PlayState.chromNormalShader)]);
						for (i in PlayState.strumHUD) i.setFilters([new ShaderFilter(PlayState.grayScale), new ShaderFilter(PlayState.chromNormalShader)]);
					}
					else
					{
						PlayState.camGame.setFilters([
							new ShaderFilter(PlayState.monitorFilter),
							new ShaderFilter(PlayState.chromNormalShader)
						]);
						PlayState.camHUD.setFilters([new ShaderFilter(PlayState.chromNormalShader)]);
						for (i in PlayState.strumHUD) i.setFilters([new ShaderFilter(PlayState.grayScale)]);
					}
				case 'Isolated Old' | 'Isolated Legacy' | 'Isolated Beta' | 'Lunacy Legacy' | 'Delusional Legacy':
					PlayState.blurShader.setFloat('bluramount', 0.6);
					PlayState.blurShaderHUD.setFloat('bluramount', 0.1);
					PlayState.andromeda.setFloat('glitchModifier', 0.2);
					PlayState.andromeda.setBool('perspectiveOn', true);
					PlayState.andromeda.setBool('vignetteMoving', true);
					if (!Init.trueSettings.get('Low Quality'))
					{
						PlayState.camGame.setFilters([
							new ShaderFilter(PlayState.grayScale),
							new ShaderFilter(PlayState.blurShader),
							new ShaderFilter(PlayState.andromeda)
						]);
						PlayState.camHUD.setFilters([
							new ShaderFilter(PlayState.grayScale),
							new ShaderFilter(PlayState.blurShaderHUD),
							new ShaderFilter(PlayState.andromeda)
						]);
					}
					else
					{
						PlayState.camGame.setFilters([new ShaderFilter(PlayState.grayScale)]);
						PlayState.camHUD.setFilters([new ShaderFilter(PlayState.grayScale)]);
					}
				case 'Hunted Legacy':
					PlayState.blurShader.setFloat('bluramount', 0.6);
					PlayState.blurShaderHUD.setFloat('bluramount', 0.1);
					PlayState.andromeda.setFloat('glitchModifier', 0.2);
					PlayState.andromeda.setBool('perspectiveOn', true);
					PlayState.andromeda.setBool('vignetteMoving', true);
					if (!Init.trueSettings.get('Low Quality'))
					{
						PlayState.camGame.setFilters([
							new ShaderFilter(PlayState.grayScale),
							new ShaderFilter(PlayState.blurShader),
						]);
						@:privateAccess for(_camHUD in PlayState.main.allUIs) _camHUD.setFilters([
							new ShaderFilter(PlayState.grayScale),
							new ShaderFilter(PlayState.blurShaderHUD),
							new ShaderFilter(PlayState.andromeda)
						]);
					}
					else
					{
						PlayState.camGame.setFilters([new ShaderFilter(PlayState.grayScale)]);
						PlayState.camHUD.setFilters([new ShaderFilter(PlayState.grayScale)]);
					}				
				case 'Scrapped':
					if (!Init.trueSettings.get('Low Quality'))
					{
						PlayState.camGame.setFilters([
							new ShaderFilter(PlayState.staticEffect),
							new ShaderFilter(PlayState.blurShader),
							new ShaderFilter(PlayState.chromNormalShader),
							new ShaderFilter(PlayState.chromZoomShader)
						]);
						PlayState.camHUD.setFilters([
							new ShaderFilter(PlayState.blurShaderHUD),
							new ShaderFilter(PlayState.chromNormalShader)
						]);
						for (i in PlayState.strumHUD)
						{
							i.setFilters([
								new ShaderFilter(PlayState.blurShaderHUD),
								new ShaderFilter(PlayState.chromNormalShader)
							]);
						}
					}
					else
					{
						PlayState.camGame.setFilters([new ShaderFilter(PlayState.chromNormalShader)]);
						PlayState.camHUD.setFilters([new ShaderFilter(PlayState.chromNormalShader)]);
						for (i in PlayState.strumHUD) i.setFilters([new ShaderFilter(PlayState.chromNormalShader)]);
					}
                case 'Twisted Grins':
                    if (!Init.trueSettings.get('Low Quality'))
                    {
                        PlayState.camGame.setFilters([
                            new ShaderFilter(PlayState.staticEffect),
                            new ShaderFilter(PlayState.grayScale)
                        ]);
                    }
                    else
                    {
                        PlayState.camGame.setFilters([new ShaderFilter(PlayState.grayScale)]);
                    }
                    PlayState.camHUD.setFilters([new ShaderFilter(PlayState.grayScale)]);
                    for (i in PlayState.strumHUD)
                        i.setFilters([new ShaderFilter(PlayState.grayScale)]);
                case 'Hunted':
                    if (!Init.trueSettings.get('Low Quality'))
                    {
                        PlayState.camGame.setFilters([
                            new ShaderFilter(PlayState.dramaticCamMovement),
                            new ShaderFilter(PlayState.monitorFilter),
                            new ShaderFilter(PlayState.bloomEffect)
                        ]);
                    }
                    else
                    {
                        PlayState.camGame.setFilters([new ShaderFilter(PlayState.monitorFilter)]);
                    }
                    for (i in PlayState.strumHUD)
                        i.setFilters([new ShaderFilter(PlayState.grayScale)]);
                case 'Mercy' | 'Mercy Legacy':
                    if (!Init.trueSettings.get('Low Quality'))
                    {
                        PlayState.camGame.setFilters([
                            new ShaderFilter(PlayState.waltStatic),
                            new ShaderFilter(PlayState.dramaticCamMovement)
                        ]);
                    }
                    else
                    {
                        PlayState.camGame.setFilters([new ShaderFilter(PlayState.dramaticCamMovement)]);
                    }
                    PlayState.camHUD.setFilters([new ShaderFilter(PlayState.dramaticCamMovement)]);
                    for (i in PlayState.strumHUD)
                        i.setFilters([new ShaderFilter(PlayState.dramaticCamMovement)]);
			}
		}

    /*
    * This code USED to be in PlayState, but it made the create function look like a mess, so now it's in here!
    * Took a while to modify and fix to prevent crashing, but it works!
    * YIPPPEEEEEEE!!!!!
    * 
    * @author DEMOLITIONDON96
    */
    public function songSetup()
    {
        switch (PlayState.SONG.song)
		{
			case 'Devilish Deal':
				// Moves Player Notes on Opponent Side
				if (!Init.trueSettings.get('Centered Notefield'))
				{
					PlayState.strumLines.members[0].visible = false;
					PlayState.bfStrums.receptors.members[0].x = 75;
					PlayState.bfStrums.receptors.members[1].x = 185;
					PlayState.bfStrums.receptors.members[2].x = 300;
					PlayState.bfStrums.receptors.members[3].x = 415;
				}

				PlayState.camGame.alpha = 0.001;
				PlayState.camHUD.alpha = 0.001;
				for (i in PlayState.strumHUD)
				{
					i.alpha = 0.001; // 0.001 doesn't cause lag when setting alpha above 0 for some reason, yet it's still invisible
				}

			case 'Isolated' | 'Lunacy' | 'Cycled Sins' | 'Delusion':
				for (i in PlayState.strumHUD)
				{
					i.alpha = 0.001;
				}
				PlayState.camGame.alpha = 0.001;
				PlayState.camHUD.alpha = 0.001;

			case 'Mercy Legacy':
				if (!Init.trueSettings.get('Disable Mechanics'))
					PlayState.main.limitThing += 25;

			case 'Mercy':
				if (!Init.trueSettings.get('Disable Mechanics'))
					PlayState.main.limitThing += 20;

			// Glitched Mickey will give you a big fat middle finger for disabling the mechanics lmao
			case 'Malfunction Legacy':
				PlayState.main.crashLivesCounter += 30;
			case 'Malfunction':
				for (i in PlayState.strumHUD)
				{
					i.alpha = 0.001;
				}
				PlayState.camGame.alpha = 0.001;
				PlayState.camHUD.alpha = 0.001;
				PlayState.main.crashLivesCounter += 45;
		}

		switch (PlayState.curStage)
		{
			case 'forbiddenRealm':
				FlxTween.tween(PlayState.main.crashLives, {alpha: 0.3}, 2, {ease: FlxEase.quartInOut, startDelay: 5});
				FlxTween.tween(PlayState.main.crashLivesIcon, {alpha: 0.3}, 2, {ease: FlxEase.quartInOut, startDelay: 5});
				PlayState.main.add(PlayState.main.crashLives);
				PlayState.main.add(PlayState.main.crashLivesIcon);

			case 'waltRoom':
				if (!Init.trueSettings.get('Disable Mechanics'))
				{
					PlayState.main.add(PlayState.main.waltScreenThing);
					PlayState.main.add(PlayState.main.inkFormWarning);
					PlayState.main.add(PlayState.main.spaceBarCounter);
				}
				PlayState.strumLines.members[0].visible = false;
				PlayState.bfStrums.receptors.members[0].x = 40;
				PlayState.bfStrums.receptors.members[1].x = 320;
				PlayState.bfStrums.receptors.members[2].x = 800;
				PlayState.bfStrums.receptors.members[3].x = 1090;

			case 'staticVoid':
				PlayState.strumLines.members[0].visible = false;
				PlayState.bfStrums.receptors.members[0].x = 40;
				PlayState.bfStrums.receptors.members[1].x = 320;
				PlayState.bfStrums.receptors.members[2].x = 800;
				PlayState.bfStrums.receptors.members[3].x = 1090;
		}
    }

    /*
    * The Events handling system for hardcoded stuff you want to trigger in-game
    *  but don't want anyone to actually mess with
    * 
    *  Pretty cool if I say so myself, ngl, fun as well
    * 
    *  @author DEMOLITIONDON96 ft. Jason
    */
    public function createEvents(curBeat:Int)
    {
        switch (PlayState.SONG.song)
		{
			case 'Devilish Deal':
				switch (curBeat)
				{
					// Intro
					case 8: FlxTween.tween(PlayState.camGame, {alpha: 1}, 4.5, {ease: FlxEase.sineOut});

					case 16:
						PlayState.main.manageLyrics('placeholder', 'In the rain...', 'satanFont', 30, 2, 'sineInOut');

					case 20:
						PlayState.main.manageLyrics('placeholder', '...Looking so blue...', 'satanFont', 30, 3.2, 'sineInOut');

					case 26:
						PlayState.main.manageLyrics('placeholder', '...SPEAK...', 'satanFont', 30, 0.7, 'sineInOut');

					case 28:
						PlayState.main.manageLyrics('placeholder', '...What is on your mind?', 'satanFont', 30, 2.5, 'sineInOut');

					case 30:
						FlxTween.tween(PlayState.camHUD, {alpha: 1}, 2, {ease: FlxEase.sineOut});
						for (i in PlayState.strumHUD)
						{
							FlxTween.tween(i, {alpha: 1}, 2, {ease: FlxEase.sineOut});
						}

					case 32 | 34 | 36 | 38 | 40 | 42 | 44 | 46 | 48 | 50 | 52 | 54 | 56 | 58:
						if (PlayState.main.canaddshaders)
						{
							if (PlayState.main.chromTween != null)
								PlayState.main.chromTween.cancel();

							PlayState.main.chromEffect = 0.32;

							PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
								chromEffect: 0.0001
							}, 1.2, {
								ease: FlxEase.sineOut,
								onComplete: function(twn:FlxTween)
								{
									PlayState.main.chromTween = null;
								}
							});
						}

					case 60:
						FlxTween.tween(PlayState.camHUD, {alpha: 0.4}, 0.75, {ease: FlxEase.quartInOut});
						for (i in PlayState.strumHUD)
						{
							FlxTween.tween(i, {alpha: 0.4}, 0.75, {ease: FlxEase.quartInOut});
						}
						if (PlayState.main.canaddshaders)
						{
							if (PlayState.main.chromTween != null)
								PlayState.main.chromTween.cancel();

							PlayState.main.chromEffect = 0.15;

							PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
								chromEffect: 0.00001
							}, 1.2, {
								ease: FlxEase.sineOut,
								onComplete: function(twn:FlxTween)
								{
									PlayState.main.chromTween = null;
								}
							});
						}

					case 62:
						if (PlayState.main.canaddshaders)
						{
							if (PlayState.main.chromTween != null)
								PlayState.main.chromTween.cancel();

							PlayState.main.chromEffect = 0.15;

							PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
								chromEffect: 0.00001
							}, 2, {
								ease: FlxEase.sineOut,
								onComplete: function(twn:FlxTween)
								{
									PlayState.main.chromTween = null;
								}
							});
						}

					case 64:
						FlxTween.tween(PlayState.camHUD, {alpha: 1}, 1.2, {ease: FlxEase.quartInOut});
						for (i in PlayState.strumHUD)
						{
							FlxTween.tween(i, {alpha: 1}, 1.2, {ease: FlxEase.quartInOut});
						}

					case 128:
						PlayState.camGame.visible = false;
						for (i in PlayState.strumHUD)
						{
							i.visible = false;
						}
						if (!Init.trueSettings.get('Disable Flashing Lights'))
							PlayState.camAlt.flash(FlxColor.WHITE, 1);
						if (PlayState.main.canaddshaders)
						{
							if (PlayState.main.chromTween != null)
								PlayState.main.chromTween.cancel();

							PlayState.main.chromEffect = 0.4;

							PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
								chromEffect: 0.00001
							}, 2.3, {
								ease: FlxEase.sineOut,
								onComplete: function(twn:FlxTween)
								{
									PlayState.main.chromTween = null;
								}
							});
						}
				}

				if (curBeat >= 64 && curBeat <= 95 && PlayState.main.canaddshaders)
				{
					if (PlayState.main.chromTween != null)
						PlayState.main.chromTween.cancel();

					PlayState.main.chromEffect = 0.23;

					PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
						chromEffect: 0.00001
					}, 1.5, {
						ease: FlxEase.sineOut,
						onComplete: function(twn:FlxTween)
						{
							PlayState.main.chromTween = null;
						}
					});
				}

				if (curBeat >= 96 && curBeat <= 111 && PlayState.main.canaddshaders)
				{
					if (PlayState.main.chromTween != null)
						PlayState.main.chromTween.cancel();

					PlayState.main.chromEffect = 0.27;

					PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
						chromEffect: 0.0001
					}, 1.5, {
						ease: FlxEase.sineOut,
						onComplete: function(twn:FlxTween)
						{
							PlayState.main.chromTween = null;
						}
					});
				}

				if (curBeat >= 112 && curBeat <= 127 && PlayState.main.canaddshaders)
				{
					if (PlayState.main.chromTween != null)
						PlayState.main.chromTween.cancel();

					PlayState.main.chromEffect = 0.32;

					PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
						chromEffect: 0.00001
					}, 1.5, {
						ease: FlxEase.sineOut,
						onComplete: function(twn:FlxTween)
						{
							PlayState.main.chromTween = null;
						}
					});
				}
			case 'Isolated':
				switch (curBeat)
				{
					// Fixed Cam Stuff to not trigger before cutscene is even done
					case 16: FlxTween.tween(PlayState.camGame, {alpha: 1}, 3, {ease: FlxEase.quadOut});

					case 30:
						FlxTween.tween(PlayState.camHUD, {alpha: 1}, 3, {ease: FlxEase.quadOut});
						for (i in PlayState.strumHUD)
						{
							FlxTween.tween(i, {alpha: 1}, 3, {ease: FlxEase.quadOut});
						}

					case 160 | 352:
						PlayState.main.flashBGEffect(DARK, 0.85, 0.5, 'quartOut');

					case 184:
						PlayState.main.flashBGEffect(DARK, 0.77, 0.5, 'quartOut');

					case 188:
						PlayState.main.flashBGEffect(DARK, 0.6, 0.5, 'quartOut');

					case 376:
						PlayState.main.flashBGEffect(DARK, 0, 4, 'quartInOut');

					case 36 | 40 | 44 | 52 | 56 | 60 | 64 | 68 | 72 | 76 | 80 | 84 | 88 | 92:
						PlayState.main.flashBGEffect(NORMAL, 0.32, 1.2, 'linear');

					case 100 | 104 | 108 | 116 | 120 | 124 | 132 | 136 | 140 | 148 | 152 | 156 | 228 | 232 | 236 | 240 | 244 | 252 | 260 | 264 | 268 | 276 |
						280 | 284 | 292 | 296 | 300 | 308 | 312 | 316 | 324 | 328 | 332 | 340 | 344 | 348:
						PlayState.main.flashBGEffect(NORMAL, 0.4, 0.35, 'linear');

					case 98 | 102 | 106 | 110 | 114 | 118 | 122 | 126 | 130 | 134 | 138 | 142 | 146 | 150 | 154 | 158 | 226 | 230 | 234 | 238 | 242 | 246 |
						250 | 254 | 258 | 262 | 266 | 270 | 274 | 278 | 282 | 286 | 290 | 294 | 298 | 302 | 306 | 310 | 314 | 318 | 322 | 326 | 330 | 334 |
						338 | 342 | 346 | 350:
						PlayState.main.flashBGEffect(NORMAL, 0.67, 0.35, 'linear');

					case 194 | 196 | 198 | 200 | 202 | 204 | 206 | 210 | 212 | 214 | 222:
						PlayState.main.flashBGEffect(NORMAL, 0.32, 0.35, 'linear');

					case 216 | 217 | 218 | 219 | 220:
						PlayState.main.flashBGEffect(NORMAL, 0.32, 0.1, 'linear');

					case 192:
						if (!Init.trueSettings.get('Disable Flashing Lights'))
							PlayState.camGame.flash(FlxColor.WHITE, 1.5);
						PlayState.main.flashBGEffect(NORMAL, 0.32, 0.35, 'linear');

					case 96 | 128 | 256 | 288:
						if (!Init.trueSettings.get('Disable Flashing Lights'))
							PlayState.camGame.flash(FlxColor.WHITE, 1.5);
						PlayState.main.flashBGEffect(NORMAL, 0.4, 0.35, 'linear');

					case 48 | 336 | 304 | 272 | 112 | 144:
						if (!Init.trueSettings.get('Disable Flashing Lights'))
							PlayState.camGame.flash(FlxColor.BLACK, 1.5);
						PlayState.main.flashBGEffect(NORMAL, 0.32, 1.2, 'linear');

					case 32:
						if (!Init.trueSettings.get('Disable Flashing Lights')) PlayState.camGame.flash(FlxColor.WHITE, 1.5);

					case 416:
						PlayState.camGame.visible = false;
						PlayState.camHUD.visible = false;
						for (i in PlayState.strumHUD)
						{
							i.visible = false;
						}

					case 224:
						PlayState.main.flashBGEffect(NORMAL, 0.4, 0.35, 'linear');
						if (!Init.trueSettings.get('Disable Flashing Lights')) PlayState.camGame.flash(FlxColor.WHITE, 1.5);

					case 320:
						PlayState.main.flashBGEffect(NORMAL, 0.4, 0.35, 'linear');
						if (!Init.trueSettings.get('Disable Flashing Lights')) PlayState.camGame.flash(FlxColor.WHITE, 1.5);
				}

			case 'Lunacy':
				if (curBeat == 100 || curBeat == 108 || curBeat == 116 || curBeat == 124 || curBeat == 132 || curBeat == 140 || curBeat == 148)
				{
					PlayState.main.flashBGEffect(NORMAL, 0.5, 0.5, 'sineOut');
				}

				if (curBeat == 160 || curBeat == 230 || curBeat == 240 || curBeat == 248 || curBeat == 256 || curBeat == 262 || curBeat == 272
					|| curBeat == 280 || curBeat == 280 || curBeat == 288 || curBeat == 296 || curBeat == 304 || curBeat == 312 || curBeat == 320
					|| curBeat == 328 || curBeat == 336 || curBeat == 344 || curBeat == 352)
				{
					PlayState.main.flashBGEffect(DARK, 0, 0.5, 'quadOut');
				}

				// Darkens BG
				if (curBeat == 156 || curBeat == 228 || curBeat == 238 || curBeat == 244 || curBeat == 252 || curBeat == 260 || curBeat == 270
					|| curBeat == 276 || curBeat == 284 || curBeat == 292 || curBeat == 300 || curBeat == 308 || curBeat == 316 || curBeat == 324
					|| curBeat == 332 || curBeat == 340 || curBeat == 348)
				{
					PlayState.main.flashBGEffect(DARK, 0.77, 0.5, 'quadOut');
				}

				if (curBeat == 424 || curBeat == 432 || curBeat == 440 || curBeat == 448 || curBeat == 456 || curBeat == 464 || curBeat == 472)
				{
					PlayState.main.flashBGEffect(NORMAL, 0.65, 1, 'sineOut');
				}

				if (curBeat == 32 || curBeat == 64)
				{
					if (PlayState.main.chromTween != null)
						PlayState.main.chromTween.cancel();

					PlayState.main.chromEffect = 0.27;

					PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
						chromEffect: 0.0001
					}, 1.5, {
						ease: FlxEase.sineOut,
						onComplete: function(twn:FlxTween)
						{
							PlayState.main.chromTween = null;
						}
					});
				}

				if (curBeat == 38 || curBeat == 40 || curBeat == 46 || curBeat == 48 || curBeat == 54 || curBeat == 56 || curBeat == 62 || curBeat == 70
					|| curBeat == 72 || curBeat == 78 || curBeat == 80 || curBeat == 86 || curBeat == 88 || curBeat == 102 || curBeat == 110
					|| curBeat == 118 || curBeat == 126 || curBeat == 134 || curBeat == 142 || curBeat == 150)
				{
					if (PlayState.main.chromTween != null)
						PlayState.main.chromTween.cancel();

					PlayState.main.chromEffect = 0.12;

					PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
						chromEffect: 0.0001
					}, 0.3, {
						ease: FlxEase.sineOut,
						onComplete: function(twn:FlxTween)
						{
							PlayState.main.chromTween = null;
						}
					});
				}

				if (curBeat == 96 || curBeat == 104 || curBeat == 112 || curBeat == 120 || curBeat == 128 || curBeat == 136 || curBeat == 144 || curBeat == 152)
				{
					if (PlayState.main.chromTween != null)
						PlayState.main.chromTween.cancel();

					PlayState.main.chromEffect = 0.32;

					PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
						chromEffect: 0.0001
					}, 2.1, {
						ease: FlxEase.sineOut,
						onComplete: function(twn:FlxTween)
						{
							PlayState.main.chromTween = null;
						}
					});
				}

				if (curBeat == 100 || curBeat == 108 || curBeat == 116 || curBeat == 124 || curBeat == 132 || curBeat == 140 || curBeat == 148)
				{
					if (PlayState.main.chromTween != null)
						PlayState.main.chromTween.cancel();

					PlayState.main.chromEffect = 0.4;

					PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
						chromEffect: 0.0001
					}, 1, {
						ease: FlxEase.sineOut,
						onComplete: function(twn:FlxTween)
						{
							PlayState.main.chromTween = null;
						}
					});
				}

				if (curBeat == 156)
				{
					if (PlayState.main.chromTween != null)
						PlayState.main.chromTween.cancel();

					PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
						chromEffect: 0.33
					}, 0.2, {
						ease: FlxEase.sineOut,
						onComplete: function(twn:FlxTween)
						{
							PlayState.main.chromTween = null;
						}
					});
				}

				if (curBeat == 158)
				{
					if (PlayState.main.chromTween != null)
						PlayState.main.chromTween.cancel();

					PlayState.main.chromEffect = 0.4;

					PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
						chromEffect: 0.0001
					}, 0.2, {
						ease: FlxEase.sineOut,
						onComplete: function(twn:FlxTween)
						{
							PlayState.main.chromTween = null;
						}
					});
				}

				if (curBeat == 160 || curBeat == 168 || curBeat == 176 || curBeat == 184 || curBeat == 192 || curBeat == 200 || curBeat == 208
					|| curBeat == 216 || curBeat == 224 || curBeat == 232 || curBeat == 240 || curBeat == 248 || curBeat == 256 || curBeat == 264
					|| curBeat == 272 || curBeat == 280 || curBeat == 288 || curBeat == 296 || curBeat == 304 || curBeat == 312 || curBeat == 320
					|| curBeat == 328 || curBeat == 336 || curBeat == 344)
				{
					if (PlayState.main.chromTween != null)
						PlayState.main.chromTween.cancel();

					PlayState.main.chromEffect = 0.55;

					PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
						chromEffect: 0.0001
					}, 0.6, {
						ease: FlxEase.sineOut,
						onComplete: function(twn:FlxTween)
						{
							PlayState.main.chromTween = null;
						}
					});
				}

				if (curBeat == 162 || curBeat == 170 || curBeat == 178 || curBeat == 186 || curBeat == 194 || curBeat == 202 || curBeat == 210
					|| curBeat == 218 || curBeat == 226 || curBeat == 234 || curBeat == 242 || curBeat == 250 || curBeat == 258 || curBeat == 266
					|| curBeat == 274 || curBeat == 282 || curBeat == 290 || curBeat == 298 || curBeat == 306 || curBeat == 314 || curBeat == 322
					|| curBeat == 330 || curBeat == 338 || curBeat == 346)
				{
					if (PlayState.main.chromTween != null)
						PlayState.main.chromTween.cancel();

					PlayState.main.chromEffect = 0.6;

					PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
						chromEffect: 0.0001
					}, 0.25, {
						ease: FlxEase.sineOut,
						onComplete: function(twn:FlxTween)
						{
							PlayState.main.chromTween = null;
						}
					});
				}

				if (curBeat == 163 || curBeat == 171 || curBeat == 179 || curBeat == 187 || curBeat == 195 || curBeat == 203 || curBeat == 211
					|| curBeat == 219 || curBeat == 227 || curBeat == 235 || curBeat == 243 || curBeat == 251 || curBeat == 259 || curBeat == 267
					|| curBeat == 275 || curBeat == 283 || curBeat == 291 || curBeat == 299 || curBeat == 307 || curBeat == 315 || curBeat == 323
					|| curBeat == 331 || curBeat == 339 || curBeat == 347)
				{
					if (PlayState.main.chromTween != null)
						PlayState.main.chromTween.cancel();

					PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
						chromEffect: 0.5
					}, 0.22, {
						ease: FlxEase.sineOut,
						onComplete: function(twn:FlxTween)
						{
							PlayState.main.chromTween = null;
							PlayState.main.chromEffect = 0.00001;
						}
					});
				}

				if (curBeat == 165 || curBeat == 173 || curBeat == 181 || curBeat == 189 || curBeat == 197 || curBeat == 205 || curBeat == 213
					|| curBeat == 221)
				{
					if (PlayState.main.chromTween != null)
						PlayState.main.chromTween.cancel();

					PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
						chromEffect: 0.35
					}, 0.2, {
						ease: FlxEase.sineOut,
						onComplete: function(twn:FlxTween)
						{
							PlayState.main.chromTween = null;
							PlayState.main.chromEffect = 0.00001;
						}
					});
				}

				if (curBeat == 166 || curBeat == 174 || curBeat == 182 || curBeat == 190 || curBeat == 198 || curBeat == 206 || curBeat == 214
					|| curBeat == 222)
				{
					if (PlayState.main.chromTween != null)
						PlayState.main.chromTween.cancel();

					PlayState.main.chromEffect = 0.45;

					PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
						chromEffect: 0.0001
					}, 0.2, {
						ease: FlxEase.sineOut,
						onComplete: function(twn:FlxTween)
						{
							PlayState.main.chromTween = null;
						}
					});
				}

				if (curBeat == 167 || curBeat == 175 || curBeat == 183 || curBeat == 191 || curBeat == 199 || curBeat == 207 || curBeat == 215
					|| curBeat == 223)
				{
					if (PlayState.main.chromTween != null)
						PlayState.main.chromTween.cancel();

					PlayState.main.chromEffect = 0.56;

					PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
						chromEffect: 0.0001
					}, 0.2, {
						ease: FlxEase.sineOut,
						onComplete: function(twn:FlxTween)
						{
							PlayState.main.chromTween = null;
						}
					});
				}

				if (curBeat >= 228 && curBeat <= 231 || curBeat >= 236 && curBeat <= 239 || curBeat >= 244 && curBeat <= 247 || curBeat >= 252
					&& curBeat <= 255 || curBeat >= 260 && curBeat <= 263 || curBeat >= 168 && curBeat <= 171 || curBeat >= 276 && curBeat <= 279
					|| curBeat >= 284 && curBeat <= 287 || curBeat >= 292 && curBeat <= 295 || curBeat >= 300 && curBeat <= 303 || curBeat >= 308
					&& curBeat <= 311 || curBeat >= 316 && curBeat <= 319 || curBeat >= 324 && curBeat <= 327 || curBeat >= 332 && curBeat <= 335
					|| curBeat >= 340 && curBeat <= 343 || curBeat >= 348 && curBeat <= 351)
				{
					if (PlayState.main.chromTween != null)
						PlayState.main.chromTween.cancel();

					PlayState.main.chromEffect = 0.32;

					PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
						chromEffect: 0.00001
					}, 0.22, {
						ease: FlxEase.sineOut,
						onComplete: function(twn:FlxTween)
						{
							PlayState.main.chromTween = null;
						}
					});
				}

				if (curBeat == 352 || curBeat == 354 || curBeat == 356 || curBeat == 358 || curBeat == 360 || curBeat == 362 || curBeat == 364
					|| curBeat == 366 || curBeat == 368 || curBeat == 370 || curBeat == 372 || curBeat == 374 || curBeat == 376 || curBeat == 378
					|| curBeat == 380 || curBeat == 382 || curBeat == 384 || curBeat == 386 || curBeat == 388 || curBeat == 390 || curBeat == 392
					|| curBeat == 394 || curBeat == 396 || curBeat == 398 || curBeat == 400 || curBeat == 402 || curBeat == 404 || curBeat == 406
					|| curBeat == 408 || curBeat == 410 || curBeat == 416 || curBeat == 418 || curBeat == 420 || curBeat == 422 || curBeat == 424
					|| curBeat == 426 || curBeat == 428 || curBeat == 430 || curBeat == 432 || curBeat == 434 || curBeat == 436 || curBeat == 438
					|| curBeat == 440 || curBeat == 442 || curBeat == 444 || curBeat == 446 || curBeat == 448 || curBeat == 450 || curBeat == 452
					|| curBeat == 454 || curBeat == 456 || curBeat == 458 || curBeat == 460 || curBeat == 462 || curBeat == 464 || curBeat == 466
					|| curBeat == 468 || curBeat == 470 || curBeat == 472 || curBeat == 474)
				{
					if (PlayState.main.chromTween != null)
						PlayState.main.chromTween.cancel();

					PlayState.main.chromEffect = 0.3;

					PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
						chromEffect: 0.00001
					}, 0.5, {
						ease: FlxEase.sineOut,
						onComplete: function(twn:FlxTween)
						{
							PlayState.main.chromTween = null;
						}
					});
				}

				if (curBeat == 412)
				{
					if (PlayState.main.chromTween != null)
						PlayState.main.chromTween.cancel();

					PlayState.main.chromEffect = 0.36;

					PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
						chromEffect: 0.00001
					}, 1, {
						ease: FlxEase.sineOut,
						onComplete: function(twn:FlxTween)
						{
							PlayState.main.chromTween = null;
						}
					});
				}

				if (curBeat == 476)
				{
					if (PlayState.main.chromTween != null)
						PlayState.main.chromTween.cancel();

					PlayState.main.chromTween = FlxTween.tween(PlayState.main, {
						chromEffect: 0.85
					}, 1.6, {
						ease: FlxEase.sineOut,
						onComplete: function(twn:FlxTween)
						{
							PlayState.main.chromTween = null;
						}
					});
				}

				if (curBeat == 480)
				{
					PlayState.main.chromTween.cancel();

					PlayState.main.chromEffect = 0.00001;
				}

				switch (curBeat)
				{
					// I'm NOT gonna have a fun time recoding all this for the BG dimming in and out later lmao

					case 16: FlxTween.tween(PlayState.camGame, {alpha: 1}, 3, {ease: FlxEase.quadOut});

					case 32:
						if (!Init.trueSettings.get('Disable Flashing Lights')) PlayState.camGame.flash(FlxColor.BLACK, 1.5);

					case 38 | 46 | 54 | 62:
						FlxG.camera.zoom += 0.065;

					case 40 | 48 | 56:
						PlayState.defaultCamZoom += 0.15;

					case 64:
						if (!Init.trueSettings.get('Disable Flashing Lights'))
							PlayState.camGame.flash(FlxColor.BLACK, 0.9);
						PlayState.defaultCamZoom = 0.87;

					case 70 | 78 | 86:
						FlxG.camera.zoom += 0.045;

					case 72 | 80 | 88:
						if (!Init.trueSettings.get('Disable Flashing Lights'))
							PlayState.camGame.flash(FlxColor.BLACK, 0.9);
						PlayState.defaultCamZoom += 0.15;

					case 96:
						PlayState.defaultCamZoom = 0.75;
						if (!Init.trueSettings.get('Disable Flashing Lights'))
							PlayState.camGame.flash(FlxColor.WHITE, 1.5);
						FlxTween.tween(PlayState.camHUD, {alpha: 1}, 2, {ease: FlxEase.sineOut});
						for (i in PlayState.strumHUD)
						{
							FlxTween.tween(i, {alpha: 1}, 1.5, {ease: FlxEase.sineOut});
						}

					case 128 | 256:
						if (!Init.trueSettings.get('Disable Flashing Lights')) PlayState.camGame.flash(FlxColor.WHITE, 1.5);

					case 156:
						PlayState.defaultCamZoom = 1.05;

					case 160:
						PlayState.defaultCamZoom = 0.7;
						if (!Init.trueSettings.get('Disable Flashing Lights')) PlayState.camGame.flash(FlxColor.BLACK, 1.5);

					case 192:
						PlayState.defaultCamZoom = 0.75;
					case 200 | 238 | 270 | 316 | 332 | 344:
						PlayState.defaultCamZoom = 0.8;
					case 208:
						PlayState.defaultCamZoom = 0.85;
					case 216 | 252 | 284:
						PlayState.defaultCamZoom = 0.9;
					case 220:
						PlayState.defaultCamZoom = 0.95;
					case 222 | 235 | 267 | 239 | 271 | 334:
						PlayState.defaultCamZoom = 1;

					case 224 | 288:
						PlayState.defaultCamZoom = 0.75;
						if (!Init.trueSettings.get('Disable Flashing Lights'))
							PlayState.camGame.flash(FlxColor.WHITE, 1.5);
						FlxTween.tween(PlayState.camHUD, {alpha: 0}, 3, {ease: FlxEase.sineInOut});
						for (i in PlayState.strumHUD)
						{
							FlxTween.tween(i, {alpha: 0}, 3, {ease: FlxEase.sineInOut});
						}

					case 228 | 260 | 292 | 286:
						PlayState.defaultCamZoom = 1.1;

					case 230 | 262 | 296 | 312 | 236 | 268:
						PlayState.defaultCamZoom = 0.65;

					case 232 | 264:
						if (!Init.trueSettings.get('Disable Flashing Lights'))
							PlayState.camGame.flash(FlxColor.WHITE, 1.5);
						PlayState.defaultCamZoom = 0.9;

					case 233 | 266 | 412 | 240 | 272 | 300 | 304 | 336 | 248 | 280 | 328:
						PlayState.defaultCamZoom = 0.7;

					case 320:
						if (!Init.trueSettings.get('Disable Flashing Lights'))
							PlayState.camGame.flash(FlxColor.WHITE, 1.5);
						PlayState.defaultCamZoom = 0.7;

					case 254:
						PlayState.defaultCamZoom = 1.1;
						FlxTween.tween(PlayState.camHUD, {alpha: 1}, 1, {ease: FlxEase.sineInOut});
						for (i in PlayState.strumHUD)
						{
							FlxTween.tween(i, {alpha: 1}, 1, {ease: FlxEase.sineInOut});
						}

					case 318:
						PlayState.defaultCamZoom = 1.25;
						FlxTween.tween(PlayState.camHUD, {alpha: 1}, 1, {ease: FlxEase.sineInOut});
						for (i in PlayState.strumHUD)
						{
							FlxTween.tween(i, {alpha: 1}, 1, {ease: FlxEase.sineInOut});
						}

					case 310 | 342 | 350:
						PlayState.defaultCamZoom = 1.25;

					case 352:
						PlayState.defaultCamZoom = 0.65;
						FlxTween.tween(PlayState.camHUD, {alpha: 0.25}, 8, {ease: FlxEase.sineInOut});
						for (i in PlayState.strumHUD)
						{
							FlxTween.tween(i, {alpha: 0.25}, 8, {ease: FlxEase.sineInOut});
						}
						FlxTween.tween(PlayState, {health: 0.01}, 20);
						if (globalGradient != null)
							FlxTween.tween(globalGradient, {alpha: 0.8}, 10);
						FlxTween.tween(FlxG.camera, {zoom: 1.1}, 18, {startDelay: 2});

					case 408:
						PlayState.defaultCamZoom = 0.9;
						FlxTween.tween(PlayState.camHUD, {alpha: 0.36}, 4, {ease: FlxEase.sineInOut});
						for (i in PlayState.strumHUD)
						{
							FlxTween.tween(i, {alpha: 0.36}, 4, {ease: FlxEase.sineInOut});
						}

					case 416: if (!Init.trueSettings.get('Disable Flashing Lights')) PlayState.camGame.flash(FlxColor.WHITE, 1.5);

					case 480:
						if (!Init.trueSettings.get('Disable Flashing Lights'))
							PlayState.camGame.flash(FlxColor.BLACK, 1.5);
						PlayState.camHUD.alpha = 0;
						for (i in PlayState.strumHUD)
						{
							i.alpha = 0;
						}

					case 506:
						FlxTween.tween(PlayState.camHUD, {alpha: 0.5}, 4, {ease: FlxEase.sineInOut});
						for (i in PlayState.strumHUD)
						{
							FlxTween.tween(i, {alpha: 0.5}, 4, {ease: FlxEase.sineInOut});
						}

					case 536:
						FlxTween.tween(PlayState.camHUD, {alpha: 0}, 2, {ease: FlxEase.sineInOut});
						for (i in PlayState.strumHUD)
						{
							FlxTween.tween(i, {alpha: 0}, 2, {ease: FlxEase.sineInOut});
						}

					case 540:
						FlxTween.tween(PlayState.camGame, {alpha: 0}, 5, {ease: FlxEase.quartInOut});
				}

			case 'Delusional':
				if (curBeat == 146)
					PlayState.main.manageLyrics('bf-demon', 'Count the minutes...', 'disneyFreeplayFont', 30, 1.1, 'sineInOut');
				if (curBeat == 150)
					PlayState.main.manageLyrics('bf-demon', "...of how long...", 'disneyFreeplayFont', 30, 1, 'sineInOut');
				if (curBeat == 154)
					PlayState.main.manageLyrics('bf-demon', "...this show will play!", 'disneyFreeplayFont', 30, 2.2, 'quartInOut');
				if (curBeat == 162)
					PlayState.main.manageLyrics('bf-demon', "And remind yourself...", 'disneyFreeplayFont', 30, 1.3, 'sineInOut');
				if (curBeat == 167)
					PlayState.main.manageLyrics('bf-demon', "...no matter what's in...", 'disneyFreeplayFont', 30, 2, 'sineInOut');
				if (curBeat == 174)
					PlayState.main.manageLyrics('bf-demon', "...THE WAY!", 'disneyFreeplayFont', 30, 1, 'circOut');
				if (curBeat == 178)
					PlayState.main.manageLyrics('bf-demon', "All your dreams...", 'disneyFreeplayFont', 30, 1, 'sineInOut');
				if (curBeat == 182)
					PlayState.main.manageLyrics('bf-demon', "...ARE SO FAR OUT OF REACH!", 'disneyFreeplayFont', 30, 4, 'quartInOut');
				if (curBeat == 190)
					PlayState.main.manageLyrics('bf-demon', "But if YOUR delusions...", 'disneyFreeplayFont', 30, 2.2, 'sineInOut');
				if (curBeat == 196)
					PlayState.main.manageLyrics('bf-demon', "...still surround ya.", 'disneyFreeplayFont', 30, 1.3, "quartOut");
				if (curBeat == 200)
					PlayState.main.manageLyrics('bf-demon', "Let's LOOP 'ROUND ONCE MORE.", 'satanFont', 30, 3, "sineInOut");

				switch (curBeat)
				{
					case 132: PlayState.defaultCamZoom = 1.3;
					case 136:
						FlxG.camera.fade();
						for (daUIs in PlayState.main.allUIs)
							FlxTween.tween(daUIs, {alpha: 0}, 3);
					// BF Starts Singing Some Lyrics
					case 144:
						PlayState.defaultCamZoom = 0.8;
						FlxG.camera.fade(0x000000, 5, true);
					case 152 | 170:
						PlayState.main.flashBGEffect(DARK, 0.2, 0.3, 'quartInOut');
						PlayState.defaultCamZoom = 0.9;
					case 154 | 172:
						PlayState.main.flashBGEffect(DARK, 0.4, 0.3, 'quartInOut');
						PlayState.defaultCamZoom = 1;
					case 156:
						PlayState.main.flashBGEffect(DARK, 0.6, 0.3, 'quartInOut');
						PlayState.defaultCamZoom = 1.1;
					case 158 | 174:
						PlayState.main.flashBGEffect(DARK, 0.8, 0.3, 'quartInOut');
						PlayState.defaultCamZoom = 1.2;
					case 160:
						PlayState.main.flashBGEffect(DARK, 0, 0.3, 'quartInOut');
						PlayState.defaultCamZoom = 0.8;
					case 168:
						PlayState.main.flashBGEffect(DARK, 0.1, 0.3, 'quartInOut');
						PlayState.defaultCamZoom = 0.85;
					case 176:
						PlayState.main.flashBGEffect(DARK, 0, 0.3, 'quartInOut');
						PlayState.defaultCamZoom = 0.75;
						PlayState.camGame.flash(FlxColor.WHITE, 1);
					case 180 | 188 | 196:
						PlayState.camGame.zoom += 0.3;
						PlayState.main.flashBGEffect(NORMAL, 0.5, 0.35, 'linear');
					case 184 | 192 | 200:
						PlayState.camGame.zoom += 0.15;
						PlayState.main.flashBGEffect(NORMAL, 0.25, 0.35, 'linear');
					case 204: PlayState.defaultCamZoom = 1;
					case 208:
						PlayState.camGame.visible = false;
						PlayState.defaultCamZoom = 1.3;
					// Mickey Screams Like A Bitch
					case 212:
						PlayState.main.chromEffect = 0.3;
						PlayState.main.chromTween = FlxTween.tween(PlayState.main, {chromEffect: 1}, 1.2);
						PlayState.camGame.visible = true;
						PlayState.defaultCamZoom = 0.75;
						PlayState.camGame.shake(0.01, 1.2);
					// The Drop Starts
					case 216:
						FlxTween.tween(PlayState.camHUD, {alpha: 1}, 1, {ease: FlxEase.quadOut});
						for (i in PlayState.strumHUD)
							FlxTween.tween(i, {alpha: 1}, 1, {ease: FlxEase.quadOut});
						PlayState.main.chromTween.cancel();
						PlayState.main.chromTween = FlxTween.tween(PlayState.main, {chromEffect: 0.18}, 0.6, {ease: FlxEase.sineOut});
						if (!Init.trueSettings.get("Disable Flashing Lights"))
							PlayState.camGame.flash(FlxColor.WHITE, 0.5);
						if (PlayState.main.canaddshaders)
						{
                            if (!Init.trueSettings.get('Low Quality'))
                            {
                                PlayState.camGame.setFilters([
                                    new ShaderFilter(PlayState.dramaticCamMovement),
                                    new ShaderFilter(PlayState.bloomEffect),
                                    new ShaderFilter(PlayState.monitorFilter),
                                    new ShaderFilter(PlayState.chromZoomShader),
                                    new ShaderFilter(PlayState.chromNormalShader),
                                    new ShaderFilter(PlayState.delusionalShift)
                                ]);
                                PlayState.camHUD.setFilters([new ShaderFilter(PlayState.chromNormalShader), new ShaderFilter(PlayState.delusionalShift)]);
                                for (i in PlayState.strumHUD)
                                    i.setFilters([
                                        new ShaderFilter(PlayState.grayScale),
                                        new ShaderFilter(PlayState.chromNormalShader),
                                        new ShaderFilter(PlayState.delusionalShift)
                                    ]);
                            }
                            else
                            {
                                PlayState.camGame.setFilters([
                                    new ShaderFilter(PlayState.monitorFilter),
                                    new ShaderFilter(PlayState.chromZoomShader),
                                    new ShaderFilter(PlayState.chromNormalShader),
                                    new ShaderFilter(PlayState.delusionalShift)
                                ]);
                                PlayState.camHUD.setFilters([new ShaderFilter(PlayState.chromNormalShader), new ShaderFilter(PlayState.delusionalShift)]);
                                for (i in PlayState.strumHUD)
                                    i.setFilters([
                                        new ShaderFilter(PlayState.grayScale),
                                        new ShaderFilter(PlayState.chromNormalShader),
                                        new ShaderFilter(PlayState.delusionalShift)
                                    ]);
                            }
						}
					case 228:
						PlayState.main.chromTween = null;
						PlayState.defaultCamZoom = 0.85;
					case 230: PlayState.defaultCamZoom = 1;
					case 232: PlayState.defaultCamZoom = 0.75;
					case 278: PlayState.defaultCamZoom = 1;
					case 280 | 312 | 344: PlayState.defaultCamZoom = 0.7;
					case 288 | 296 | 304 | 320 | 328 | 336: PlayState.defaultCamZoom += 0.1;
					case 308: PlayState.defaultCamZoom += 0.2;
					case 340: PlayState.defaultCamZoom += 0.3;
					case 356 | 388: PlayState.defaultCamZoom = 1.2;
					case 358 | 390: PlayState.defaultCamZoom = 1.3;
					case 360: PlayState.defaultCamZoom = 0.75;
					case 375:
						PlayState.main.chromTween = FlxTween.tween(PlayState.main, {chromEffect: 1}, 0.1, {ease: FlxEase.sineInOut});
						tweenCamera(1.5, 0.1, 'sineInOut');
					case 376:
						PlayState.main.chromTween.cancel();
						PlayState.main.chromTween = null;
						PlayState.camGame.visible = false;
						PlayState.camHUD.visible = false;
					case 377:
						PlayState.camGame.visible = true;
						PlayState.camHUD.visible = true;
						if (!Init.trueSettings.get("Disable Flashing Lights"))
							PlayState.camGame.flash(FlxColor.WHITE, 1);
						PlayState.defaultCamZoom = 0.8;
						PlayState.main.chromTween = FlxTween.tween(PlayState.main, {chromEffect: 0.1}, 0.6, {ease: FlxEase.quadOut});
					case 472:
						PlayState.camGame.visible = false;
						PlayState.camHUD.visible = false;
						for (i in PlayState.strumHUD)
							i.visible = false;
					case 473:
						if (PlayState.main.canaddshaders)
						{
                            if (!Init.trueSettings.get("Low Quality"))
                            {
                                PlayState.camGame.setFilters([
                                    new ShaderFilter(PlayState.dramaticCamMovement),
                                    new ShaderFilter(PlayState.bloomEffect),
                                    new ShaderFilter(PlayState.monitorFilter),
                                    new ShaderFilter(PlayState.chromZoomShader),
                                    new ShaderFilter(PlayState.chromNormalShader)
                                ]);
                               PlayState.camHUD.setFilters([new ShaderFilter(PlayState.chromNormalShader)]);
                                for (i in PlayState.strumHUD)
                                    i.setFilters([new ShaderFilter(PlayState.grayScale), new ShaderFilter(PlayState.chromNormalShader)]);
                            }
                            else
                            {
                                PlayState.camGame.setFilters([
                                    new ShaderFilter(PlayState.monitorFilter),
                                    new ShaderFilter(PlayState.chromZoomShader),
                                    new ShaderFilter(PlayState.chromNormalShader)
                                ]);
                                PlayState.camHUD.setFilters([new ShaderFilter(PlayState.chromNormalShader)]);
                                for (i in PlayState.strumHUD)
                                    i.setFilters([new ShaderFilter(PlayState.grayScale), new ShaderFilter(PlayState.chromNormalShader)]);
                            }
						}
						PlayState.main.chromEffect = 0.00001;
						PlayState.defaultCamZoom = 0.85;
                        PlayState.bfStrums.receptors.members[0].x = 77;
                        PlayState.bfStrums.receptors.members[1].x = 187;
                        PlayState.bfStrums.receptors.members[2].x = 302;
                        PlayState.bfStrums.receptors.members[3].x = 417;
                        //too fucking lazy to do the math in my head again so here's me doing the math in the code cause i'm sooo fucking lazy afjhsdgyfvhu (don)
                        PlayState.dadStrums.receptors.members[0].x = 77 + 640;
                        PlayState.dadStrums.receptors.members[1].x = 187 + 640;
                        PlayState.dadStrums.receptors.members[2].x = 302 + 640;
                        PlayState.dadStrums.receptors.members[3].x = 417 + 640;
					case 480:
						// no healthbar to add more onto the atmosphere of this section
						PlayState.camGame.visible = true;
						for (i in PlayState.strumHUD)
							i.visible = true;
					case 720:
						FlxTween.tween(PlayState.camGame, {alpha: 0.0001}, 5, {ease: FlxEase.quartInOut});
						for (i in PlayState.strumHUD)
							FlxTween.tween(i, {alpha: 0.0001}, 5, {ease: FlxEase.quartInOut});
					case 740:
						PlayState.defaultCamZoom = 0.5;
                        PlayState.dadStrums.receptors.members[0].x = 77;
                        PlayState.dadStrums.receptors.members[1].x = 187;
                        PlayState.dadStrums.receptors.members[2].x = 302;
                        PlayState.dadStrums.receptors.members[3].x = 417;
                        //too fucking lazy to do the math in my head again so here's me doing the math in the code cause i'm sooo fucking lazy afjhsdgyfvhu (don)
                        PlayState.bfStrums.receptors.members[0].x = 77 + 640;
                        PlayState.bfStrums.receptors.members[1].x = 187 + 640;
                        PlayState.bfStrums.receptors.members[2].x = 302 + 640;
                        PlayState.bfStrums.receptors.members[3].x = 417 + 640;
					case 744:
						PlayState.camGame.alpha = 1;
						PlayState.camHUD.visible = true;
						PlayState.defaultCamZoom = 0.9;
						for (i in PlayState.strumHUD)
							i.alpha = 1;
						PlayState.main.chromEffect = 0.1;
						if (!Init.trueSettings.get("Disable Flashing Lights"))
							PlayState.camGame.flash(FlxColor.WHITE, 0.5);
						if (PlayState.main.canaddshaders)
						{
                            if (!Init.trueSettings.get("Low Quality"))
                            {
                                PlayState.camGame.setFilters([
                                    new ShaderFilter(PlayState.dramaticCamMovement),
                                    new ShaderFilter(PlayState.bloomEffect),
                                    new ShaderFilter(PlayState.monitorFilter),
                                    new ShaderFilter(PlayState.chromZoomShader),
                                    new ShaderFilter(PlayState.chromNormalShader),
                                    new ShaderFilter(PlayState.delusionalShift)
                                ]);
                                PlayState.camHUD.setFilters([new ShaderFilter(PlayState.chromNormalShader), new ShaderFilter(PlayState.delusionalShift)]);
                                for (i in PlayState.strumHUD)
                                    i.setFilters([
                                        new ShaderFilter(PlayState.grayScale),
                                        new ShaderFilter(PlayState.chromNormalShader),
                                        new ShaderFilter(PlayState.delusionalShift)
                                    ]);
                            }
                            else
                            {
                                PlayState.camGame.setFilters([
                                    new ShaderFilter(PlayState.monitorFilter),
                                    new ShaderFilter(PlayState.chromZoomShader),
                                    new ShaderFilter(PlayState.chromNormalShader),
                                    new ShaderFilter(PlayState.delusionalShift)
                                ]);
                                PlayState.camHUD.setFilters([new ShaderFilter(PlayState.chromNormalShader), new ShaderFilter(PlayState.delusionalShift)]);
                                for (i in PlayState.strumHUD)
                                    i.setFilters([
                                        new ShaderFilter(PlayState.grayScale),
                                        new ShaderFilter(PlayState.chromNormalShader),
                                        new ShaderFilter(PlayState.delusionalShift)
                                    ]);
                            }
						}
					case 1086:
						FlxTween.tween(PlayState.camHUD, {alpha: 0}, 2);
						for (i in PlayState.strumHUD)
							FlxTween.tween(i, {alpha: 0}, 2);
						FlxG.sound.play(Paths.sound('funkinAVI/Mickey_fuckin_dying'));
						PlayState.main.flashBGEffect(DARK, 0.5, 5);
					case 1134:
						PlayState.main.flashBGEffect(DARK, 1, 0.5, 'sineOut');
					case 1136:
						PlayState.main.flashBGEffect(NORMAL, 1, 0.3, 'sineOut');
					case 1144:
						FlxTween.tween(PlayState.camGame, {alpha: 0}, 4);
				}

			case 'Delusion':
				switch (curBeat)
				{
					case 1:
						FlxTween.tween(PlayState.camGame, {alpha: 1}, 2);
					case 8:
						PlayState.defaultCamZoom -= 0.08;
						PlayState.main.flashBGEffect(NORMAL, 0.5, 0.35, 'linear');
						FlxTween.tween(PlayState.camHUD, {alpha: 1}, 0.4);
						for (i in PlayState.strumHUD)
							FlxTween.tween(i, {alpha: 1}, 0.3);
					case 16: PlayState.defaultCamZoom += 0.1;
					case 24:
						PlayState.camGame.zoom += 0.12;
						PlayState.defaultCamZoom -= 0.2;
						PlayState.main.flashBGEffect(NORMAL, 0.35, 0.45, 'circOut', [255, 135, 135, 1]);
					case 25 | 26 | 27 | 28 | 29 | 30 | 31 | 32 | 33 | 34 | 35 | 41 | 42 | 43 | 44 | 45 | 46 | 47 | 48 | 49 | 50 | 51 | 52 | 53 | 54 | 55 | 56 | 57 | 58 | 59 | 60 | 61 | 62 | 63 | 64 | 65 | 66 | 67 | 68 | 69 | 70 | 71 | 137 | 138 | 139 | 140 | 141 | 142 | 143 | 144 | 145 | 146 | 147 | 148 | 149 | 150 | 151 | 152 | 153 | 154 | 155 | 156 | 157 | 158 | 159 | 160 | 161 | 162 | 163 | 164 | 165 | 166 | 167 | 168 | 169 | 170 | 171 | 172 | 173 | 174 | 175 | 176 | 177 | 178 | 179 | 180 | 181 | 182 | 183 | 184 | 185 | 186 | 187 | 188 | 189 | 190 | 191 | 192:
						PlayState.main.flashBGEffect(NORMAL, 0.35, 0.45, 'circOut', [255, 135, 135, 1]);
						PlayState.camGame.zoom += 0.1;
					case 72 | 73 | 74 | 75 | 76 | 77 | 78 | 79 | 80 | 81 | 82 | 83 | 84 | 85 | 86 | 87:
						PlayState.main.flashBGEffect(NORMAL, 0.56, 0.45, 'circOut', [255, 135, 135, 1]);
						PlayState.camGame.zoom += 0.16;
					case 88 | 89 | 90 | 91 | 92 | 93 | 94 | 95 | 96 | 97 | 98 | 99 | 100 | 101:
						PlayState.main.flashBGEffect(NORMAL, 0.89, 0.45, 'circOut', [255, 135, 135, 1]);
						PlayState.camGame.zoom += 0.21;
					case 36 | 134:
						PlayState.main.flashBGEffect(DARK, 0.8, 0.21, 'sineOut');
						PlayState.defaultCamZoom += 0.3;
					case 40:
						PlayState.defaultCamZoom -= 0.25;
						PlayState.main.flashBGEffect(NORMAL, 0.6, 0.3, 'circOut', [255, 135, 135, 1]);
						PlayState.camGame.zoom += 0.16;
					case 104 | 112 | 120 | 128:
						PlayState.camGame.zoom += 0.25;
						PlayState.main.flashBGEffect(NORMAL, 0.6, 0.3, 'circOut', [255, 135, 135, 1]);
					case 136:
						PlayState.main.flashBGEffect(NORMAL, 0.35, 0.45, 'circOut', [255, 135, 135, 1]);
						PlayState.camGame.zoom += 0.1;
						PlayState.defaultCamZoom += 0.11;
					case 108 | 116:
						PlayState.main.flashBGEffect(DARK, 0.2, 0.35, 'sineOut');
					case 110 | 118:
						PlayState.main.flashBGEffect(DARK, 0.5, 0.35, 'sineOut');
				}

				if (curBeat >= 72 && curBeat <= 87)
				{
					PlayState.main.effectRed = 1;

					if (PlayState.main.vignetteTween != null)
						PlayState.main.vignetteTween.cancel();

					PlayState.main.vignetteTween = FlxTween.tween(PlayState.main, {effectRed: 0.0}, 0.4, {ease: FlxEase.sineOut, onComplete: 
						function(twn:FlxTween)
							{
								PlayState.main.vignetteTween = null;
							}
						}
					);
				}

				if (curBeat >= 88 && curBeat <= 103)
					{
						PlayState.main.effectRed = 1.2;
						
						if (PlayState.main.vignetteTween != null)
							PlayState.main.vignetteTween.cancel();
	
						PlayState.main.vignetteTween = FlxTween.tween(PlayState.main, {effectRed: 0.0}, 0.4, {ease: FlxEase.sineOut, onComplete: 
							function(twn:FlxTween)
								{
									PlayState.main.vignetteTween = null;
								}
							}
						);
					}

			case 'Scrapped':
				switch (curBeat)
				{
					case 64: FlxTween.tween(PlayState.opponent, {alpha: 1}, 10);
					case 424: FlxTween.tween(PlayState.opponent, {alpha: 0}, 5);
				}

			case 'Mercy Legacy':
				if (!Init.trueSettings.get('Disable Mechanics'))
				{
					if (curBeat >= 0 && curBeat <= 63)
						PlayState.health -= 0.02;
					else if (curBeat >= 64 && curBeat <= 95)
						PlayState.health -= 0.2;
					else if (curBeat >= 96 && curBeat <= 127)
						PlayState.health -= 0.06;
					else if (curBeat >= 128 && curBeat <= 191)
						PlayState.health -= 0.16;
					else if (curBeat >= 192 && curBeat <= 255)
						PlayState.health -= 0.1;
					else if (curBeat >= 256 && curBeat <= 319)
						PlayState.health -= 0.18;
					else if (curBeat >= 320)
						PlayState.health -= 0.01;
				}

			case 'Mercy':
				// Cam Stuff Handler
				switch (curBeat)
				{
					case 16:
						FlxTween.tween(PlayState.camGame, {alpha: 1}, 5, {ease: FlxEase.sineInOut});
						FlxTween.tween(PlayState.camHUD, {alpha: 1}, 5, {ease: FlxEase.sineInOut, startDelay: 1.5});
						PlayState.defaultCamZoom = 1.3;

					case 32: PlayState.defaultCamZoom = 1.2;
					case 40: PlayState.defaultCamZoom = 1.1;
					case 48: PlayState.defaultCamZoom = 1;
					case 56: PlayState.defaultCamZoom = 0.9;
					case 64: PlayState.defaultCamZoom = 0.75;

					// Very Spooky Phase 2 Walt (real)
					case 256:
						FlxTween.tween(PlayState.camGame, {alpha: 0}, 1, {ease: FlxEase.sineInOut});
						FlxTween.tween(PlayState.camHUD, {alpha: 0}, 1, {ease: FlxEase.sineInOut});
						for (i in PlayState.strumHUD)
						{
							FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.sineInOut});
						}

					case 264:
						FlxTween.tween(PlayState.camGame, {alpha: 1}, 2, {ease: FlxEase.sineInOut});
						PlayState.defaultCamZoom = 1.3;

					case 275:
						PlayState.defaultCamZoom = 0.8;
						FlxTween.tween(PlayState.camHUD, {alpha: 1}, 0.31, {ease: FlxEase.sineInOut});
						for (i in PlayState.strumHUD)
						{
							FlxTween.tween(i, {alpha: 1}, 0.31, {ease: FlxEase.sineInOut});
						}
						if (!Init.trueSettings.get('Disable Mechanics')) PlayState.main.inkFormWarning.alpha = 1;

					case 276:
						if (!Init.trueSettings.get('Disable Mechanics')) FlxTween.tween(PlayState.main.inkFormWarning, {alpha: 0}, 2, {ease: FlxEase.sineInOut});

					// Final Stretch
					case 494:
						PlayState.camHUD.flash(FlxColor.WHITE, 3);
						PlayState.camGame.visible = false;
						FlxTween.tween(PlayState.bfStrums, {alpha: 0}, 1, {ease: FlxEase.sineInOut});
						FlxTween.tween(PlayState.camHUD, {alpha: 0}, 1, {ease: FlxEase.sineInOut, startDelay: 3});
						for (i in PlayState.strumHUD)
						{
							FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.sineInOut, startDelay: 3});
						}
						if (!Init.trueSettings.get('Disable Mechanics')) FlxTween.tween(PlayState.main.spaceBarCounter, {alpha: 0}, 2, {ease: FlxEase.sineInOut});
				}

				if (!Init.trueSettings.get('Disable Mechanics'))
				{
					// Health Drain Shit
					if (curBeat >= 0 && curBeat <= 63)
						PlayState.health -= 0.005;
					else if (curBeat >= 64 && curBeat <= 79)
						PlayState.health -= 0.01;
					else if (curBeat >= 80 && curBeat <= 87)
						PlayState.health -= 0.07;
					else if (curBeat >= 88 && curBeat <= 95)
						PlayState.health -= 0.01;
					else if (curBeat >= 96 && curBeat <= 127)
						PlayState.health -= 0.03;
					else if (curBeat >= 128 && curBeat <= 159)
						PlayState.health -= 0.1;
					else if (curBeat >= 160 && curBeat <= 191)
						PlayState.health -= 0.06;
					else if (curBeat >= 192 && curBeat <= 207)
						PlayState.health -= 0.01;
					else if (curBeat >= 208 && curBeat <= 239)
						PlayState.health -= 0.04;
					else if (curBeat >= 240 && curBeat <= 255)
						PlayState.health -= 0.005;
					else if (curBeat >= 256 && curBeat <= 291)
						PlayState.health -= 0.03;
					else if (curBeat >= 292 && curBeat <= 307)
						PlayState.health -= 0.05;
					else if (curBeat >= 308 && curBeat <= 339)
						PlayState.health -= 0.085;
					else if (curBeat >= 340 && curBeat <= 371)
						PlayState.health -= 0.1;
					else if (curBeat >= 372 && curBeat <= 387)
						PlayState.health -= 0.11;
					else if (curBeat >= 388 && curBeat <= 403)
						PlayState.health -= 0.12;
					else if (curBeat >= 404 && curBeat <= 451)
						PlayState.health -= 0.14;
					else if (curBeat >= 452 && curBeat <= 467)
						PlayState.health -= 0.17;
					else if (curBeat >= 468 && curBeat <= 475)
						PlayState.health -= 0.21;
					else if (curBeat >= 476 && curBeat <= 489)
						PlayState.health -= 0.25;
					else if (curBeat >= 490)
						PlayState.health -= 0.02;
				}

			case 'Cycled Sins':
				if (!Init.trueSettings.get("Disable Mechanics"))
				{
					switch (curBeat)
					{
						// Intro Cam Shit
						case 16: PlayState.camGame.alpha = 1;
						case 32: tweenCamera(0.85, 5.5, 'quartInOut');
						case 46:
							tweenCamera(0.6, 0.6, 'sineInOut');
							for (fuckTheseArrays in PlayState.strumHUD)
								FlxTween.tween(fuckTheseArrays, {alpha: 1}, 0.8, {ease: FlxEase.circInOut});
							FlxTween.tween(PlayState.camHUD, {alpha: 1}, 0.8, {ease: FlxEase.circInOut});

						// Phase 1 Section
						case 174:
							PlayState.main.relapseGimmick(0.7, 0.3);
						case 180 | 182 | 196 | 198 | 212 | 254 | 286 | 303:
							PlayState.main.relapseGimmick(0.35, 0.15);
						case 188 | 204:
							PlayState.main.relapseGimmick(1.4, 0.6);
						case 206:
							PlayState.main.relapseGimmick(0.7, 0.54);
						case 214:
							PlayState.main.relapseGimmick(0.7, 0.8);
						case 222 | 228 | 244:
							PlayState.main.relapseGimmick(0.7, 1);
						case 236:
							PlayState.main.relapseGimmick(0.7, 0.4);
						case 248 | 262 | 276:
							PlayState.main.relapseGimmick(1.4, 1.2);
						case 270 | 294:
							PlayState.main.relapseGimmick(0.7, 1.5);

						// Cam Shit and Lyrics for intro to Phase 2
						case 366:
							for (bitch in PlayState.strumHUD)
								FlxTween.tween(bitch, {alpha: 0}, 1);
							FlxTween.tween(PlayState.camHUD, {alpha: 0}, 1);

						case 381: PlayState.main.manageLyrics('relapse-gun-pixel', 'You REALLY think this is...', 'calibri-regular', 30, 1.1, 'sineInOut');
						case 384: PlayState.main.manageLyrics('relapse-gun-pixel', '...some kind of...', 'calibri-regular', 30, 1.4, 'sineInOut');
						case 388: PlayState.main.manageLyrics('relapse-gun-pixel', '...silly little GAME?', 'calibri-regular', 30, 1.15, 'sineInOut');
						case 394: PlayState.main.manageLyrics('relapse-gun-pixel', 'Soon enough...', 'calibri-regular', 30, 1.3, 'sineInOut');
						case 398: PlayState.main.manageLyrics('relapse-gun-pixel', "...you'll understand what ME...", 'calibri-regular', 30, 1.5, 'sineInOut');
						case 404: PlayState.main.manageLyrics('relapse-gun-pixel', '...AND MY FRIENDS...', 'calibri-regular', 30, 1.6, 'sineInOut');
						case 408: PlayState.main.manageLyrics('relapse-gun-pixel', '...HAVE TO GO THROUGH!', 'calibri-regular', 30, 1.1, 'sineInOut');
						case 413: PlayState.main.manageLyrics('relapse-gun-pixel', 'Sooner or later...', 'calibri-regular', 30, 1.1, 'sineInOut');
						case 417: PlayState.main.manageLyrics('relapse-gun-pixel', '...your DEATH will be nothing...', 'calibri-regular', 30, 1.1, 'sineInOut');
						case 420: PlayState.main.manageLyrics('relapse-gun-pixel', '...BUT CYCLED SINS!', 'calibri-regular', 30, 1.1, 'sineInOut');

						case 432:
							for (bitch in PlayState.strumHUD)
								FlxTween.tween(bitch, {alpha: 1}, 0.5, {ease: FlxEase.sineOut});
							FlxTween.tween(PlayState.camHUD, {alpha: 1}, 0.5, {ease: FlxEase.sineOut});

						// Phase 2 Section
						case 434:
							PlayState.main.relapseGimmick(0.35, 0.5);
						case 438:
							PlayState.main.relapseGimmick(0.35, 1, true);
						case 446:
							PlayState.main.relapseGimmick(0.7, 0.35);
						case 453:
							PlayState.main.relapseGimmick(0.7, 1, true);
						case 460:
							PlayState.main.relapseGimmick(0.7, 0.9);
						case 467:
							PlayState.main.relapseGimmick(0.35, 1.8, true);
						case 471:
							PlayState.main.relapseGimmick(0.35, 1.1);
						case 474:
							PlayState.main.relapseGimmick(0.35, 1.5);
						case 476:
							PlayState.main.relapseGimmick(0.7, 1, true);
						case 484:
							PlayState.main.relapseGimmick(0.35, 1.3);
						case 486:
							PlayState.main.relapseGimmick(0.35, 2);
						case 494:
							PlayState.main.relapseGimmick(0.35, 1.3, true);
					}
				}
				else
				{
					switch (curBeat)
					{
						// Intro Cam Shit
						case 16: PlayState.camGame.alpha = 1;
						case 32: tweenCamera(0.85, 5.5, 'quartInOut');
						case 46:
							tweenCamera(0.6, 0.6, 'sineInOut');
							for (fuckTheseArrays in PlayState.strumHUD)
								FlxTween.tween(fuckTheseArrays, {alpha: 1}, 0.8, {ease: FlxEase.circInOut});
							FlxTween.tween(PlayState.camHUD, {alpha: 1}, 0.8, {ease: FlxEase.circInOut});

						// Cam Shit and Lyrics for intro to Phase 2
						case 366:
							for (bitch in PlayState.strumHUD)
								FlxTween.tween(bitch, {alpha: 0}, 1);
							FlxTween.tween(PlayState.camHUD, {alpha: 0}, 1);

						case 381: PlayState.main.manageLyrics('relapse-gun-pixel', 'You REALLY think this is...', 'calibri-regular', 30, 1.1, 'sineInOut');
						case 384: PlayState.main.manageLyrics('relapse-gun-pixel', '...some kind of...', 'calibri-regular', 30, 1.4, 'sineInOut');
						case 388: PlayState.main.manageLyrics('relapse-gun-pixel', '...silly little GAME?', 'calibri-regular', 30, 1.15, 'sineInOut');
						case 394: PlayState.main.manageLyrics('relapse-gun-pixel', 'Soon enough...', 'calibri-regular', 30, 1.3, 'sineInOut');
						case 398: PlayState.main.manageLyrics('relapse-gun-pixel', "...you'll understand what ME...", 'calibri-regular', 30, 1.5, 'sineInOut');
						case 404: PlayState.main.manageLyrics('relapse-gun-pixel', '...AND MY FRIENDS...', 'calibri-regular', 30, 1.6, 'sineInOut');
						case 408: PlayState.main.manageLyrics('relapse-gun-pixel', '...HAVE TO GO THROUGH!', 'calibri-regular', 30, 1.1, 'sineInOut');
						case 413: PlayState.main.manageLyrics('relapse-gun-pixel', 'Sooner or later...', 'calibri-regular', 30, 1.1, 'sineInOut');
						case 417: PlayState.main.manageLyrics('relapse-gun-pixel', '...your DEATH will be nothing...', 'calibri-regular', 30, 1.1, 'sineInOut');
						case 420: PlayState.main.manageLyrics('relapse-gun-pixel', '...BUT CYCLED SINS!', 'calibri-regular', 30, 1.1, 'sineInOut');

						case 432:
							for (bitch in PlayState.strumHUD)
								FlxTween.tween(bitch, {alpha: 1}, 0.5, {ease: FlxEase.sineOut});
							FlxTween.tween(PlayState.camHUD, {alpha: 1}, 0.5, {ease: FlxEase.sineOut});
					}
				}

				if (curBeat == 400 || curBeat == 404 || curBeat == 408 || curBeat == 412 || curBeat == 416 || curBeat == 420 || curBeat == 424
					|| curBeat == 428)
				{
					PlayState.main.flashBGEffect(NORMAL, 0.32, 1.2, 'linear', [255, 0, 0, 1]);
					FlxG.camera.zoom += 0.1;
				}

			case 'Malfunction':
				switch (curBeat)
				{
					// Intro Cam Stuff
					case 1: FlxTween.tween(PlayState.camGame, {alpha: 1}, 5, {ease: FlxEase.sineInOut});
					case 16: tweenCamera(1.2, 5, 'quartInOut');
					case 32:
						PlayState.defaultCamZoom = 0.8;
						FlxTween.tween(PlayState.camHUD, {alpha: 1}, 0.5, {ease: FlxEase.sineOut});
						for (i in PlayState.strumHUD)
						{
							FlxTween.tween(i, {alpha: 1}, 0.5, {ease: FlxEase.sineOut});
						}
					case 39 | 48 | 64 | 72 | 88 | 96 | 103 | 113 | 128 | 184 | 192: PlayState.defaultCamZoom = 0.8;
					case 38 | 102: tweenCamera(1.5, 0.25, 'sineInOut');
					case 45 | 61 | 110 | 126 | 187: PlayState.defaultCamZoom = 0.9;
					case 46 | 62 | 67 | 76 | 83 | 92 | 111 | 127 | 158 | 190: PlayState.defaultCamZoom = 1;
					case 47 | 63 | 68 | 84 | 112 | 159: PlayState.defaultCamZoom = 1.3;
					case 69 | 85: PlayState.defaultCamZoom = 1.1;
					case 160: PlayState.defaultCamZoom = 0.65;
					case 164: tweenCamera(1.5, 6, 'sineInOut');
					case 191:
						if (PlayState.main.canaddshaders)
						{
							if (!Init.trueSettings.get('Low Quality') && Init.trueSettings.get('Epilepsy Mode'))
							{
								PlayState.camGame.setFilters([new ShaderFilter(PlayState.chromZoomShader), new ShaderFilter(PlayState.blurShader)]);
								PlayState.camHUD.setFilters([new ShaderFilter(PlayState.chromNormalShader), new ShaderFilter(PlayState.blurShader)]);
								for (i in PlayState.strumHUD)
								{
									i.setFilters([new ShaderFilter(PlayState.chromNormalShader), new ShaderFilter(PlayState.blurShader)]);
								}
							}
						}
                    case 320:
                        FlxTween.tween(PlayState.camHUD, {alpha: 0}, 0.5);
                        for (i in PlayState.strumHUD)
                            {
                                FlxTween.tween(i, {alpha: 0}, 0.5);
                            }
					case 324:
                        moveThatFuckingStrum(false, 0.5, 90, 0, 1060, 120, 0);
                        moveThatFuckingStrum(false, 0.5, 90, 0, 1060, 240, 1);
                        moveThatFuckingStrum(false, 0.5, 90, 0, 1060, 360, 2);
                        moveThatFuckingStrum(false, 0.5, 90, 0, 1060, 480, 3);
                        moveThatFuckingStrum(true, 0.5, 270, 0, 50, 120, 0);
                        moveThatFuckingStrum(true, 0.5, 270, 0, 50, 240, 1);
                        moveThatFuckingStrum(true, 0.5, 270, 0, 50, 360, 2);
                        moveThatFuckingStrum(true, 0.5, 270, 0, 50, 480, 3);
						var count:FlxSprite = new FlxSprite().loadGraphic(Paths.image('UI/funkinAVI/intro/mal-prepare'));
						count.scrollFactor.set();
						count.updateHitbox();
						count.setGraphicSize(Std.int(count.width * PlayState.daPixelZoom));
						count.antialiasing = false;
						count.screenCenter();
						PlayState.main.add(count);
						FlxTween.tween(count, {y: count.y += 50, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								count.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('funkinAVI/countdownSounds/intro3CORRUPT-pixel'), 2);
					case 325:
						var count:FlxSprite = new FlxSprite().loadGraphic(Paths.image('UI/funkinAVI/intro/mal-ready'));
						count.scrollFactor.set();
						count.updateHitbox();
						count.setGraphicSize(Std.int(count.width * PlayState.daPixelZoom));
						count.screenCenter();
						count.antialiasing = false;
						PlayState.main.add(count);
						FlxTween.tween(count, {y: count.y += 50, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								count.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('funkinAVI/countdownSounds/intro2CORRUPT-pixel'), 2);
					case 326:
						var count:FlxSprite = new FlxSprite().loadGraphic(Paths.image('UI/funkinAVI/intro/mal-set'));
						count.scrollFactor.set();
						count.updateHitbox();
						count.setGraphicSize(Std.int(count.width * PlayState.daPixelZoom));
						count.screenCenter();
						count.antialiasing = false;
						PlayState.main.add(count);
						FlxTween.tween(count, {y: count.y += 50, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								count.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('funkinAVI/countdownSounds/intro1CORRUPT-pixel'), 2);
					case 327:
						var count:FlxSprite = new FlxSprite().loadGraphic(Paths.image('UI/funkinAVI/intro/mal-go'));
						count.scrollFactor.set();
						count.updateHitbox();
						count.setGraphicSize(Std.int(count.width * PlayState.daPixelZoom));
						count.screenCenter();
						count.antialiasing = false;
						PlayState.main.add(count);
						FlxTween.tween(count, {y: count.y += 50, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								count.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('funkinAVI/countdownSounds/introGoCORRUPT-pixel'), 2);
                    case 328:
                        FlxTween.tween(PlayState.camHUD, {alpha: 1}, 0.5);
                        for (i in PlayState.strumHUD)
                            {
                                FlxTween.tween(i, {alpha: 1}, 0.5);
                            }

						// Ight Jason, the fun part's all yours
						// The fun begins 0_0
				}

			case 'Hunted':
				if (curBeat == 184)
					PlayState.defaultCamZoom = 1.4;
				if (curBeat == 190)
					PlayState.defaultCamZoom = 0.65;
				if (curBeat == 192)
				{
					PlayState.main.camHudMoves = true;
					if (!Init.trueSettings.get('Disable Flashing Lights'))
						PlayState.camGame.flash(FlxColor.WHITE, 1.5);
					if (!Init.trueSettings.get("Low Quality"))
					{
						PlayState.camGame.setFilters([
							new ShaderFilter(PlayState.redVignette),
							new ShaderFilter(PlayState.dramaticCamMovement),
							new ShaderFilter(PlayState.monitorFilter),
							new ShaderFilter(PlayState.bloomEffect)
						]);
					}
					else
					{
						PlayState.camGame.setFilters([new ShaderFilter(PlayState.redVignette), new ShaderFilter(PlayState.monitorFilter)]);
					}
				}
				if (curBeat == 256)
				{
					PlayState.main.camHudMoves = false;
					PlayState.camGame.flash(FlxColor.BLACK, 2);
					if (!Init.trueSettings.get("Low Quality"))
					{
						PlayState.camGame.setFilters([
							new ShaderFilter(PlayState.dramaticCamMovement),
							new ShaderFilter(PlayState.monitorFilter),
							new ShaderFilter(PlayState.bloomEffect)
						]);
					}
					else
					{
						PlayState.camGame.setFilters([new ShaderFilter(PlayState.monitorFilter)]);
					}

					for (goofyAhhUIS in PlayState.main.allUIs)
					{
						goofyAhhUIS.x += 80;
						goofyAhhUIS.y = FlxMath.lerp(0, goofyAhhUIS.y, 1 - Main.framerateAdjust(0.05));
					}
					FlxTween.tween(PlayState, {health: 2}, 1);
				}
		}
    }

    public function shaderAnims(elapsed:Float)
    {
        PlayState.main.shaderAnim += elapsed;
            switch (PlayState.SONG.song)
			{
				case 'Devilish Deal':
					PlayState.chromZoomShader.setFloat('aberration', PlayState.main.chromEffect);
					PlayState.chromZoomShader.setFloat('effectTime', PlayState.main.chromEffect);
					PlayState.chromNormalShader.setFloat('rOffset', PlayState.main.chromEffect / 70);
					PlayState.chromNormalShader.setFloat('bOffset', -PlayState.main.chromEffect / 70);
					PlayState.dramaticCamMovement.setFloat('time', shaderAnim);

				case 'Isolated' | 'Lunacy' | 'Delusional':
					PlayState.chromZoomShader.setFloat('aberration', PlayState.main.chromEffect);
					PlayState.chromZoomShader.setFloat('effectTime', PlayState.main.chromEffect);
					PlayState.chromNormalShader.setFloat('rOffset', PlayState.main.chromEffect / 45);
					PlayState.chromNormalShader.setFloat('bOffset', -PlayState.main.chromEffect / 45);
					PlayState.dramaticCamMovement.setFloat('time', shaderAnim);
					PlayState.delusionalShift.setFloat('iTime', shaderAnim);
					PlayState.delusionalShift.setFloat('uTime', shaderAnim);

				case 'Delusion':
					PlayState.chromZoomShader.setFloat('aberration', PlayState.main.chromEffect);
					PlayState.chromZoomShader.setFloat('effectTime', PlayState.main.chromEffect);
					PlayState.chromNormalShader.setFloat('rOffset', PlayState.main.chromEffect / 45);
					PlayState.chromNormalShader.setFloat('bOffset', -PlayState.main.chromEffect / 45);
					PlayState.dramaticCamMovement.setFloat('time', shaderAnim);
					PlayState.delusionalShift.setFloat('iTime', shaderAnim);
					PlayState.delusionalShift.setFloat('uTime', shaderAnim);
					PlayState.redVignette.setFloat('time', PlayState.main.effectRed);

				case 'Malfunction':
					PlayState.chromZoomShader.setFloat('aberration', PlayState.main.chromEffect);
					PlayState.chromZoomShader.setFloat('effectTime', PlayState.main.chromEffect);
					PlayState.chromNormalShader.setFloat('rOffset', PlayState.main.chromEffect / 20);
					PlayState.chromNormalShader.setFloat('bOffset', -PlayState.main.chromEffect / 20);
					if (Init.trueSettings.get('Epilepsy Mode'))
						PlayState.blurShader.setFloat('bluramount', PlayState.main.blurEffect);

				case 'Malfunction Legacy':
					PlayState.chromNormalShader.setFloat('rOffset', PlayState.main.chromEffect / 20);
					PlayState.chromNormalShader.setFloat('bOffset', -PlayState.main.chromEffect / 20);
					if (Init.trueSettings.get('Epilepsy Mode'))
						PlayState.blurShader.setFloat('bluramount', PlayState.main.blurEffect);

				case 'Isolated Beta' | 'Isolated Legacy' | 'Isolated Old' | 'Lunacy Legacy' | 'Delusional Legacy':
					PlayState.andromeda.setFloat('iTime', shaderAnim);

				case 'Scrapped':
					if (Init.trueSettings.get('Epilepsy Mode'))
					{
						PlayState.blurShader.setFloat('bluramount', PlayState.main.blurEffect);
						PlayState.blurShaderHUD.setFloat('bluramount', PlayState.main.blurHUD);
					}
					PlayState.chromZoomShader.setFloat('aberration', PlayState.main.chromEffect);
					PlayState.chromZoomShader.setFloat('effectTime', PlayState.main.chromEffect);
					PlayState.chromNormalShader.setFloat('rOffset', PlayState.main.chromEffect / 35);
					PlayState.chromNormalShader.setFloat('bOffset', -PlayState.main.chromEffect / 35);
					PlayState.staticEffect.setFloat('uTime', shaderAnim);
					PlayState.staticEffect.setFloat('iTime', shaderAnim);

				case 'Twisted Grins':
					PlayState.staticEffect.setFloat('uTime', shaderAnim);
					PlayState.staticEffect.setFloat('iTime', shaderAnim);

				case 'Hunted':
					PlayState.redVignette.setFloat('time', shaderAnim);

				case 'Mercy' | 'Mercy Legacy':
					PlayState.waltStatic.setFloat('time', shaderAnim);
			}
    }

    /**
	 * Loads all RPC's icons
	 */
	public function loadRPCIcon()
    {
        #if DevBuild
        PlayState.iconRPC = 'icon';
        #else
        PlayState.iconRPC = CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase()); // basically, it'll now look for the icon in the RPC via song name, if it doesn't it'll just return with no icon
        #end
    }

    public function noteTriggerEvent(type:String, canTween:Bool = false, ?time:Float = 1, ?ease:String = 'sineinout')
    {
        switch (type.toLowerCase())
        {
            case 'swapnormal':
                if (!canTween)
                {
                    PlayState.bfStrums.receptors.members[0].x = 77;
                    PlayState.bfStrums.receptors.members[1].x = 187;
                    PlayState.bfStrums.receptors.members[2].x = 302;
                    PlayState.bfStrums.receptors.members[3].x = 417;
                    PlayState.dadStrums.receptors.members[0].x = 77 + 640;
                    PlayState.dadStrums.receptors.members[1].x = 187 + 640;
                    PlayState.dadStrums.receptors.members[2].x = 302 + 640;
                    PlayState.dadStrums.receptors.members[3].x = 417 + 640;
                }
                else
                {
                    FlxTween.tween(PlayState.bfStrums.receptors.members[0], {x: 77}, time, {ease: ForeverTools.returnTweenEase(ease)});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[1], {x: 187}, time, {ease: ForeverTools.returnTweenEase(ease)});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[2], {x: 382}, time, {ease: ForeverTools.returnTweenEase(ease)});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[3], {x: 417}, time, {ease: ForeverTools.returnTweenEase(ease)});
                    FlxTween.tween(PlayState.dadStrums.receptors.members[0], {x: 77 + 640}, time, {ease: ForeverTools.returnTweenEase(ease)});
                    FlxTween.tween(PlayState.dadStrums.receptors.members[1], {x: 187 + 640}, time, {ease: ForeverTools.returnTweenEase(ease)});
                    FlxTween.tween(PlayState.dadStrums.receptors.members[2], {x: 382 + 640}, time, {ease: ForeverTools.returnTweenEase(ease)});
                    FlxTween.tween(PlayState.dadStrums.receptors.members[3], {x: 417 + 640}, time, {ease: ForeverTools.returnTweenEase(ease)});
                }
            case 'swaprevert':
                if (!canTween)
                {
                    PlayState.dadStrums.receptors.members[0].x = 77;
                    PlayState.dadStrums.receptors.members[1].x = 187;
                    PlayState.dadStrums.receptors.members[2].x = 302;
                    PlayState.dadStrums.receptors.members[3].x = 417;
                    PlayState.bfStrums.receptors.members[0].x = 77 + 640;
                    PlayState.bfStrums.receptors.members[1].x = 187 + 640;
                    PlayState.bfStrums.receptors.members[2].x = 302 + 640;
                    PlayState.bfStrums.receptors.members[3].x = 417 + 640;
                }
                else
                {
                    FlxTween.tween(PlayState.dadStrums.receptors.members[0], {x: 77}, time, {ease: ForeverTools.returnTweenEase(ease)});
                    FlxTween.tween(PlayState.dadStrums.receptors.members[1], {x: 187}, time, {ease: ForeverTools.returnTweenEase(ease)});
                    FlxTween.tween(PlayState.dadStrums.receptors.members[2], {x: 382}, time, {ease: ForeverTools.returnTweenEase(ease)});
                    FlxTween.tween(PlayState.dadStrums.receptors.members[3], {x: 417}, time, {ease: ForeverTools.returnTweenEase(ease)});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[0], {x: 77 + 640}, time, {ease: ForeverTools.returnTweenEase(ease)});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[1], {x: 187 + 640}, time, {ease: ForeverTools.returnTweenEase(ease)});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[2], {x: 382 + 640}, time, {ease: ForeverTools.returnTweenEase(ease)});
                    FlxTween.tween(PlayState.bfStrums.receptors.members[3], {x: 417 + 640}, time, {ease: ForeverTools.returnTweenEase(ease)});
                }
            case 'rightscroll':
                if (!canTween)
                {
                    moveThatFuckingStrum(false, 0, 270, 1, 1060, 120, 0);
                    moveThatFuckingStrum(false, 0, 270, 1, 1060, 240, 1);
                    moveThatFuckingStrum(false, 0, 270, 1, 1060, 360, 2);
                    moveThatFuckingStrum(false, 0, 270, 1, 1060, 480, 3);
                    moveThatFuckingStrum(true, 0.5, 270, 1, 50, 120, 0);
                    moveThatFuckingStrum(true, 0.5, 270, 1, 50, 240, 1);
                    moveThatFuckingStrum(true, 0.5, 270, 1, 50, 360, 2);
                    moveThatFuckingStrum(true, 0.5, 270, 1, 50, 480, 3);
                }
                else
                {

                }
        }
    }

    public function moveThatFuckingStrum(isDad:Bool = false, timer:Float = 0.5, direction:Float = 0, alpha:Float = 1, x:Null<Float>, y:Null<Float>, strumID:Int)
    {
        if (strumID > 3 || strumID < 0)
            strumID = 0;
        if (alpha > 1 || alpha < 0)
            alpha = 1;
        if (timer > 0)
            timer = 0.5;
        if (x == null)
            x = 0;
        if (y == null)
            y = 0;

        if (isDad)
        {
            if (timer == 0)
            {
                PlayState.dadStrums.receptors.members[strumID].strumDirection = direction;
                PlayState.dadStrums.receptors.members[strumID].x = x;
                PlayState.dadStrums.receptors.members[strumID].y = y;
                PlayState.strumHUD[0].alpha = alpha;
            }
            else
            {
                FlxTween.tween(PlayState.dadStrums.receptors.members[strumID], 
                    {
                        strumDirection: direction,
                        x: x,
                        y: y
                    },
                    timer
                );
                FlxTween.tween(PlayState.strumHUD[0], {alpha: alpha}, timer);
            }
        }
        else
        {
            if (timer == 0)
            {
                PlayState.bfStrums.receptors.members[strumID].strumDirection = direction;
                PlayState.bfStrums.receptors.members[strumID].x = x;
                PlayState.bfStrums.receptors.members[strumID].y = y;
                PlayState.strumHUD[1].alpha = alpha;
            }
            else
            {
            FlxTween.tween(PlayState.bfStrums.receptors.members[strumID], 
                {
                    strumDirection: direction,
                    x: x,
                    y: y
                },
                timer
            );
            FlxTween.tween(PlayState.strumHUD[1], {alpha: alpha}, timer);
            }
        }
    }
		
	/**
	* Checks on the spacebar if there's a spacebar mechanic required
	* if you have a mechanic you want to add with the spacebar
	* simply tag in your gimmick here with the stage/song you want it
	* to occur at, in other words, go nuts
	*
	* @param isAutoplay - Do I REALLY need to explain this one?
	*
	* @author DEMOLITIONDON96
	*/
	public function detectSpace(isAutoplay:Bool = false)
	{
		if (!isAutoplay)
		{
			if (FlxG.keys.justPressed.SPACE)
			{
				/*
				* This set is for song-specific gimmicks
				* Try messing around with it
				*
				* - DEMOLITIONDON96
				*/

				switch (PlayState.SONG.song)
				{
					default:
						// nothing
				}

				/*
				* This is if you want the gimmicks to affect
				* ALL songs globally, if they use a certain stage
				* 2 examples are already provided below
				*
				* - DEMOLITIOONDON96
				*/

				switch (PlayState.curStage)
				{
					case 'waltRoom':
						if (PlayState.main.limitThing > 0)
						{
							PlayState.health += 1.25;
							PlayState.main.limitThing -= 1;
						}
					
					case 'apartment':
						if (PlayState.main.shootin)
							PlayState.main.dodged = true;

					default:
						// nothing
				}
			}
		} else {
			switch (PlayState.SONG.song)
			{
				default:
					//nothing
			}
			
			switch (PlayState.curStage)
			{
				case 'waltRoom':
					if (PlayState.health < 0.3 && PlayState.main.limitThing > 0)
					{
						PlayState.health += 1.25;
						PlayState.main.limitThing -= 1;
					}
					
				case 'apartment':
					if (PlayState.main.shootin)
						PlayState.main.dodged = true;
				
				default:
					// nothing
			}
		}
	}

    /**
	* The better and simplified Walt gimmick
	*
	* @author Wither362
	*/
	public function tweenWaltScreen(percentage:Float, alpha:Float):Bool {
		if (PlayState.health <= percentage)
			FlxTween.tween(PlayState.main.waltScreenThing, {alpha: alpha}, 0.15, {ease: FlxEase.sineInOut});
		else
			return true;
		return false;
	}

    /**
     * A function about all events that happend when the opponent touches a note
     */
    public function opponentNoteHit():Void
        {
        switch (PlayState.SONG.song)
        {  
            case 'Lunacy':
                if (!Init.trueSettings.get('Disable Mechanics'))
                {
                    if (PlayState.opponent.curCharacter == 'lunamick-new')
                    {
                        if (PlayState.health > 1.25)
                            PlayState.health -= 0.015;
                    }
                    else if (PlayState.opponent.curCharacter == 'mickey-delu-intro')
                    {
                        if (PlayState.health > 1)
                            PlayState.health -= 0.02;
                    }
                }
            case 'Delusional':
                if (!Init.trueSettings.get('Disable Mechanics'))
                {
                        if (PlayState.opponent.curCharacter == 'delusional-mickey')
                        {
                            if (PlayState.health > 0.6)
                                PlayState.health -= 0.025;
                        }
                        else if (PlayState.opponent.curCharacter == 'mickey-delu-intro')
                        {
                            if (PlayState.health > 1)
                                PlayState.health -= 0.02;
                        }
                }
                
            case 'Laugh Track':
                if (Init.trueSettings.get('Screen Shake'))
                {
                    if (PlayState.health > 0.4)
                        PlayState.health -= 0.01;
                    PlayState.camGame.shake(0.005, 0.07);
                    PlayState.camHUD.shake(0.010, 0.07);
                    for (i in PlayState.strumHUD)
                        i.shake(0.010, 0.07);
                }
                
            case 'Malfunction':
                if (PlayState.opponent.curCharacter == 'glitched-mickey-new-pixel')
                {
                    if (PlayState.health > 0.05)
                        PlayState.health -= 0.01;
                    if (Init.trueSettings.get('Screen Shake'))
                    {
                        PlayState.camGame.shake(0.008, 0.07);
                        for (i in allUIs)
                            i.shake(0.015, 0.07);
                    }
                    if (PlayState.main.canaddshaders)
                    {			
                        if(!Init.trueSettings.get('Low Quality') && Init.trueSettings.get('Epilepsy Mode'))
                        {
                            PlayState.camGame.setFilters([
                                new ShaderFilter(PlayState.chromZoomShader),
                                new ShaderFilter(PlayState.chromNormalShader),
                                new ShaderFilter(PlayState.blurShader)
                            ]);
                            PlayState.camHUD.setFilters([
                                new ShaderFilter(PlayState.chromNormalShader),
                                new ShaderFilter(PlayState.blurShader)
                            ]);
                            for (i in PlayState.strumHUD)
                            {
                                i.setFilters([
                                    new ShaderFilter(PlayState.chromNormalShader),
                                    new ShaderFilter(PlayState.blurShader)
                                ]);
                            }
                        }
                        
                        PlayState.main.chromEffect += 0.5;
                        PlayState.main.blurEffect += 5;
                        
                        if (PlayState.main.chromTween != null)
                            PlayState.main.chromTween.cancel();
                        if (PlayState.main.blurTween != null)
                            PlayState.main.blurTween.cancel();

                        PlayState.main.chromTween = FlxTween.tween(
                            PlayState.main,
                            {
                                chromEffect: 0.0001
                            },
                            0.1,
                            {
                                ease: FlxEase.sineOut,
                                onComplete: function(twn:FlxTween)
                                {
                                    PlayState.main.chromTween = null;
                                }
                            }
                        );
                        PlayState.main.blurTween = FlxTween.tween(
                            PlayState.main,
                            {
                                blurEffect: 0.0
                            },
                            0.1,
                            {
                                ease: FlxEase.sineOut,
                                onComplete: function(twn:FlxTween)
                                {
                                
                                    if(!Init.trueSettings.get('Low Quality'))
                                    {
                                        PlayState.camGame.setFilters([new ShaderFilter(PlayState.chromZoomShader), new ShaderFilter(PlayState.chromNormalShader)]);
                                        PlayState.camHUD.setFilters([new ShaderFilter(PlayState.chromNormalShader)]);
                                        for (i in PlayState.strumHUD) i.setFilters([new ShaderFilter(PlayState.chromNormalShader)]);
                                    }
                                    PlayState.main.blurTween = null;
                                }
                            }
                        );
                    }
                }
                else if (PlayState.opponent.curCharacter == 'gm-tired-pixel')
                {
                    if (PlayState.health > 0.36)
                        PlayState.health -= 0.01;
                    if (Init.trueSettings.get('Screen Shake'))
                    {
                        PlayState.camGame.shake(0.004, 0.07);
                        PlayState.camHUD.shake(0.007, 0.07);
                        for (i in PlayState.strumHUD)
                            i.shake(0.07, 0.07);
                    }
                    if (PlayState.main.canaddshaders)
                    {
                        if(!Init.trueSettings.get('Low Quality') && Init.trueSettings.get('Epilepsy Mode'))
                        {
                            PlayState.camGame.setFilters([
                                new ShaderFilter(PlayState.chromZoomShader),
                                new ShaderFilter(PlayState.chromNormalShader),
                                new ShaderFilter(PlayState.blurShader)
                            ]);
                            PlayState.camHUD.setFilters([
                                new ShaderFilter(PlayState.chromNormalShader),
                                new ShaderFilter(PlayState.blurShader)
                            ]);
                            for (i in PlayState.strumHUD)
                            {
                                i.setFilters([
                                    new ShaderFilter(PlayState.chromNormalShader),
                                    new ShaderFilter(PlayState.blurShader)
                                ]);
                            }
                        }
                        
                        PlayState.main.chromEffect += 0.25;
                        PlayState.main.blurEffect += 2.5;
                        
                        if (PlayState.main.chromTween != null)
                            PlayState.main.chromTween.cancel();
                        if (PlayState.main.blurTween != null)
                            PlayState.main.blurTween.cancel();

                        PlayState.main.chromTween = FlxTween.tween(
                            PlayState.main,
                            {
                                chromEffect: 0.0001
                            },
                            0.1,
                            {
                                ease: FlxEase.sineOut,
                                onComplete: function(twn:FlxTween)
                                {
                                    PlayState.main.chromTween = null;
                                }
                            }
                        );
                        blurTween = FlxTween.tween(
                            PlayState.main,
                            {
                                blurEffect: 0.0
                            },
                            0.1,
                            {
                                ease: FlxEase.sineOut,
                                onComplete: function(twn:FlxTween)
                                {
                                
                                    if(!Init.trueSettings.get('Low Quality'))
                                    {
                                        PlayState.camGame.setFilters([new ShaderFilter(PlayState.chromZoomShader), new ShaderFilter(PlayState.chromNormalShader)]);
                                        PlayState.camHUD.setFilters([new ShaderFilter(PlayState.chromNormalShader)]);
                                        for (i in PlayState.strumHUD) i.setFilters([new ShaderFilter(PlayState.chromNormalShader)]);
                                    }
                                    PlayState.main.blurTween = null;
                                }
                            }
                        );
                    }
                }
                
            case 'Malfunction Legacy': // the reason this gets a separate case is cause shader effects are gonna be different
                if (PlayState.health > 0.05)
                       PlayState.health -= 0.016;
                if (Init.trueSettings.get('Screen Shake'))
                {
                    PlayState.camGame.shake(0.008, 0.07);
                    for (i in allUIs)
                        i.shake(0.015, 0.07);
                }
                if (PlayState.main.canaddshaders)
                {
                    if(!Init.trueSettings.get('Low Quality') && Init.trueSettings.get('Epilepsy Mode'))
                    {
                        PlayState.camGame.setFilters([
                            new ShaderFilter(PlayState.chromNormalShader),
                            new ShaderFilter(PlayState.blurShader)
                        ]);
                        PlayState.camHUD.setFilters([
                            new ShaderFilter(PlayState.chromNormalShader),
                            new ShaderFilter(PlayState.blurShader)
                        ]);
                        for (i in PlayState.strumHUD)
                        {
                            i.setFilters([
                                new ShaderFilter(PlayState.chromNormalShader),
                                new ShaderFilter(PlayState.blurShader)
                            ]);
                        }
                    }
                        
                    PlayState.main.chromEffect += 0.3;
                    PlayState.main.blurEffect += 1.5;
                        
                    if (PlayState.main.chromTween != null)
                        PlayState.main.chromTween.cancel();
                    if (PlayState.main.blurTween != null)
                        PlayState.main.blurTween.cancel();

                    PlayState.main.chromTween = FlxTween.tween(
                        PlayState.main,
                        {
                            chromEffect: 0.0001
                        },
                        0.1,
                        {
                            ease: FlxEase.sineOut,
                            onComplete: function(twn:FlxTween)
                            {
                                PlayState.main.chromTween = null;
                            }
                        }
                    );
                    blurTween = FlxTween.tween(
                        PlayState.main,
                        {
                            blurEffect: 0.0
                        },
                        0.1,
                        {
                            ease: FlxEase.sineOut,
                            onComplete: function(twn:FlxTween)
                            {
                                
                                if(!Init.trueSettings.get('Low Quality'))
                                {
                                    PlayState.camGame.setFilters([new ShaderFilter(PlayState.chromNormalShader)]);
                                    PlayState.camHUD.setFilters([new ShaderFilter(PlayState.chromNormalShader)]);
                                    for (i in PlayState.strumHUD) i.setFilters([new ShaderFilter(PlayState.chromNormalShader)]);
                                }
                                PlayState.main.blurTween = null;
                            }
                        }
                    );
                }
                
            case "Don't Cross!":
                PlayState.boyfriend.x += 1.2;
                PlayState.boyfriend.y -= 1.2;
                PlayState.boyfriend.scale.x -= 0.0012;
                PlayState.boyfriend.scale.y -= 0.0012;

                if (!Init.trueSettings.get('Disable Mechanics'))
                {
                    if(PlayState.health > 0.05) // trol
                        PlayState.health -= 0.015;
                }
        }
    }

    	/**
	*  # Cinematic Bars
	*
	* WORK IN PROGRESS, NOT FINAL
	*/		
	function cinematicBarControls(speed:Float, ease:String = "circInOut", position:Float = 0, controlType:String = "add")
        {
            switch (controlType.toLowerCase())
            {
                case "add" | "create":
                    if (cinematicBars["top"] == null)
                    {
                        PlayState.main.cinematicBars["top"] = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
                        PlayState.main.cinematicBars["top"].screenCenter(X);
                        PlayState.main.cinematicBars["top"].cameras = [PlayState.camBars];
                        PlayState.main.cinematicBars["top"].y = 0 - cinematicBars["top"].height; // offscreen
                        PlayState.main.add(PlayState.main.cinematicBars["top"]);
                    }
    
                    if (cinematicBars["bottom"] == null)
                    {
                        PlayState.main.cinematicBars["bottom"] = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
                        PlayState.main.cinematicBars["bottom"].screenCenter(X);
                        PlayState.main.cinematicBars["bottom"].cameras = [PlayState.camBars];
                        PlayState.main.cinematicBars["bottom"].y = FlxG.height; // offscreen
                        PlayState.main.add(PlayState.main.cinematicBars["bottom"]);
                    }
                    
                case "remove" | "kill" | "delete":
                    if (PlayState.main.cinematicBars["top"] != null)
                        PlayState.main.cinematicBars["top"].kill();
                    if (PlayState.main.cinematicBars["bottom"] != null)
                        PlayState.main.cinematicBars["bottom"].kill();
                    
                case "movetop" | "move top":
                    FlxTween.tween(PlayState.main.cinematicBars["top"], {y: position}, speed, {ease: ForeverTools.returnTweenEase(ease)});
                    
                case "movebottom" | "move bottom":
                    FlxTween.tween(PlayState.main.cinematicBars["bottom"], {y: -position}, speed, {ease: ForeverTools.returnTweenEase(ease)});
                    
                case "moveboth" | "move both":
                    FlxTween.tween(PlayState.main.cinematicBars["top"], {y: position}, speed, {ease: ForeverTools.returnTweenEase(ease)});
                    FlxTween.tween(PlayState.main.cinematicBars["bottom"], {y: -position}, speed, {ease: ForeverTools.returnTweenEase(ease)});
                    
                case "boptop" | "bop top":
                    PlayState.main.cinematicBars["top"].y = position;
                    FlxTween.tween(PlayState.main.cinematicBars["top"], {y: position - 20}, 0.5, {ease: ForeverTools.returnTweenEase(ease)});
                    
                case "bopbottom" | "bop bottom":
                    PlayState.main.cinematicBars["bottom"].y = -position;
                    FlxTween.tween(PlayState.main.cinematicBars["bottom"], {y: -position + 20}, 0.5, {ease: ForeverTools.returnTweenEase(ease)});
                    
                case "bopboth" | "bop both":
                    PlayState.main.cinematicBars["top"].y = position;
                    PlayState.main.cinematicBars["bottom"].y = -position;
                    FlxTween.tween(PlayState.main.cinematicBars["top"], {y: position - 20}, 0.5, {ease: ForeverTools.returnTweenEase(ease)});
                    FlxTween.tween(PlayState.main.cinematicBars["bottom"], {y: -position + 20}, 0.5, {ease: ForeverTools.returnTweenEase(ease)});			
            }
        }
    
        /**
        * # Camera Zoom Tween Fix
        * 
        * Don't know why, but this was NEEDED to fix the zooming from breaking, smh.
        *
        * @param zoom - Sets the zoom value of the camera
        * @param time - How long you want the tween to take
        * @param ease - I suggest reading the HaxeFlixel API on this one, this uses FlxEase's library components if you don't know how to use this
        *
        * @author JustJasonLol
        */
        public function tweenCamera(zoom:Float = 0.9, time:Float = 0.6, ease:Null<String>):Void
        {
            FlxTween.tween(PlayState.camGame, {zoom: zoom}, time, {ease: ForeverTools.returnTweenEase(ease), onComplete: e -> PlayState.defaultCamZoom = zoom});
        }

    public function loadWindowTitleData()
            {
                switch (PlayState.gameplayMode)
                {
                    case STORY:
                        switch (PlayState.SONG.song)
                        {
                            case 'Devilish Deal' | 'Isolated' | 'Lunacy' | 'Delusional':
                                Application.current.window.title = 'Funkin.avi - Episode 1: ' + PlayState.SONG.song + " - Composed by: " + PlayState.SONG.composer + (paused ? ' {PAUSED}' : "");							
                            case 'Twisted Grins' | 'Resentment' | 'Mortiferum Risus':
                                Application.current.window.title = 'Funkin.avi - Episode S: ' + PlayState.SONG.song + " - Composed by: " + PlayState.SONG.composer + (paused ? ' {PAUSED}' : "");					
                            case 'Mercy' | 'Affliction':
                                Application.current.window.title = 'Funkin.avi - Episode W: ' + PlayState.SONG.song + " - Composed by: " + PlayState.SONG.composer + (paused ? ' {PAUSED}' : "");			
                            default:
                                Application.current.window.title = 'Funkin.avi - Episode ???: ' + PlayState.SONG.song + " - Composed by: " + PlayState.SONG.composer + (paused ? ' {PAUSED}' : "");
                        }						
                    case FREEPLAY:
                        Application.current.window.title = 'Funkin.avi - Freeplay: ' + PlayState.SONG.song + " - Composed by: " + PlayState.SONG.composer + (paused ? ' {PAUSED}' : "");					
                    case CHARTING:
                        if (PlayState.SONG.song == 'Malfunction')
                            Application.current.window.title = 'malsquare.hx - CHEATER MODE ACTIVATED: ' + PlayState.SONG.song + " - Composed by: I CAN SEE YOU CHEATING! - [!CHEATER DETECTED!]" + (paused ? ' {PAUSED}' : "");
                        else
                            Application.current.window.title = 'Funkin.avi - TESTING MODE: ' + PlayState.SONG.song + " - Composed by: " + PlayState.SONG.composer + (paused ? ' {PAUSED}' : "");
                }
            }
}
