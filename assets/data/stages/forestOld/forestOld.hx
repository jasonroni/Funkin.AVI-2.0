import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
import flixel.FlxSprite;

function onCreate()
{
    spawnGirlfriend(false);

    var monitor:FlxRuntimeShader = new FlxRuntimeShader(File.getContent('./assets/shaders/monitor.frag'), null, 140);

    PlayState.camGame.setFilters([new ShaderFilter(monitor)]);

    var forest:FlxSprite = new FlxSprite(-180, -350).loadGraphic(Paths.image('forest', 'data/stages/forestOld'));
    add(forest);
}

function charStagePos(boyfriend:Character, gf:Character, dad:Character)
{
    dad.setPosition(0, 0);
    boyfriend.setPosition(900, -20);
}