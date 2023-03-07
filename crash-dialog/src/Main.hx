package;

import haxe.ui.HaxeUIApp;
import haxe.ui.components.Button;
import haxe.ui.components.Label;
import haxe.ui.core.Component;
import haxe.ui.macros.ComponentMacros;
import sys.io.File;
import sys.io.Process;

class Main
{
	/*
		massive thanks to gedehari for the crash dialog code
	 */
	static final quotes:Array<String> = [
		"I bet you lost to that fucking square. - DEMOLITIONDON96",
		"Glitched Mickey is in your walls. - DEMOLITIONDON96",
		"Lmao you really got hunted - Jason",
		"i have inserted a virus on your PC /j - Jason",
		"read bellow. - Jason",
		"walter. - Literally everyone in the F.AVI Dev Team",
		"Walt just hates you that much, huh? - DEMOLITIONDON96",
		"Ooga booga, go back to Africa. (Santa, probably), - Jason"
		"I'm gonna get racist. - DEMOLITIONDON96",
		"Ah bueno adios master - ShadowMario",
		"Skibidy bah mmm dada *explodes* - ShadowMario", // Changed my mind, Shadow mario is peak - jason
		"Well at least it isn't a openGl error - Jason",
		"Let me guess, Null Object Reference - Jason",
		"Have you even read the wiki before trying that? - BeastlyGhost",
		"for your information, that Vs Mouse collab is scrapped - Jason",
		"Not my fault. - Jason",
		'We lied, there\'s no sex - Jason',
		'We gonna fix it i swear - Jason'
	];

	public static function main()
	{
		var args:Array<String> = Sys.args();

		if (args[0] == null)
			Sys.exit(1);
		else
		{
			var path:String = args[0];
			var contents:String = File.getContent(path);
			var split:Array<String> = contents.split("\n");

			var app = new HaxeUIApp();

			app.ready(function()
			{
				var mainView:Component = ComponentMacros.buildComponent("assets/main-view.xml");
				app.addComponent(mainView);

				var messageLabel:Label = mainView.findComponent("message-label", Label);
				messageLabel.text = quotes[Std.random(quotes.length)] + "\nUnfortunately, Funkin.AVI has crashed.";
				messageLabel.percentWidth = 100;
				messageLabel.textAlign = "center";

				var callStackLabel:Label = mainView.findComponent("call-stack-label", Label);
				callStackLabel.text = "";
				for (i in 0...split.length - 4)
				{
					if (i == split.length - 5)
						callStackLabel.text += split[i];
					else
						callStackLabel.text += split[i] + "\n";
				}

				var crashReasonLabel:Label = mainView.findComponent("crash-reason-label", Label);
				crashReasonLabel.text = "";
				for (i in split.length - 3...split.length - 1)
				{
					if (i == split.length - 2)
						crashReasonLabel.text += split[i];
					else
						crashReasonLabel.text += split[i] + "\n";
				}

				mainView.findComponent("view-crash-dump-button", Button).onClick = function(_)
				{
					#if windows
					Sys.command("start", [path]);
					#elseif linux
					Sys.command("xdg-open", [path]);
					#end
				};

				mainView.findComponent("report-to-discord", Button).onClick = function(_)
				{
					Sys.command('start https://discord.gg/zbcE9hKkz4');

					Sys.exit(0);
				};

				mainView.findComponent("close-button", Button).onClick = function(_)
				{
					Sys.exit(0);
				};

				app.start();
			});
		}
	}
}
