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
  
  switch(meta.state.PlayState.SONG.song)
  {
      default:
        pauseImage = 'unknown';
        discordIcon = 'placeholder';
  }
}
