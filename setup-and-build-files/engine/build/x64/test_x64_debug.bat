@echo off
color 0a
title Running Game (DEBUG MODE)
echo BUILDING...
cd ../../../../
haxelib run lime test windows -debug
echo. 
echo DONE
pause