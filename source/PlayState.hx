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
using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
	private var _player:Player;
	private var _map:FlxOgmoLoader;
	private var _mWalls:FlxTilemap;
	private var _grpCoins:FlxTypedGroup<Coin>;
	private var _grpEnemies:FlxTypedGroup<Enemy>;
	private var _hud:HUD;
	private var _money:Int = 0;
	private var _health:Int = 3;
	private var _inCombat:Bool = false;
	private var _combatHud:CombatHUD;

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

		// Create always-visible HUD.
		_hud = new HUD();
		add(_hud);

		// Create hidden Combat HUD.
		_combatHud = new CombatHUD();
		add(_combatHud);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (!_inCombat)
		{
			// Movement section of game.
			// Check for collisions and enemy vision.
			FlxG.collide(_player, _mWalls);
			FlxG.overlap(_player, _grpCoins, playerTouchCoin);
			FlxG.collide(_grpEnemies, _mWalls);
			_grpEnemies.forEachAlive(checkEnemyVision);
			FlxG.overlap(_player, _grpEnemies, playerTouchEnemy);
		}
		else
		{
			// Combat section of game.
			if (!_combatHud.visible)
			{
				// Combat is over
				_health = _combatHud.playerHealth;
				_hud.updateHUD(_health, _money);
				if (_combatHud.outcome == VICTORY)
				{
					// Combat is won, enemy dies.
					_combatHud.e.kill();
				}
				else
				{
					// Combat has ended, enemy starts to flicker.
					_combatHud.e.flicker();
				}
				_inCombat = false;
				_player.active = true;
				_grpEnemies.active = true;
			}
			// Else combat continues.
		}
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
			_money++;
			_hud.updateHUD(_health, _money);
		}
	}

	private function checkEnemyVision(e:Enemy):Void
	{
		// Draws a ray between the enemy and player.
		//   Returns false if a wall is between them.
		if (_mWalls.ray(e.getMidpoint(), _player.getMidpoint()))
		{
			e.seesPlayer = true;
			e.playerPos.copyFrom(_player.getMidpoint());
		}
		else
			e.seesPlayer = false;
	}

	private function playerTouchEnemy(P:Player, E:Enemy):Void
	{
		// If Player and an enemy touch,
		//   and the enemy is not flickering, combat begins.
		if (P.alive && P.exists && E.alive && E.exists && !E.isFlickering())
			startCombat(E);
	}

	private function startCombat(E:Enemy):Void
	{
		// Set variables to begin combat.
		_inCombat = true;
		_player.active = false;
		_grpEnemies.active = false;
		_combatHud.initCombat(_health, E);
	}
}