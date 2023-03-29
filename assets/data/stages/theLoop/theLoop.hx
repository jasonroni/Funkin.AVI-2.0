var grayScale:FlxRuntimeShader;
var monitor:FlxRuntimeShader;
var peak:FlxRuntimeShader;
var tilt:FlxRuntimeShader;
var tilt_hud:FlxRuntimeShader;

function onCreate()
{
    spawnGirlfriend(false);
    PlayState.defaultCamZoom = 0.85;

    monitor = new FlxRuntimeShader(File.getContent('./assets/shaders/monitor.frag'), null, 140);
    grayScale = new FlxRuntimeShader(File.getContent('./assets/shaders/grayScale.frag'), null, 140);
    peak = new FlxRuntimeShader(File.getContent('./assets/shaders/andromedaShader.frag', null, 140));
    tilt = new FlxRuntimeShader(File.getContent('./assets/shaders/tiltShift.frag', null, 140));
    tilt_hud = new FlxRuntimeShader(File.getContent('./assets/shaders/tiltShift.frag', null, 140));
    peak.setFloat('glitchModifier', 0.6);
    peak.setBool('distortionOn', true);
    peak.setBool('perspectiveOn', true);
    peak.setBool('vignetteMoving', true);
    peak.setBool('scanlinesOn', true);
    tilt.setFloat('bluramount', 0.6);
    tilt_hud.setFloat('bluramount', 0.1);

    PlayState.camGame.setFilters(
        [
            //new ShaderFilter(tilt),
            new ShaderFilter(grayScale),
            //new ShaderFilter(monitor),
            new ShaderFilter(peak),
        ]);

    PlayState.camHUD.setFilters(
        [
            new ShaderFilter(peak),
            //new ShaderFilter(tilt_hud),
            new ShaderFilter(grayScale)
        ]);


    var street:FlxSprite = new FlxSprite(-500, -700).loadGraphic(Paths.image('Mickeybg', 'data/stages/theLoop/images'));
    add(street);

    var grainstuff:FlxSprite = new FlxSprite(0, 0);
    grainstuff.frames = Paths.getSparrowAtlas('Grainshit', 'data/stages/theLoop/images');
    grainstuff.animation.addByPrefix('yucky', 'grains 1', 24, true);
    grainstuff.animation.play('yucky');
    grainstuff.cameras = [PlayState.camHUD];
    grainstuff.scale.set(3, 3);
    grainstuff.screenCenter();
    add(grainstuff);
}

var time:Float = 0;
function onUpdate(elapsed:Float)
    {
        time += elapsed;
        peak.setFloat('iTime', time);
    }

function charStagePos(boyfriend:Character, gf:Character, dad:Character)
{
    dad.setPosition(0, 0);

    if (boyfriend.curCharacter == 'bf')
    {
        boyfriend.setPosition(1000, 130);
    }else{
        boyfriend.setPosition(500, -320);
    }
}