package base.utils;

import lime.app.Application;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.FlxSprite;
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
				case 'Devilish Deal' | 'Isolated' | 'Lunacy' | 'Delusional':
					if (!Init.trueSettings.get('Low Quality'))
					{
						PlayState.camGame.setFilters([
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
					if (PlayState.health < 0.3 && limitThing > 0)
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
            case 'Delusional':
                if (!Init.trueSettings.get('Disable Mechanics'))
                {
                        if (PlayState.health > 0.1)
                            PlayState.health -= 0.035;
                }
                
            case 'Laugh Track':
                if (Init.trueSettings.get('Screen Shake'))
                {
                    PlayState.camGame.shake(0.005, 0.07);
                    PlayState.camHUD.shake(0.010, 0.07);
                    for (i in PlayState.strumHUD)
                        i.shake(0.010, 0.07);
                }
                
            case 'Malfunction':
                if (PlayState.opponent.curCharacter == 'glitched-mickey-new-pixel')
                {
                    if (PlayState.health > 0.05)
                        PlayState.health -= 0.018;
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
                                    chromTween = null;
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
                        add(PlayState.main.cinematicBars["top"]);
                    }
    
                    if (cinematicBars["bottom"] == null)
                    {
                        PlayState.main.cinematicBars["bottom"] = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
                        PlayState.main.cinematicBars["bottom"].screenCenter(X);
                        PlayState.main.cinematicBars["bottom"].cameras = [PlayState.camBars];
                        PlayState.main.cinematicBars["bottom"].y = FlxG.height; // offscreen
                        add(PlayState.main.cinematicBars["bottom"]);
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
                            Application.current.window.title = 'malware.xml - CHEATER MODE ACTIVATED: ' + PlayState.SONG.song + " - Composed by: I CAN SEE YOU CHEATING! - [!CHEATER DETECTED!]" + (paused ? ' {PAUSED}' : "");
                        else
                            Application.current.window.title = 'Funkin.avi - TESTING MODE: ' + PlayState.SONG.song + " - Composed by: " + PlayState.SONG.composer + (paused ? ' {PAUSED}' : "");
                }
            }
}
