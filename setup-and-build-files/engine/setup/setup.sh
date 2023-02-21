#!/bin/bash
# FOR LINUX, based off of setup.bat
# go to https://haxe.org/download/linux/ to install the latest version of Haxe
# you may or may not need to run "haxelib setup"
# you may also need to run "chmod +x setup" to mark this file as an executable
haxelib install lime
haxelib install openfl
haxelib install flixel
haxelib run lime setup flixel
haxelib run lime setup
haxelib install flixel-tools
haxelib install flixel-addons
haxelib run flixel-tools setup
haxelib install hxcpp-debug-server
haxelib git SScript https://github.com/AltronMaxX/SScript
haxelib git hxCodec https://github.com/polybiusproxy/hxCodec
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib git polymod https://github.com/MasterEric/polymod
sudo apt install g++
haxelib install hxcpp
haxelib git tentools https://github.com/TentaRJ/tentools.git
haxelib git systools https://github.com/haya3218/systools
haxelib run lime rebuild systools linux
