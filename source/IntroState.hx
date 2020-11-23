/*
 * File: IntroState.hx
 * Project: source
 * File Created: Monday, 16th November 2020 9:02:41 pm
 * Author: Hayden Kowalchuk
 * -----
 * Copyright (c) 2020 Hayden Kowalchuk, Hayden Kowalchuk
 * License: BSD 3-clause "New" or "Revised" License, http://www.opensource.org/licenses/BSD-3-Clause
 */

package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.mouse.FlxMouseButton.FlxMouseButtonID;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class IntroState extends FlxState
{
	static inline var EXTERIOR_WIDTH:Float = 20;
	static inline var INTERIOR_WIDTH:Float = 30;
	static inline var GAME_HEIGHT:Float = 480;

	static inline var PAL_TEAL:FlxColor = 0xff9ad3bc;
	static inline var PAL_TAN:FlxColor = 0xfff3eac2;
	static inline var PAL_ORANGE:FlxColor = 0xfff5b461;
	static inline var PAL_RED:FlxColor = 0xffec524b;

	var keyboardControlSelected:FlxSprite;
	var mouseControlSelected:FlxSprite;

	var debugText:FlxText;

	// var lineStyle:LineStyle = {color: PAL_ORANGE, thickness: 2};
	// var drawStyle:DrawStyle = {smoothing: true};

	function createBox(x:Int, y:Int, width:Float, height:Float, innerColor:FlxColor = PAL_ORANGE, lineColor:FlxColor = PAL_ORANGE):FlxSprite
	{
		var ellipseWidth:Float = 4;
		var ellipseHeight:Float = 4;

		var temp:FlxSprite = new FlxSprite(x, y);
		temp.makeGraphic(Std.int(width), Std.int(height), FlxColor.TRANSPARENT, true);
		temp.drawRoundRect(1, 1, width - 2, height - 2, ellipseWidth, ellipseHeight, innerColor, {color: lineColor, thickness: 2}, {smoothing: true});
		return temp;
	}

	override public function create():Void
	{
		super.create();

		// Title
		var text1:FlxText = new FlxText(10, 10, -1, 'Maze Game', 48);
		text1.screenCenter(FlxAxes.X);
		add(createBox(130, 70, 360, 10, PAL_TEAL, PAL_TEAL));

		/* Controls */
		add(createBox(20, 100, 180, 280, FlxColor.TRANSPARENT));
		var text2:FlxText = new FlxText(24, 100, -1, 'Controls', 32);
		add(createBox(40, 140, 140, 10, PAL_RED, PAL_RED));
		var text12:FlxText = new FlxText(24, 160, -1, 'You', 24);
		var player:Player = new Player(160, 170, false);

		var text3:FlxText = new FlxText(24, 200, -1, 'WASD', 24);
		var text4:FlxText = new FlxText(24, 230, -1, 'Arrow keys', 24);
		keyboardControlSelected = createBox(24, 200, 172, 66, FlxColor.TRANSPARENT, PAL_TEAL);
		var text15:FlxText = new FlxText(90, 270, -1, 'OR', 24);
		var text13:FlxText = new FlxText(24, 310, -1, 'Follow', 24);
		var text14:FlxText = new FlxText(24, 340, -1, '  Mouse', 24);
		mouseControlSelected = createBox(24, 310, 172, 66, FlxColor.TRANSPARENT, PAL_TEAL);
		keyboardControlSelected.visible = true;
		mouseControlSelected.visible = true;
		add(keyboardControlSelected);
		add(mouseControlSelected);
		add(player);

		/* Enemies */
		add(createBox(230, 100, 180, 280, FlxColor.TRANSPARENT));
		var text5:FlxText = new FlxText(264, 100, -1, 'Avoid', 32);
		add(createBox(250, 140, 140, 10, PAL_RED, PAL_RED));
		var text6:FlxText = new FlxText(234, 160, -1, 'Chase', 24);
		var text7:FlxText = new FlxText(234, 190, -1, 'Patrol', 24);
		var text9:FlxText = new FlxText(234, 220, -1, 'Jump', 24);

		add(new EnemyChase(380, 170, null));
		var pathList:haxe.ds.Vector<FlxPoint> = new haxe.ds.Vector(1);
		pathList[0] = new FlxPoint(380, 200);
		add(new EnemyPathed(pathList, true));
		add(new EnemyJump(380, 230, null));

		/* Goal */
		add(createBox(440, 100, 180, 280, FlxColor.TRANSPARENT));
		var text8:FlxText = new FlxText(464, 100, -1, 'Collect', 32);
		add(createBox(460, 140, 140, 10, PAL_RED, PAL_RED));
		for (i in 0...5)
		{
			add(new Pellet(460 + (i * 30), 160));
		}
		var text10:FlxText = new FlxText(454, 190, -1, 'All to win!', 24);

		/* Start */
		var text11:FlxText = new FlxText(10, FlxG.height - 80, -1, 'Space to Start!', 48);
		text11.screenCenter(FlxAxes.X);
		var startBox = createBox(20, FlxG.height - 80, FlxG.width - 40, 60, FlxColor.TRANSPARENT);
		add(startBox);

		add(text1);
		add(text2);
		add(text3);
		add(text4);
		add(text5);
		add(text6);
		add(text7);
		add(text8);
		add(text9);
		add(text10);
		add(text11);
		add(text12);
		add(text13);
		add(text14);
		add(text15);
		debugText = new FlxText(10, 10, -1, '', 16);
		add(debugText);

		var pixelPerfect = false;
		FlxMouseEventManager.add(startBox, mousePressedCallback, null, null, null, false, true, pixelPerfect, [FlxMouseButtonID.LEFT]);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		/* Debugging related */
		/*
			var _x:Float = FlxG.mouse.x;
			var _y:Float = FlxG.mouse.y;
			debugText.text = '$_x, $_y';
		 */
		if (FlxG.keys.pressed.SPACE)
		{
			PlayState.keyboard = true;
			FlxG.switchState(new PlayState());
		}
	}

	function mousePressedCallback(sprite:FlxSprite)
	{
		if (FlxG.mouse.justPressed)
		{
			PlayState.keyboard = false;
			FlxG.switchState(new PlayState());
		}
	}
}
