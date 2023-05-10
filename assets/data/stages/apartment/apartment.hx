var bg1:FlxSprite;
var bg2:FlxSprite;

var chrom:FlxRuntimeShader;
var dramaticCam:FlxRuntimeShader;
var monitorFilter:FlxRuntimeShader;
var phase2Static:FlxRuntimeShader;
var glitchBG:FlxRuntimeShader;
var vignette:FlxRuntimeShader;

var shaderTime:Float = 0;

function onCreate()
{
    spawnGirlfriend(false);
    PlayState.defaultCamZoom = 0.6;
	PlayState.cameraSpeed = 0.9;

    dramaticCam = new FlxRuntimeShader(File.getContent('./assets/shaders/filmgrain.frag'), null, 150);
    monitorFilter = new FlxRuntimeShader(File.getContent('./assets/shaders/monitor.frag'), null, 140);

    //Phase 2 shaders
    chrom = new FlxRuntimeShader(Shaders.aberration, null, 150);
    chrom.setFloat('aberration', 0.12);
    chrom.setFloat('effectTime', 0.24);
    phase2Static = new FlxRuntimeShader(File.getContent('./assets/shaders/tvStatic.frag'), null, 120);
    glitchBG = new FlxRuntimeShader(Shaders.vignetteGlitch, null, 130);
    vignette = new FlxRuntimeShader(File.getContent('./assets/shaders/vignetteApparition.frag'), null, 120);

    PlayState.camGame.setFilters(
        [
            new ShaderFilter(dramaticCam),
            //new ShaderFilter(monitorFilter)
        ]);

    bg1 = new FlxSprite(0, 50);
    bg1.frames = Paths.getSparrowAtlas('relapse1', 'data/stages/apartment/images');
    bg1.animation.addByPrefix('idle', 'Bg bg', 10, true);
    bg1.scale.set(7, 7);
    bg1.antialiasing = false;
    bg1.animation.play('idle');
    add(bg1);

    bg2 = new FlxSprite(0, 50).loadGraphic(Paths.image('relapse2', 'data/stages/apartment/images'));
    bg2.scale.set(7, 7);
    bg2.antialiasing = false;
    bg2.visible = false;
    add(bg2);
}

function onBeat(curBeat:Int, boyfriend:Character, gf:Character, dad:Character)
{
    if (PlayState.SONG.song == "Cycled Sins Legacy")
    {
        if (curBeat == 128)
        {
            FlxTween.tween(PlayState.camHUD, {alpha: 0}, 1, {ease: FlxEase.sineInOut});
            FlxTween.tween(PlayState.camGame, {alpha: 0}, 1.5, {ease: FlxEase.sineInOut});
            FlxTween.tween(PlayState.dadStrums, {alpha: 0}, 1, {ease: FlxEase.sineInOut});
        }
        if (curBeat == 138)
        {
            FlxTween.tween(PlayState.camGame, {alpha: 1}, 1, {ease: FlxEase.sineInOut});
        }
        if (curBeat == 142)
        {
            PlayState.camGame.alpha = 0;
            PlayState.bfStrums.alpha = 0;
        }
        if (curBeat == 144)
        {
            PlayState.camGame.setFilters(
                [
                    new ShaderFilter(phase2Static),
                    new ShaderFilter(vignette),
                    new ShaderFilter(chrom),
                    new ShaderFilter(dramaticCam),
                    //new ShaderFilter(monitorFilter)
                ]);
            bg1.visible = false;
            bg2.visible = true;
            bg2.shader = glitchBG;
            PlayState.camGame.alpha = 1;
            PlayState.camHUD.alpha = 1;
            PlayState.bfStrums.alpha = 1;
            PlayState.camGame.flash("red", 1.2);
            FlxTween.tween(PlayState, {health: 0.1}, 1, {ease: FlxEase.sineInOut});
        }
        if (curBeat == 272)
        {
            FlxTween.tween(PlayState, {health: 0.1}, 20, {ease: FlxEase.quartInOut});
            FlxTween.tween(PlayState.camHUD, {alpha: 0}, 1, {ease: FlxEase.sineInOut});
            FlxTween.tween(PlayState.bfStrums, {alpha: 0}, 1, {ease: FlxEase.sineInOut, startDelay: 0.5});
        }
        if (curBeat == 332)
        {
            FlxTween.tween(PlayState.camHUD, {alpha: 1}, 1, {ease: FlxEase.sineInOut});
            FlxTween.tween(PlayState.bfStrums, {alpha: 1}, 1, {ease: FlxEase.sineInOut});
        }
    }
    else if (PlayState.SONG.song == 'Cycled Sins')
    {
        if (curBeat == 1)
        {
            FlxTween.tween(PlayState.camHUD, {alpha: 0}, 1, {ease: FlxEase.quartInOut});

            for (i in PlayState.strumHUD)
            {
                FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.quartInOut});
            }
        }
        if (curBeat == 31)
        {
            FlxTween.tween(PlayState.camHUD, {alpha: 1}, 0.3, {ease: FlxEase.quartInOut});

            for (i in PlayState.strumHUD)
            {
                FlxTween.tween(i, {alpha: 1}, 0.3, {ease: FlxEase.quartInOut});
            }
        }
    }
}

function onUpdate(elapsed:Float, boyfriend:Character, gf:Character, dad:Character)
{
    shaderTime += elapsed;

    glitchBG.setFloat('time', shaderTime);
    glitchBG.setFloat('prob', shaderTime);

    phase2Static.setFloat('uTime', shaderTime);
    phase2Static.setFloat('iTime', shaderTime);

    vignette.setFloat('time', shaderTime);

    dramaticCam.setFloat('time', shaderTime);
}

function charStagePos(boyfriend:Character, gf:Character, dad:Character)
{
    dad.setPosition(-1000, 270);
    boyfriend.setPosition(590, 250);
}    