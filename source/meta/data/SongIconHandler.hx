package meta.data;

#if desktop
import meta.data.dependency.Discord;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import openfl.filters.ShaderFilter;
import flixel.addons.display.FlxTiledSprite;
import flixel.util.FlxSave;
import flixel.FlxCamera;
import flixel.system.FlxAssets;
import sys.FileSystem;
import meta.*;
import meta.data.*;
import meta.data.Song.SwagSong;
import meta.state.charting.*;

using StringTools;
  
class SongIconHandler
{
  public static var pauseImage:String; //for the pause menu art of the song
  public static var discordIcon:String; //for the Discord RPC icon change
  
  public static function reloadPauseArt()
  {
    switch(meta.state.PlayState.SONG.song)
    {
        case 'Cycled Sins':
          pauseImage = 'assets/images/OSTArt/cycledSins';
        case 'Mercy' | 'Mercy Legacy':
          pauseImage = 'assets/images/OSTArt/mercy';
        case 'Malfunction' | 'Malfunction Legacy':
          pauseImage = 'assets/images/OSTArt/malfunction';
        default:
          pauseImage = 'assets/images/OSTArt/unknown';
    }
  }
  public static function reloadRPC()
  {
    switch(meta.state.PlayState.SONG.song)
    {
        case 'Isolated' | 'Lunacy' | 'Delusional':
          discordIcon = 'assets/images/OSTArt/episode1';
        case 'Twisted Grins' | 'Facade' | 'Mortiferum Risus':
          discordIcon = 'assets/images/OSTArt/episode2';
        case 'Cycled Sins':
          discordIcon = 'assets/images/OSTArt/cycledsins';
        case 'Mercy' | 'Mercy Legacy':
          discordIcon = 'assets/images/OSTArt/mercy';
        case 'Malfunction' | 'Malfunction Legacy':
          discordIcon = 'assets/images/OSTArt/malfunction';
        default:
          discordIcon = 'assets/images/OSTArt/placeholder';
    }
  }
}
