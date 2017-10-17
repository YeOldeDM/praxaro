## FILE STRUCTURE GUIDE

The project folder is /GAME  

Game Assets (graphics, sound, etc) will go in the /assets folder  
The assets folder is divided into /graphics for graphics, /sfx for sound fx, and /bgm for music
Assets should be organized within those folders accordingly.  

Scene files and their associated scripts go in the /scenes folder.  
Each non-level scene should have its own folder, named after the scene itself, which should be PascalCase.  
Game.tscn, whose base node is named "Game", goes in `res://scenes/Game/` along with its script which is named Game.gd  
HUD.tscn, which is an integral part of Game's tree, goes in `res://scenes/Game/HUD/` along with HUD.gd  

Scenes which are dedicated instances within another scene should be in a subfolder within that other scene's folder.  

Scenes which are numerous and common should go in a common scenes folder. These include: levels, mobs, pickups...  

Resource files (styles, themes, tilesets) should go in the /res folder.  

Singleton scripts/scenes go in the /global folder.

