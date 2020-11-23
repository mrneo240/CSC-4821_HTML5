/*
 * File: Player.hx
 * Project: source
 * File Created: Monday, 16th November 2020 4:20:13 pm
 * Author: Hayden Kowalchuk
 * -----
 * Copyright (c) 2020 Hayden Kowalchuk, Hayden Kowalchuk
 * License: BSD 3-clause "New" or "Revised" License, http://www.opensource.org/licenses/BSD-3-Clause
 */

package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class Player extends FlxSprite
{
	static inline var SPEED:Float = 200;
	static inline var RADIUS:Float = 10;

	var lineStyle:LineStyle = {color: FlxColor.PINK, thickness: 3};
	var drawStyle:DrawStyle = {smoothing: true};

	public function new(x:Float = 0, y:Float = 0, enabled:Bool = true)
	{
		super(x, y);
		this.width = RADIUS * 2;
		this.height = RADIUS * 2;
		makeGraphic(Std.int(RADIUS) * 2, Std.int(RADIUS) * 2, FlxColor.TRANSPARENT, true);
		this.drawCircle(-1, -1, RADIUS - 1, color, lineStyle, drawStyle);
		drag.x = drag.y = 200;
		this.active = enabled;
	}

	function updateMovement()
	{
		if (PlayState.keyboard)
		{
			var up:Bool = false;
			var right:Bool = false;
			var left:Bool = false;
			var down:Bool = false;

			up = FlxG.keys.anyPressed([UP, W]);
			right = FlxG.keys.anyPressed([RIGHT, D]);
			left = FlxG.keys.anyPressed([LEFT, A]);
			down = FlxG.keys.anyPressed([DOWN, S]);

			if (up && down)
				up = down = false;

			if (left && right)
				left = right = false;

			if (up || down || left || right)
			{
				var newAngle:Float = 0;
				if (up)
				{
					newAngle = -90;
					if (left)
						newAngle -= 45;
					else if (right)
						newAngle += 45;
				}
				else if (down)
				{
					newAngle = 90;
					if (left)
						newAngle += 45;
					else if (right)
						newAngle -= 45;
				}
				else if (left)
					newAngle = 180;
				else if (right)
					newAngle = 0;

				velocity.set(SPEED, 0);
				velocity.rotate(FlxPoint.weak(0, 0), newAngle);
			}
		}
		else
		{
			if (FlxG.mouse.pressed)
			{/* Some coordinate mixup */
				var newAngle:Float = FlxG.mouse.getPosition().angleBetween(getMidpoint()) + 90;
				velocity.set(SPEED, 0);
				velocity.rotate(FlxPoint.weak(0, 0), newAngle);
			}
		}
	}

	override function update(elapsed:Float)
	{
		updateMovement();
		super.update(elapsed);
	}
}
