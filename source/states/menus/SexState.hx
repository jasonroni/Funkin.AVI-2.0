package states.menus;

import flixel.FlxSprite;
import flixel.text.FlxText;

class SexState extends MusicBeatState {
   var megamind:FlxSprite; // Tbh movie is peak go watch it

   var upText:FlxText;
   var downText:FlxText;

   var monitor:FlxRuntimeShader;
   var bloom:FlxRuntimeShader;

   override function create() {
      bloom = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/bloom.frag'), null, 120);
      monitor = new FlxRuntimeShader(sys.io.File.getContent('./assets/shaders/monitor.frag'), null, 140);

      flixel.FlxG.camera.setFilters([
            new openfl.filters.ShaderFilter(bloom),
            new openfl.filters.ShaderFilter(monitor)
         ]);

      super.create();

      //the game crashes idk why
      /*megamind = new FlxSprite().loadGraphic(Paths.image('noBitches'));
      add(megamind);*/
   }

   override function update(e:Float) {
      super.update(e);

      if(Controls.getPressEvent("back"))
         {
            lime.app.Application.current.window.alert('Bro think there was sex', 'L moment');
            Main.switchState(this, new MainMenu());
         }
   }
}