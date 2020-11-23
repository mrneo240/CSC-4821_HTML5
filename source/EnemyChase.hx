/*
 * File: EnemyChase.hx
 * Project: source
 * File Created: Monday, 16th November 2020 4:34:38 pm
 * Author: Hayden Kowalchuk
 * -----
 * Copyright (c) 2020 Hayden Kowalchuk, Hayden Kowalchuk
 * License: BSD 3-clause "New" or "Revised" License, http://www.opensource.org/licenses/BSD-3-Clause
 */

package;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import haxe.Timer;

using flixel.util.FlxSpriteUtil;

class EnemyChase extends FlxSprite
{
	static inline var SPEED:Float = 140;
	static inline var HEIGHT:Float = 20;
	static inline var SEARCH_RANGE:Float = 320;

	var lineStyle:LineStyle = {color: FlxColor.RED, thickness: 3};
	var drawStyle:DrawStyle = {smoothing: true};

	var lineSpr:FlxSprite;
	var player:Player;
	var _angle:Float;

	public function new(x:Float = 0, y:Float = 0, _player:Player)
	{
		super(x, y);
		this.width = HEIGHT;
		this.height = HEIGHT;
		makeGraphic(Std.int(HEIGHT), Std.int(HEIGHT), FlxColor.TRANSPARENT, true);
		this.drawTriangle(1, 1, HEIGHT - 1, color, lineStyle, drawStyle);
		drag.x = drag.y = 200;
		/* Debugging related */
		/*
			lineSpr = new FlxSprite(0, 0);
			lineSpr.makeGraphic(640, 480, FlxColor.TRANSPARENT, true);
			FlxG.state.add(lineSpr);
		 */
		player = _player;
		if (player == null)
		{
			this.active = false;
		}
	}

	function updateRay()
	{
		var direction:FlxPoint = player.getMidpoint();
		var temp = getMidpoint();
		direction.subtractPoint(temp);
		var dx:Float = direction.x;
		var dy:Float = direction.y;
		var length:Float = FlxMath.vectorLength(dx, dy);
		direction.x = direction.x / length;
		direction.y = direction.y / length;

		var distance:Float = getMidpoint().distanceTo(player.getMidpoint());
		if (distance > SEARCH_RANGE)
		{
			distance = SEARCH_RANGE;
		}
		else
		{
			velocity.set(SPEED, 0);
			/* Some coordinate mixup */
			_angle = player.getMidpoint().angleBetween(getMidpoint()) + 90;
			velocity.rotate(FlxPoint.weak(0, 0), _angle);
		}
		/* Debugging related */
		/*
			lineSpr.fill(FlxColor.TRANSPARENT);
			lineSpr.drawLine(temp.x, temp.y, temp.x + direction.x * distance, temp.y + direction.y * distance, lineStyle);
		 */
	}

	/*
		public function getRot():Float
		{
			return _angle;
		}
	 */
	override function update(elapsed:Float)
	{
		updateRay();
		this.scale = FlxPoint.weak(0.9 + (0.1 * Math.cos(Timer.stamp())), 0.9 + (0.1 * Math.cos(Timer.stamp())));
		super.update(elapsed);
	}
}
