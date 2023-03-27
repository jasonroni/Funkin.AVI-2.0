#!/bin/bash
# FOR LINUX, based off of setup.bat
# go to https://haxe.org/download/linux/ to install the latest version of Haxe
echo This reqiures Root Permission
echo This will also install a frontend for apt known as nala which is faster for downloads
sudo apt install nala -y
sudo nala install haxe neko g++ vlc -y --update
echo ""
echo "The reason why the latest version of Haxe was not installed is because Haxe does not have the proper files for newer Ubuntu builds."
read -p "Press Enter to continue..."
haxelib setup ~/haxelib
haxelib install haxelib
haxelib install lime
haxelib install openfl
haxelib install flixel
haxelib install hscript
haxelib install newgrounds
haxelib run lime setup flixel
haxelib run lime setup
haxelib install flixel-tools
haxelib install flixel-addons
haxelib run flixel-tools setup
haxelib install hxcpp-debug-server
haxelib git SScript https://github.com/AltronMaxX/SScript
haxelib git hxCodec https://github.com/polybiusproxy/hxCodec
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib install polymod
haxelib install hxcpp
haxelib git tentools https://github.com/TentaRJ/tentools.git
haxelib git systools https://github.com/haya3218/systools
haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons
haxelib run lime rebuild systools linux