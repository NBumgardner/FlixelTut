package;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

/**
 * Description:  Pick-up item for the player to collect by touching it.
 * @author Noah Bumgardner
 */
class Coin extends FlxSprite
{
	public function new(X:Float=0, Y:Float=0)
	{
		super(X, Y);
		loadGraphic(AssetPaths.coin__png, false, 8, 8);
	}

	// When a coin is destroyed, it plays an animation to fade and move up.
	override public function kill():Void
	{
		alive = false;
		FlxTween.tween(this, { alpha: 0, y: y - 16 }, .33,
			{ ease: FlxEase.circOut, onComplete: finishKill });
	}

	private function finishKill(_):Void
	{
		exists = false;
	}
}