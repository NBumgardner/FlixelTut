package;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.system.FlxSound;
using flixel.util.FlxSpriteUtil;

/**
 * Description:  Enemy is a common class for all enemies in the game.
 *   Has similarities to the Player class.
 * @author Noah Bumgardner
 */
class Enemy extends FlxSprite
{
	private var _sndStep:FlxSound;
	public var speed:Float = 140;
	// Determines enemy's type.
	//   0: Common enemy, many per room.
	//   1: Boss enemy, one per room.
	public var etype(default, null):Int;

	// AI variables
	private var _brain:FSM;  // Finite-State Machine
	private var _idleTmr:Float;  // idle Timer
	private var _moveDir:Float;  // move Direction
	public var seesPlayer:Bool = false;
	public var playerPos(default, null):FlxPoint;  // player Position

	public function new(X:Float=0, Y:Float=0, EType:Int)
	{
		super(X, Y);
		etype = EType;

		// Add movement animations
		loadGraphic("assets/images/enemy-" + etype + ".png", true, 16, 16);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		animation.add("d", [0, 1, 0, 2], 6, false);
		animation.add("lr", [3, 4, 3, 5], 6, false);
		animation.add("u", [6, 7, 6, 8], 6, false);

		drag.x = drag.y = 10;
		// Reduce hitbox size
		width = 8;
		height = 14;
		offset.x = 4;
		offset.y = 2;

		// Initialize AI variables
		_brain = new FSM(idle);
		_idleTmr = 0;
		playerPos = FlxPoint.get();

		// Prepare footstep sound. Plays quieter when
		//   enemy is further from the camera/player.
		_sndStep = FlxG.sound.load(AssetPaths.step__wav, .4);
		_sndStep.proximity(x, y, FlxG.camera.target, FlxG.width * .6);
	}

	override public function draw():Void
	{
		// If Enemy is moving, velocity != 0 for an axis,
		//   then change the animation to match Enemy facing.
		if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE)
		{
			if (Math.abs(velocity.x) > Math.abs(velocity.y))
			{
				if (velocity.x < 0)
					facing = FlxObject.LEFT;
				else
					facing = FlxObject.RIGHT;
			}
			else
			{
				if (velocity.y < 0)
					facing = FlxObject.UP;
				else
					facing = FlxObject.DOWN;
			}

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
		super.draw();
	}

	public function idle():Void
	{
		/**
		 * Chase Player if visible. Otherwise wait until the idle timer ends;
		 *   then take a 50% chance to move in a random direction before
		 *   resetting the idle timer.
		 */
		if (seesPlayer)
		{
			_brain.activeState = chase;
		}
		else if (_idleTmr <= 0)
		{
			if (FlxG.random.bool(1))
			{
				// Stop moving
				_moveDir = -1;
				velocity.x = velocity.y = 0;
			}
			else
			{
				// Move in random direction
				_moveDir = FlxG.random.int(0, 8) * 45;
				velocity.set(speed * .5, 0);
				velocity.rotate(FlxPoint.weak(), _moveDir);
			}
			// Set idle timer
			_idleTmr = FlxG.random.int(1, 4);
		}
		else
			_idleTmr -= FlxG.elapsed;
	}

	public function chase():Void
	{
		if (!seesPlayer)
		{
			// Lost sight of Player. Return to idle state.
			_brain.activeState = idle;
		}
		else
		{
			FlxVelocity.moveTowardsPoint(this, playerPos, Std.int(speed));
		}
	}

	override public function update(elapsed:Float):Void
	{
		if (isFlickering())
			return;
		_brain.update();
		super.update(elapsed);

		// If enemy is moving, play the footstep sound.
		if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE)
		{
			_sndStep.setPosition(x + frameWidth / 2, y + height);
			_sndStep.play();
		}
	}

	// Used in CombatHUD.hx to display the correct enemy sprite.
	public function changeEnemy(EType:Int):Void
	{
		if (etype != EType)
		{
			etype = EType;
			loadGraphic("assets/images/enemy-" + etype + ".png", true, 16, 16);
		}
	}
}