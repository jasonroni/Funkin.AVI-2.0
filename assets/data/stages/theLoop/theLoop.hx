var grayScale:FlxRuntimeShader;
var monitor:FlxRuntimeShader;

function onCreate()
{
    spawnGirlfriend(false);
    PlayState.defaultCamZoom = 0.85;

    monitor = new FlxRuntimeShader(File.getContent('./assets/shaders/monitor.frag'), null, 140);
    grayScale = new FlxRuntimeShader(File.getContent('./assets/shaders/grayScale.frag'), null, 140);

    PlayState.camHUD.setFilters([new ShaderFilter(grayScale)]);

    PlayState.camGame.setFilters(
        [
            new ShaderFilter(grayScale),
            new ShaderFilter(monitor)
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