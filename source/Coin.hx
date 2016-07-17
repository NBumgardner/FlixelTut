package;
import flixel.FlxSprite;

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
}