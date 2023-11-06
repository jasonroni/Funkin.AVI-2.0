package states.warnings;

class VHSTapeIntro extends flixel.FlxState 
{
   override function create() 
      {
         super.create();
         #if !VIDEO_PLUGIN
         new states.TitleState();
         #else
         new states.CutsceneState('coolIntro');
         #end
      }
}