var chains:FlxSprite;
var chainsI:FlxSprite;
var vault:FlxSprite;
var vaultI:FlxSprite;
var thingy:FlxSprite;
var thingyI:FlxSprite;

var bloom:FlxRuntimeShader;
var chrom:FlxRuntimeShader;

function onCreate()
{
	spawnGirlfriend(false);

	bloom = new FlxRuntimeShader(File.getContent('./assets/shaders/bloomGame.frag'), null, 120);
	chrom = new FlxRuntimeShader(File.getContent('./assets/shaders/aberration.frag'), null, 150);
	chrom.setFloat('aberration', 0.06);
	chrom.setFloat('effectTime', 0.12);

	vault = new FlxSprite(-200, -100).loadGraphic(Paths.image('vault', 'data/stages/vaultRoom/images'));
	vault.scale.set(1.45, 1.3);
	add(vault);
	chains = new FlxSprite(-225, -100).loadGraphic(Paths.image('chains', 'data/stages/vaultRoom/images'));
	chains.scale.set(1.5, 1.3);
	chains.scrollFactor.set(1.2, 1.25);
	foreground.add(chains);
	thingy = new FlxSprite(-200, -100).loadGraphic(Paths.image('holyshitdarkness', 'data/stages/vaultRoom/images'));
	thingy.scale.set(1.45, 1.3);
	foreground.add(thingy);

	vaultI = new FlxSprite(-200, -100).loadGraphic(Paths.image('vaultWhite', 'data/stages/vaultRoom/images'));
	vaultI.scale.set(1.45, 1.3);
	vaultI.visible = false;
	add(vaultI);
	chainsI = new FlxSprite(-225, -100).loadGraphic(Paths.image('chainsWhite', 'data/stages/vaultRoom/images'));
	chainsI.scale.set(15, 1.3);
	chainsI.scrollFactor.set(1.2, 1.25);
	chainsI.visible = false;
	foreground.add(chainsI);
	thingyI = new FlxSprite(-200, -100).loadGraphic(Paths.image('holyshititstoobright', 'data/stages/vaultRoom/images'));
	thingyI.scale.set(1.45, 1.3);
	thingyI.visible = false;
	foreground.add(thingyI);
}

function onBeat(curBeat:Int, boyfriend:Character, gf:Character, dad:Character)
{
	if(curBeat == 544)
	{
		PlayState.camGame.flash("white", 3);
		PlayState.camGame.setFilters(
		[
			new ShaderFilter(bloom),
			new ShaderFilter(chrom)
		]);
		vault.visible = false;
		chains.visible = false;
		thingy.visible = false;
		vaultI.visible = true;
		chainsI.visible = true;
		thingyI.visible = true;
	}

	if(curBeat == 608)
	{
		PlayState.camGame.flash("black", 3);
		PlayState.camGame.filtersEnabled = false;
		vault.visible = true;
		chains.visible = true;
		thingy.visible = true;
		vaultI.visible = false;
		chainsI.visible = false;
		thingyI.visible = false;
	}
}

function charStagePos(boyfriend:Character, gf:Character, dad:Character)
{
	dad.setPosition(90, 60);
    	boyfriend.setPosition(900, 530);
}