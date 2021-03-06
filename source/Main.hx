package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.util.FlxSave;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(320, 240, MenuState));

		// Load saved volume, if any.
		var _save:FlxSave = new FlxSave();
		_save.bind("flixel-tutorial");
		if (_save.data.volume != null)
		{
			FlxG.sound.volume = _save.data.volume;
		}
		_save.close();

		FlxG.sound.playMusic(AssetPaths.HaxeFlixel_Tutorial_Game__mp3, 1, true);
	}
}