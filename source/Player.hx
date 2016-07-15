package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * Description:  Player class is controlled by the user's keyboard inputs.
 *   Valid controls are arrow keys and WASD.
 * @author Noah Bumgardner
 */
class Player extends FlxSprite
{
	public var speed:Float = 200;

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);

		// Add movement animations
		loadGraphic(AssetPaths.player__png, true, 16, 16);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		animation.add("lr", [3, 4, 3, 5], 6, false);
		animation.add("u", [6, 7, 6, 8], 6, false);
		animation.add("d", [0, 1, 0, 2], 6, false);

		drag.x = drag.y = 1600;
	}

	// Reads keyboard inputs to set the speed and angle of the Player.
	//   Diagonal movement is slower than vertical or horizontal movement.
	//   For animations, the Player faces UP or DOWN when moving diagonally.
	private function movement():Void
	{
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;

		// Check movement keys: Arrow keys and WASD.
		_up = FlxG.keys.anyPressed([UP, W]);
		_down = FlxG.keys.anyPressed([DOWN, S]);
		_left = FlxG.keys.anyPressed([LEFT, A]);
		_right = FlxG.keys.anyPressed([RIGHT, D]);

		// Opposite directions cancel each other, into false.
		if (_up && _down) 
		{
			_up = _down = false;
		}
		if (_left && _right)
		{
			_left = _right = false;
		}

		// If a valid move was made, calculate and set new movement speed and angle.
		//   Set 'facing' for the correct animation, based on angle 'mA'.
		if (_up || _down || _left || _right)
		{
			// Find angle of movement.
			//   0 is East or Right. 90 is North or Up.
			var mA:Float = 0;
			if (_up)
			{
				mA = -90;
				// Check for diagonal-up moves
				if (_left)
					mA -= 45;
				else if (_right)
					mA += 45;
				facing = FlxObject.UP; // the sprite should be facing UP
			}
			else if (_down)
			{
				mA = 90;
				// Check for diagonal-down moves
				if (_left)
					mA += 45;
				else if (_right)
					mA -= 45;
				facing = FlxObject.DOWN; // the sprite should be facing DOWN
			}
			else if (_left)
			{
				mA = 180;
				facing = FlxObject.LEFT; // the sprite should be facing LEFT
			}
			else if (_right)
			{
				mA = 0;
				facing = FlxObject.RIGHT; // the sprite should be facing RIGHT
			}

			// Set speed, then rotate it to angle mA.
			//   Diagonal moves are slower.
			velocity.set(speed, 0);
			velocity.rotate(FlxPoint.weak(0, 0), mA);

			// If Player is moving, velocity != 0 for an axis,
			//   then change the animation to match Player facing.
			if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE)
			{
				switch (facing) 
				{
					case FlxObject.LEFT, FlxObject.RIGHT:
						animation.play("lr");
					case FlxObject.UP:
						animation.play("u");
					case FlxObject.DOWN:
						animation.play("d");
				}
			}
		}
	}

	override public function update(elapsed:Float):Void 
	{
		movement();
		super.update(elapsed);
	}
}