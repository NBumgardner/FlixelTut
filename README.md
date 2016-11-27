# FlixelTut
This dungeon crawler video game is my hand-coded version of a [HaxeFlixel tutorial](http://haxeflixel.com/documentation/tutorial/).

I completed sections 1-12, half of section 13, and documented each function. For the 2-3 files I was asked to copy: I made a note in the commit, read over the copied code, and fixed any typos I found.

## Build Steps

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

### Untested Features
Two Windows-specific features have not yet been tested.

* Fullscreen button
* Exit game button

Their code comes from [section 13 of the tutorial](http://haxeflixel.com/documentation/multiple-platforms/).

## Dependencies
Standard HaxeFlixel dependencies include [HaxeFlixel](http://haxeflixel.com/download/), [Haxe](http://www.haxe.org/download), and [OpenFL](http://www.openfl.org/download/). This project also requires [Flash player](https://get.adobe.com/flashplayer/).

Optionally, [HaxeDevelop](http://www.haxedevelop.org/download.html) IDE makes the source code easier to navigate. [Ogmo Editor](http://www.ogmoeditor.com/) was used for editing the dungeon map.

"This tutorial is geared towards building for Flash, Windows, and Android" ([Tutorial](http://haxeflixel.com/documentation/tutorial/)).
