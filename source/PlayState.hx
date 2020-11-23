/*
 * File: PlayState.hx
 * Project: source
 * File Created: Monday, 16th November 2020 4:16:04 pm
 * Author: Hayden Kowalchuk
 * -----
 * Copyright (c) 2020 Hayden Kowalchuk, Hayden Kowalchuk
 * License: BSD 3-clause "New" or "Revised" License, http://www.opensource.org/licenses/BSD-3-Clause
 */

package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

enum GameState
{
	Playing;
	Won;
	Lost;
}

enum ControlType
{
	Keyboard;
	Mouse;
}

class PlayState extends FlxState
{
	var player:Player;
	var scoreText:FlxText;
	var restartText:FlxText;
	var debugText:FlxText;
	var _exteriorWalls:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	var _interiorWalls:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	var walls:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	var items:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	var enemies:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();

	static inline var EXTERIOR_WIDTH:Float = 20;
	static inline var INTERIOR_WIDTH:Float = 30;
	static inline var GAME_HEIGHT:Float = 480;

	var score:Int = 0;
	var state:GameState = GameState.Playing;

	public static var keyboard:Bool = true;

	override public function create()
	{
		FlxG.timeScale = 1;
		// FlxG.mouse.visible = false;

		player = new Player(170, 180);
		enemies.add(new EnemyChase(450, 50, player));
		enemies.add(new EnemyChase(200, 320, player));
		enemies.add(new EnemyPathed(createPath1()));
		enemies.add(new EnemyPathed(createPath2(), true));
		enemies.add(new EnemyJump(500, 200, player, 1.25));
		enemies.add(new EnemyJump(40, 440, player));

		/* Top Bottom Walls */
		_exteriorWalls.add(new Wall(2, 2, FlxG.width - 4, EXTERIOR_WIDTH, FlxColor.YELLOW));
		_exteriorWalls.add(new Wall(2, GAME_HEIGHT - EXTERIOR_WIDTH - 2, FlxG.width - 4, EXTERIOR_WIDTH, FlxColor.YELLOW));
		/* Left Right Walls */
		_exteriorWalls.add(new Wall(2, 2, EXTERIOR_WIDTH, GAME_HEIGHT - 4, FlxColor.YELLOW));
		_exteriorWalls.add(new Wall(FlxG.width - EXTERIOR_WIDTH - 2, 2, EXTERIOR_WIDTH, GAME_HEIGHT - 4, FlxColor.YELLOW));

		/* Interior Walls */
		/* Left Side */
		_interiorWalls.add(new Wall(40 + EXTERIOR_WIDTH, 60 + EXTERIOR_WIDTH, 320, INTERIOR_WIDTH, FlxColor.YELLOW));
		_interiorWalls.add(new Wall(40 + EXTERIOR_WIDTH, 240 + EXTERIOR_WIDTH, 320, INTERIOR_WIDTH, FlxColor.YELLOW));
		/* Right Side */
		_interiorWalls.add(new Wall(320 - 40 - EXTERIOR_WIDTH, 120 + INTERIOR_WIDTH + EXTERIOR_WIDTH, 320, INTERIOR_WIDTH, FlxColor.YELLOW));
		_interiorWalls.add(new Wall(320 - 40 - EXTERIOR_WIDTH, 240 + 60 + INTERIOR_WIDTH + EXTERIOR_WIDTH, 320, INTERIOR_WIDTH, FlxColor.YELLOW));

		items.add(new Pellet(320, 240));
		items.add(new Pellet(300, 40));
		items.add(new Pellet(580, 420));
		items.add(new Pellet(580, 40));
		items.add(new Pellet(160, 240));
		items.add(new Pellet(80, 360));

		for (wall in _exteriorWalls)
		{
			walls.add(wall);
		}
		for (wall in _interiorWalls)
		{
			walls.add(wall);
		}

		add(player);
		add(walls);
		add(items);
		add(enemies);

		scoreText = new FlxText(10, GAME_HEIGHT, -1, '', 32);
		restartText = new FlxText(10, GAME_HEIGHT - 80, -1, 'Space/Click to Restart', 32);
		restartText.screenCenter(FlxAxes.X);
		add(scoreText);
		debugText = new FlxText(10, 10, -1, '', 16);
		add(debugText);
		updateScoreText();
		super.create();
	}

	override public function update(elapsed:Float)
	{
		FlxG.collide(player, walls);
		FlxG.collide(enemies, walls);
		FlxG.collide(enemies, enemies);
		FlxG.overlap(player, items, pelletCollect);
		FlxG.overlap(player, enemies, enemyCollide);

		/*
			var _x:Float = FlxG.mouse.x;
			var _y:Float = FlxG.mouse.y;
			debugText.text = '$_x, $_y';
		 */

		if (state == Won || state == Lost)
		{
			if (FlxG.keys.pressed.SPACE || FlxG.mouse.justPressed)
			{
				FlxG.switchState(new PlayState());
			}
		}
		super.update(elapsed);
	}

	function updateScore()
	{
		score += 10;
		updateScoreText();
	}

	function updateScoreText()
	{
		if (score >= items.length * 10)
		{
			state = GameState.Won;
		}

		switch (state)
		{
			case Playing:
				scoreText.text = 'Score: $score';
			case Won:
				scoreText.screenCenter(FlxAxes.X);
				scoreText.color = FlxColor.LIME;
				scoreText.text = "You Win!";
				FlxG.timeScale = 0;
				add(restartText);
			case Lost:
				scoreText.screenCenter(FlxAxes.X);
				scoreText.color = FlxColor.RED;
				scoreText.text = "Game Over!";
				FlxG.timeScale = 0;
				add(restartText);
		}
	}

	function createPath1():haxe.ds.Vector<FlxPoint>
	{
		var pathList:haxe.ds.Vector<FlxPoint> = new haxe.ds.Vector(8);
		pathList[0] = new FlxPoint(480, 50);
		pathList[1] = new FlxPoint(480, 145);
		pathList[2] = new FlxPoint(90, 145);
		pathList[3] = new FlxPoint(90, 230);
		pathList[4] = new FlxPoint(550, 230);
		pathList[5] = new FlxPoint(550, 320);
		pathList[6] = new FlxPoint(80, 320);
		pathList[7] = new FlxPoint(80, 430);
		return pathList;
	}

	function createPath2():haxe.ds.Vector<FlxPoint>
	{
		var pathList:haxe.ds.Vector<FlxPoint> = new haxe.ds.Vector(4);
		pathList[2] = new FlxPoint(40, 50);
		pathList[3] = new FlxPoint(40, 420);
		pathList[0] = new FlxPoint(600, 420);
		pathList[1] = new FlxPoint(600, 50);
		return pathList;
	}

	function pelletCollect(object1:FlxObject, object2:FlxObject):Void
	{
		updateScore();
		object2.destroy();
	}

	function enemyCollide(object1:FlxObject, object2:FlxObject):Void
	{
		state = GameState.Lost;
		updateScoreText();
	}
}
