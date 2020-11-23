/*
 * File: Wall.hx
 * Project: source
 * File Created: Monday, 16th November 2020 5:22:39 pm
 * Author: Hayden Kowalchuk
 * -----
 * Copyright (c) 2020 Hayden Kowalchuk, Hayden Kowalchuk
 * License: BSD 3-clause "New" or "Revised" License, http://www.opensource.org/licenses/BSD-3-Clause
 */

package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class Wall extends FlxSprite
{
	static inline var SPEED:Float = 200;
	static inline var HEIGHT:Float = 20;

	private var lineStyle:LineStyle = {color: FlxColor.RED, thickness: 3};
	private var drawStyle:DrawStyle = {smoothing: true};

	public function new(x:Float = 0, y:Float = 0, _width:Float = 100, _height:Float = 100, _color:FlxColor = FlxColor.RED)
	{
		super(x, y);
		this.width = _width;
		this.height = _height;
		makeGraphic(Std.int(_width), Std.int(_height), FlxColor.TRANSPARENT, true);
		lineStyle.color = _color;
		// makeGraphic(Std.int(_width), Std.int(_height), FlxColor.GRAY, true);
		this.drawRect(0, 0, width, height, color, lineStyle, drawStyle);
		this.immovable = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
