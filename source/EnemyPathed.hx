/*
 * File: EnemyPathed.hx
 * Project: source
 * File Created: Monday, 16th November 2020 4:37:26 pm
 * Author: Hayden Kowalchuk
 * -----
 * Copyright (c) 2020 Hayden Kowalchuk, Hayden Kowalchuk
 * License: BSD 3-clause "New" or "Revised" License, http://www.opensource.org/licenses/BSD-3-Clause
 */

package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import haxe.Timer;
import haxe.ds.Vector;

using flixel.util.FlxSpriteUtil;

enum Direction
{
	Forward;
	Backward;
}

class EnemyPathed extends FlxSprite
{
	static inline var SPEED:Float = 200;
	static inline var HEIGHT:Float = 20;

	var lineStyle:LineStyle = {color: FlxColor.BLUE, thickness: 3};
	var drawStyle:DrawStyle = {smoothing: true};
	var currentPoint:Int = 0;
	var currentDirection:Direction = Direction.Forward;
	var pathList:haxe.ds.Vector<FlxPoint>;
	var doesLoop:Bool = false;

	public function new(path:haxe.ds.Vector<FlxPoint>, loop:Bool = false)
	{
		var x:Float = path[0].x;
		var y:Float = path[0].y;
		super(x, y);
		width = HEIGHT;
		height = HEIGHT;

		pathList = path;
		doesLoop = loop;

		var ellipseWidth:Float = 4;
		var ellipseHeight:Float = 4;
		makeGraphic(Std.int(HEIGHT), Std.int(HEIGHT), FlxColor.TRANSPARENT, true);
		this.drawRoundRect(1, 1, HEIGHT - 2, HEIGHT - 2, ellipseWidth, ellipseHeight, color, lineStyle, drawStyle);
		drag.x = drag.y = 200;

		if (path.length == 1)
		{
			this.active = false;
		}
	}

	function NextWaypoint()
	{
		switch (currentDirection)
		{
			case Forward:
				currentPoint++;
				if (currentPoint >= pathList.length)
				{
					if (doesLoop)
					{
						currentPoint = 0;
					}
					else
					{
						currentDirection = Backward;
						currentPoint = pathList.length - 1;
					}
				}
			case Backward:
				currentPoint--;
				if (currentPoint < 0)
				{
					currentDirection = Forward;
					currentPoint = 1;
				}
		}
	}

	function updateMovement()
	{
		var tempMid:FlxPoint = getMidpoint();

		/* Check if this ghost is close to the current target position, if so then begin moving to the next, otherwise keep moving towards the current */
		if (tempMid.distanceTo(pathList[currentPoint]) <= HEIGHT / 2)
		{
			NextWaypoint();
		}
		else
		{
			velocity.set(SPEED, 0);
			/* Some coordinate mixup */
			var _angle:Float = pathList[currentPoint].angleBetween(getMidpoint()) + 90;
			velocity.rotate(FlxPoint.weak(0, 0), _angle);
		}
	}

	override function update(elapsed:Float)
	{
		updateMovement();
		this.scale = FlxPoint.weak(0.9 + (0.1 * Math.sin(Timer.stamp())), 0.9 + (0.1 * Math.cos(Timer.stamp())));
		super.update(elapsed);
	}
}
