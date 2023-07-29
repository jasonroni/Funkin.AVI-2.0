package states.warnings;

class VHSTapeIntro extends flixel.FlxState 
{
   override function create() 
      {
         super.create();
         #if HXCPP_M32
         new states.TitleState();
         #else
         new states.CutsceneState('coolIntro');
         #end
      }
}