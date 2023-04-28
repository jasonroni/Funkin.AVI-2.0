package globals;

/*
	okay, I was getting tired of having to rename the fucking typedef stuff for every menu,
	so here's the more better, and more simpler approach to this, 
	basically, you don't need to worry about rewriting a new typedef
	not anymore, 
	this file has been made to be globally used on all over files, if it is needed, 
	you can thank me later.

	-don
*/

import flixel.util.FlxColor;

/**
 * CONTROLS STUFF
 */
typedef KeyCall = (Int, KeyState) -> Void; // ID in Array, State -> Function;
typedef BindCall = (String, Int, KeyState) -> Void; // Name, ID in Array, State -> Function;
// for convenience;
typedef Key = Null<Int>;

/**
 * Typedef used for Freeplay
 */
typedef SongMetadata =
{
	var name:String;
	var week:Int;
	var character:String;
	var color:FlxColor;
	var composer:String;
	var difficultyRank:String;
	var textColor:FlxColor;
	//var discArt:String;
}

/**
 * Judgement System
 */
typedef Judgement =
{
	var name:String; // default: sick
	var score:Int; // default: 350
	var health:Float; // default: 100
	var accuracy:Float; // default : 100
	var timing:Float; // default: 45
	var timingCap:Float; // default: 45
	var comboStatus:String; // default: none
}


/**
 * Typedef used for Song Card Customization
 */
typedef SongCardData =
{
	// Font Settings
	var font:String;
	var fontSize:Array<Int>;
	var fontColor:Array<Float>;
	var fontScale:Array<Float>;
	var fontAlpha:Array<Float>;
	var fontAlignType:String;
	var fontOffset:Array<Float>;

	// Base Settings
	var customArt:String;
	var playerIcon:String;
	var opponentIcon:String;

	// Animation Settings
	var isAnimated:Bool;
	var animName:String;
	var animFramerate:Int;
	var isLooped:Bool;

	// Icon Settings
	var playerOffset:Array<Float>;
	var opponentOffset:Array<Float>;
	var playerScale:Array<Float>;
	var opponentScale:Array<Float>;
	var playerAlpha:Array<Float>;
	var opponentAlpha:Array<Float>;

	// Extra Settings
	var cardAlpha:Array<Float>;
	var cardScale:Array<Float>;
	var cardOffsets:Array<Float>;
	var isScreenCenter:Bool;

	// Tween Settings
	var tweenIn:String;
	var tweenOut:String;
	var cardMoveIntro:Array<Float>;
	var cardMoveOutro:Array<Float>;
	var playerMoveIntro:Array<Float>;
	var playerMoveOutro:Array<Float>;
	var oppMoveIntro:Array<Float>;
	var oppMoveOutro:Array<Float>;
	var fontMoveIntro:Array<Float>;
	var fontMoveOutro:Array<Float>;

	// Special FX Settings
	var cardShader:String;
	var playerShader:String;
	var opponentShader:String;
	var cardBlend:String;
	var playerBlend:String;
	var opponentBlend:String;
}

/**
 * Typedef to create characters
 */
typedef CharacterData =
{
	var flipX:Bool;
	var flipY:Bool;
	var offsets:Array<Float>;
	var camOffsets:Array<Float>;
	var quickDancer:Bool;
	var singDuration:Float;
	var headBopSpeed:Int;
	var healthColor:Array<Float>;
	var antialiasing:Bool;
	var adjustPos:Bool;
	var missColor:Array<Int>; // for fake misses;
	var icon:String;
}

/*
	FOR PSYCH ENGINE CHARACTER COMPATIBILITY
	author @Shadow_Mario_
 */
typedef PsychEngineChar =
{
	var animations:Array<PsychAnimArray>;
	var image:String;
	var scale:Float;
	var sing_duration:Float;
	var healthicon:String;

	var position:Array<Float>;
	var camera_position:Array<Float>;
	var flip_x:Bool;
	var no_antialiasing:Bool;
	var healthbar_colors:Array<Float>;
}

typedef PsychAnimArray =
{
	var anim:String;
	var name:String;
	var fps:Int;
	var loop:Bool;
	var indices:Array<Int>;
	var offsets:Array<Int>;
}

/**
 * DIALOGUE HANDLERS
 */
typedef PortraitDataDef =
{
	var name:String;
	var expressions:Array<String>;
	var position:Null<Dynamic>;
	var offset:Null<Array<Int>>;
	var scale:Null<Int>;
	var antialiasing:Null<Bool>;
	var flipX:Null<Bool>;
	var loop:Null<Bool>;

	var sounds:Null<Array<String>>;
	var soundChance:Null<Int>;
	var soundPath:Null<String>;
	var acceptSoundPath:Null<String>;
	var acceptSound:Null<String>;
	// PIXEL FONTS;
	var font:Null<String>;
	var fontColor:Null<Array<Int>>;
	// BORDER PREFERENCES;
	var borderSize:Null<Float>;
	var borderColor:Null<Array<Int>>;
	var shadowOffset:Null<Array<Int>>;
	// SELECTORS;
	var showHand:Null<Bool>;
	var handTexPath:Null<String>;
	var handTex:Null<String>;
	var handSize:Null<Float>;
}

typedef DialogueDataDef =
{
	var events:Array<Array<Dynamic>>;
	var portrait:String;
	var expression:String;
	var text:Null<String>;
	var boxState:Null<String>;

	var speed:Null<Int>;
	var scale:Null<Int>;
}

typedef BoxDataDef =
{
	var position:Null<Array<Int>>;
	var textPos:Null<Array<Int>>;
	var scale:Null<Float>;
	var antialiasing:Null<Bool>;
	var singleFrame:Null<Bool>;
	var doFlip:Null<Bool>;
	var bgColor:Null<Array<Int>>;
	var states:Null<Dynamic>;
}

typedef DialogueFileDataDef =
{
	var box:Null<String>;
	var boxStyle:Null<String>;
	var boxState:Null<String>;
	var song:Null<String>;
	var songFadeIn:Null<Int>;
	var songFadeOut:Null<Int>;
	var dialogue:Array<DialogueDataDef>;
}

/**
 * MENU CHARACTERS
 */
typedef StoryCharacter =
{
	var image:String;
	var scale:Float;
	var position:Array<Int>;
	var idleAnim:Array<Dynamic>;
	var heyAnim:Array<Dynamic>;
	var flipX:Bool;
}

/**
 * GAMEJOLT STUFF
 */

/**
 * The way the scores are fetched from your game API.
 * 
 * @param score The stringified Score.
 * @param sort The value of the Score.
 * @param extra_data Extra data about the Score.
 * @param user The username of the User who reached this Score (if it's a registered User).
 * @param user_id The ID of the User who reached this Score (if it's a registered User).
 * @param guest The "guest" name of the User who reached this Score (if it's NOT a registered User).
 * @param stored A short description about the date the User reached this Score (if it's a registered User).
 * @param stored_timestamp A long time stamp (in seconds) of the date the User reached this Score (if it's a registered User).
 */
 typedef Score = {
	score:String,
	sort:Int,
	extra_data:String,
	?user:String,
	?user_id:Int,
	?guest:String,
	?stored:String,
	?stored_timestamp:Int
}

/**
 * The way the trophies are fetched from your game API.
 * 
 * @param id The ID of the Trophy.
 * @param title The title of the Trophy.
 * @param description The description of the Trophy.
 * @param difficulty The difficulty rank of the Trophy.
 * @param image_url The link of the image that represents the Trophy.
 * @param achieved Whether this Trophy was achieved or not, it can be a string if it was (with info about how much time ago it was achieved) or bool if not (false).
 */
typedef Trophy = {
	id:Int,
	title:String,
	description:String,
	difficulty:String,
	image_url:String,
	achieved:Dynamic
}

/**
 * The way the user data is fetched from the GameJolt API.
 * Only works with registered users.
 * 
 * @param id The ID of the User.
 * @param type The cathegory the User is cataloged like in GameJolt.
 * @param username The username of the User.
 * @param avatar_url The link of the avatar of the User.
 * @param signed_up A short description about how long the User have been in GameJolt.
 * @param signed_up_timestamp A long time stamp (in seconds) of when the User signed up.
 * @param last_logged_in A short description about the last time the User was found active in GameJolt.
 * @param last_logged_in_timestamp A long time stamp (in seconds) of the last time the User logged in GameJolt.
 * @param status The actual status of the User.
 * @param developer_name The display name of the User.
 * @param developer_website The website of the User.
 * @param developer_description The description of the User.
 */
typedef User = {
	id:Int,
	type:String,
	username:String,
	avatar_url:String,
	signed_up:String,
	signed_up_timestamp:Int,
	last_logged_in:String,
	last_logged_in_timestamp:Int,
	status:String,
	developer_name:String,
	developer_website:String,
	developer_description:String
}
	
typedef BitchDetector =
{
	var hasBitches:Bool;
	var bitchCounter:Int;
	var fakeBitchRemover:Int;
	var finalBitchCount:String;
}
