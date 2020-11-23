/*
 * File: Pellet.hx
 * Project: source
 * File Created: Monday, 16th November 2020 6:19:41 pm
 * Author: Hayden Kowalchuk
 * -----
 * Copyright (c) 2020 Hayden Kowalchuk, Hayden Kowalchuk
 * License: BSD 3-clause "New" or "Revised" License, http://www.opensource.org/licenses/BSD-3-Clause
 */

package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class Pellet extends FlxSprite
{
	static inline var SIZE:Float = 20;

	private var lineStyle:LineStyle = {color: FlxColor.LIME, thickness: 3};
	private var drawStyle:DrawStyle = {smoothing: true};

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		this.width = SIZE;
		this.height = SIZE;
		makeGraphic(Std.int(SIZE), Std.int(SIZE), FlxColor.TRANSPARENT, true);
		this.drawRect(1, 1, SIZE - 2, SIZE - 2, color, lineStyle, drawStyle);
		this.immovable = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
