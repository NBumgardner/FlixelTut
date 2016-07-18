package;

/**
 * Description:  Controls behavior of enemies.
 * States:
 *   Idle   --  Cannot see Player. Wanders aimlessly.
 *   Chase  --  Can see Player. Runs toward Player.
 * @author Noah Bumgardner
 */
class FSM
{
	public var activeState:Void->Void;

	public function new(?InitState:Void->Void):Void 
	{
		activeState = InitState;
	}

	public function update():Void
	{
		if (activeState != null)
			activeState();
	}
}