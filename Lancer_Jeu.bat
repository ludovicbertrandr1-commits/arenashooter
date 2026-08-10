@echo off
title Synchronisation et Lancement Godot
echo Recuperation des derniers fichiers sur GitHub...

:: On attend explicitement la fin de la commande Git
call git pull origin main

echo.
echo Lancement de Godot...
:: Lance Godot
start "" "C:\Users\Ludo\Desktop\Godot_v4.6.2-stable_win64.exe" --editor .