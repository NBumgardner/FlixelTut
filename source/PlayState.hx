package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class PlayState extends FlxState
{
	private var _player:Player;
	private var _map:FlxOgmoLoader;
	private var _mWalls:FlxTilemap;
	private var _grpCoins:FlxTypedGroup<Coin>;
	private var _grpEnemies:FlxTypedGroup<Enemy>;

	override public function create():Void
	{
		/*
		 * Load the room file into the FlxOgmoLoader object,
		 * Generate a FlxTilemap from the 'walls' layer,
		 * Set the floor tile (1) to not collide,
		 * Set the wall tile (2) to collide from any direction,
		 * Add walls to the state.
		 **/
		_map = new FlxOgmoLoader(AssetPaths.room_001__oel);
		_mWalls = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
		_mWalls.follow();
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
		add(_mWalls);

		// Add entities to the room: Coins, Enemies, Player
		_grpCoins = new FlxTypedGroup<Coin>();
		add(_grpCoins);
		_grpEnemies = new FlxTypedGroup<Enemy>();
		add(_grpEnemies);
		_player = new Player();
		_map.loadEntities(placeEntities, "entities");
		add(_player);

		// Set camera to follow Player
		FlxG.camera.follow(_player, TOPDOWN, 1);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(_player, _mWalls);
		FlxG.overlap(_player, _grpCoins, playerTouchCoin);
	}

	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player")
		{
			_player.x = x;
			_player.y = y;
		}
		else if (entityName == "coin")
		{
			_grpCoins.add(new Coin(x + 4, y + 4));
		}
		else if (entityName == "enemy")
		{
			_grpEnemies.add(new Enemy(x + 4, y,
				Std.parseInt(entityData.get("etype"))));
		}
	}

	// Called when Player and a Coin overlap.
	private function playerTouchCoin(P:Player, C:Coin):Void
	{
		if (P.alive && P.exists && C.alive && C.exists)
		{
			// Remove coin.
			C.kill();
		}
	}
}