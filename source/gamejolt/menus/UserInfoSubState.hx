package gamejolt.menus;

import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import gamejolt.GJClient;

class UserInfoSubState extends MusicBeatSubstate
{
	var bg:FlxSprite;
	var extraBG:FlxSprite;
	var userPhoto:Null<FlxSprite> = null;
	var missInfo:FlxText;
	var curUser:Null<User>;

	public static var daUserID:Null<Int> = null;

	public function new()
	{
		super();
		openCallback = createMenu;
		closeCallback = function()
		{
			daUserID = null;
		};
	}

	function createMenu()
	{
		curUser = GJClient.getUserData(daUserID);

		bg = new FlxSprite().loadGraphic(Paths.image('menus/base/menuDesat'));
		bg.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
		bg.scrollFactor.set();
		bg.color = FlxColor.GRAY;
		bg.alpha = 0;
		add(bg);

		extraBG = new FlxSprite().makeGraphic(Std.int(FlxG.width * 0.85), Std.int(FlxG.height * 0.85), FlxColor.BLACK);
		extraBG.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
		extraBG.scrollFactor.set();
		extraBG.screenCenter();
		extraBG.alpha = 0;
		add(extraBG);

		if (curUser == null)
		{
			missInfo = new FlxText(0, 0, 0, "Failed to fetch User Info!\nPlease try again later");
			missInfo.setFormat(Paths.font('pixel'), 35, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
			missInfo.screenCenter();
			missInfo.scrollFactor.set();
			missInfo.visible = false;
			add(missInfo);

			FlxTween.tween(missInfo, {alpha: 0.25}, 0.5, {type: PINGPONG});
		}
		else
		{
			// Parameters
			var sep:Int = 15;
			var sep2:Int = 20;
			var daSize:Int = 25;
			var daFont:String = Paths.font('pixel');
			var daFont2:String = "VCR OSD Mono";
			var imgRatio:Int = Std.int(extraBG.width * 0.25);

			var daPic:Null<FlxGraphic> = GJClient.userGraphics.get(curUser.id);
			if (daPic != null)
			{
				userPhoto = new FlxSprite().loadGraphic(daPic);
				userPhoto.setGraphicSize(imgRatio, imgRatio);
				userPhoto.updateHitbox();
				userPhoto.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
				userPhoto.scrollFactor.set();
				userPhoto.alpha = 0;
				userPhoto.y = extraBG.y + sep2;
				userPhoto.x = extraBG.x + extraBG.width - userPhoto.width - (sep2 * 3);
			}

			var trophTotal:Null<Array<Trophy>> = GJClient.getTrophiesList();
			var trophAchieved:Int = 0;

			if (trophTotal != null)
				for (troph in trophTotal)
					if (troph.achieved != 'false')
						trophAchieved++;

			var trophGained = trophTotal != null ? '$trophAchieved/${trophTotal.length}' : 'N/A';

			var userName = new FlxText(extraBG.x + sep2, extraBG.y + sep2, 0, 'Username: ${curUser.developer_name}');
			userName.setFormat(daFont, daSize, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
			var userTag = new FlxText(userName.x, userName.y + userName.height + sep, 0, 'Tag: @${curUser.username}');
			userTag.setFormat(daFont, daSize, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
			var userType = new FlxText(userTag.x, userTag.y + userTag.height + sep, 0, 'Type of User: ${curUser.type}');
			userType.setFormat(daFont, daSize, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
			var userID = new FlxText(userType.x, userType.y + userType.height + sep, 0, 'User ID: ${curUser.id}');
			userID.setFormat(daFont, daSize, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
			var userWeb = new FlxText(userID.x, userID.y + userID.height + sep, 0,
				'Website: ${curUser.developer_website != '' ? curUser.developer_website : "(Not Available)"}');
			userWeb.setFormat(daFont, daSize, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
			var userDesc = new FlxText(userWeb.x, userWeb.y + (userWeb.height * 3) + sep, extraBG.width - sep2,
				'Description: ${curUser.developer_description != '' ? curUser.developer_description : "(Not Available)"}');
			userDesc.setFormat(daFont2, Std.int(daSize * 1.5), FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);

			add(userName);
			add(userTag);
			add(userType);
			add(userID);
			add(userWeb);

			if (daUserID == null)
			{
				var userTrophs = new FlxText(userWeb.x, userWeb.y + userWeb.height + sep, 0, 'Trophies gained: $trophGained');
				userTrophs.setFormat(daFont, daSize, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
				add(userTrophs);
			}

			add(userDesc);

			if (userPhoto != null)
				add(userPhoto);

			forEachOfType(FlxText, function(txt:FlxText)
			{
				txt.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
				txt.scrollFactor.set();
				txt.visible = false;
			});

			if (userPhoto != null)
				FlxTween.tween(userPhoto, {alpha: 1}, 0.7);
		}

		FlxTween.tween(bg, {alpha: 1}, 0.7, {
			onComplete: function(twn:FlxTween)
			{
				if (curUser == null)
					missInfo.visible = true;
				else
					forEachOfType(FlxText, function(txt:FlxText)
					{
						txt.visible = true;
					});
			}
		});

		FlxTween.tween(extraBG, {alpha: 0.7}, 0.7);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Controls.getPressEvent('back'))
		{
			FlxTween.tween(bg, {alpha: 0}, 0.7, {
				onComplete: function(twn:FlxTween)
				{
					close();
				}
			});
			FlxTween.tween(extraBG, {alpha: 0}, 0.7);
			if (curUser != null)
			{
				if (userPhoto != null)
					FlxTween.tween(userPhoto, {alpha: 0}, 0.7);

				forEachOfType(FlxText, function(txt:FlxText)
				{
					FlxTween.tween(txt, {alpha: 0}, 0.7);
				});
			}
			else
			{
				FlxTween.cancelTweensOf(missInfo);
				FlxTween.tween(missInfo, {alpha: 0}, 0.7);
			}
		}
	}
}
