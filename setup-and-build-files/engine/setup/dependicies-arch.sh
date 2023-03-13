#!/bin/bash

echo This reqiures Root Permission. Make sure to have a secure internet connection before proceeding.
sudo pacman -Syu paru --noconfirm --needed
paru -Syu haxe neko git --noconfirm --needed
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