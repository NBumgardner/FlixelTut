# FlixelTut
This dungeon crawler video game is my hand-coded version of a [HaxeFlixel tutorial](http://haxeflixel.com/documentation/tutorial/).

I documented functions, used provided assets, and omitted parts of [section 13](http://haxeflixel.com/documentation/multiple-platforms/)
since I could not test it on **Windows** or **Android** builds. For the 2-3 files I was asked to copy:
I made a note in the commit, read over the copied code, and fixed any typos I found.

## Build Steps

Below are two methods for building the full **Flash** version of the game.

### Method 1: Using the HaxeDevelop IDE

* Open FlixelTut.hxproj
*Current settings should be (Configuration -> Release) and (Target Build -> flash).*
* Press F8 to build project
* Press F5 to test project
*Default browser should open a new tab with the game being played.*

### Method 2: Using the Command Line
Run the following command inside the *FlixelTut* folder:

```
haxelib run lime test flash
```

This command may require the project to already be built.

## Dependencies
Standard HaxeFlixel dependencies include [HaxeFlixel](http://haxeflixel.com/download/), [Haxe](http://www.haxe.org/download), and [OpenFL](http://www.openfl.org/download/). This project also requires [Flash player](https://get.adobe.com/flashplayer/).

Optionally, [HaxeDevelop](http://www.haxedevelop.org/download.html) IDE makes the source code easier to navigate. [Ogmo Editor](http://www.ogmoeditor.com/) was used for editing the dungeon map.

"This tutorial is geared towards building for Flash, Windows, and Android" ([Tutorial](http://haxeflixel.com/documentation/tutorial/)).
