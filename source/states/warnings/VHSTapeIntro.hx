package states.warnings;

class VHSTapeIntro extends flixel.FlxState 
{
   override function create() 
      {
         super.create();
         new states.CutsceneState('coolIntro');
      }
}