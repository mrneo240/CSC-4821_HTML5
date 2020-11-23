/*
 * File: EnemyJump.hx
 * Project: source
 * File Created: Monday, 16th November 2020 4:44:24 pm
 * Author: Hayden Kowalchuk
 * -----
 * Copyright (c) 2020 Hayden Kowalchuk, Hayden Kowalchuk
 * License: BSD 3-clause "New" or "Revised" License, http://www.opensource.org/licenses/BSD-3-Clause
 */

package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.shapes.FlxShapeLine;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Timer;

using flixel.util.FlxSpriteUtil;

class EnemyJump extends FlxSprite
{
	static inline var SPEED:Float = 250;
	static inline var RADIUS:Float = 10;
	static var TWELVE_O_CLOCK = Math.PI;
	static inline var PAUSE_RANGE:Float = 15;

	var checkTimer:FlxTimer;
	var _angle:Float;
	var lineStyle:LineStyle = {color: FlxColor.RED, thickness: 3};
	var drawStyle:DrawStyle = {smoothing: true};
	var player:Player;
	var lineSpr:FlxSprite;

	var lineSprite1:FlxShapeLine;
	var lineSprite2:FlxShapeLine;

	var currentAttackPoint:FlxPoint;
	var currentAttackDirection:FlxPoint;
	var currentAttackDistance:Float;

	public function new(x:Float = 0, y:Float = 0, _player:Player, wait:Float = 0)
	{
		var points:Int = 5; /* Classic 5 point star */
		var startAngle:Float = TWELVE_O_CLOCK;

		var pointOffsetAngle = ((Math.PI * 2.0) / points);
		var _currentAngle = startAngle;

		var vertices = new Array<FlxPoint>();
		var temp = new Array<FlxPoint>();
		for (i in 0...points)
		{
			temp[i] = new FlxPoint(RADIUS * Math.sin(_currentAngle) + (RADIUS), RADIUS * Math.cos(_currentAngle) + (RADIUS));
			_currentAngle += pointOffsetAngle;
		}
		vertices[0] = temp[0];
		vertices[1] = temp[2];
		vertices[2] = temp[4];
		vertices[3] = temp[1];
		vertices[4] = temp[3];
		vertices[5] = temp[0];

		super(x, y);
		this.width = RADIUS * 2;
		this.height = RADIUS * 2;
		makeGraphic(Std.int(RADIUS) * 2, Std.int(RADIUS) * 2, FlxColor.TRANSPARENT, true);
		this.drawPolygon(vertices, color, lineStyle, drawStyle);
		player = _player;
		drag.x = drag.y = 200;

		currentAttackPoint = getMidpoint();
		currentAttackDirection = FlxPoint.weak(0, 0);
		lineSpr = new FlxSprite(0, 0);
		lineSpr.makeGraphic(640, 480, FlxColor.TRANSPARENT, true);
		FlxG.state.add(lineSpr);

		lineSprite1 = new FlxShapeLine(0, 0, new FlxPoint(0, 0), new FlxPoint(10, 10), {thickness: 2, color: FlxColor.RED});
		lineSprite2 = new FlxShapeLine(0, 0, new FlxPoint(10, 0), new FlxPoint(0, 10), {thickness: 2, color: FlxColor.RED});

		if (player == null)
		{
			this.active = false;
		}
		else
		{
			checkTimer = new FlxTimer();
			checkTimer.start(wait + 0.01, setStart, 1);
			FlxG.state.add(lineSprite1);
			FlxG.state.add(lineSprite2);
		}
	}

	function setStart(timer:FlxTimer):Void
	{
		checkTimer.destroy();
		checkTimer = new FlxTimer();
		checkTimer.start(2.5, checkLocation, 0);
	}

	function checkLocation(timer:FlxTimer):Void
	{
		player.getMidpoint().copyTo(currentAttackPoint);
		lineSprite1.setPosition(currentAttackPoint.x - 5, currentAttackPoint.y - 5);
		lineSprite2.setPosition(currentAttackPoint.x - 5, currentAttackPoint.y - 5);

		currentAttackPoint.copyTo(currentAttackDirection);
		var temp = getMidpoint();
		currentAttackDirection.subtractPoint(temp);
		var dx:Float = currentAttackDirection.x;
		var dy:Float = currentAttackDirection.y;
		var length:Float = FlxMath.vectorLength(dx, dy);
		currentAttackDirection.x = currentAttackDirection.x / length;
		currentAttackDirection.y = currentAttackDirection.y / length;
	}

	function updateMovement():Void
	{
		currentAttackDistance = getMidpoint().distanceTo(currentAttackPoint);

		if (currentAttackDistance > PAUSE_RANGE)
		{
			velocity.set(SPEED, 0);
			/* Some coordinate mixup */
			_angle = currentAttackPoint.angleBetween(getMidpoint()) + 90;
			velocity.rotate(FlxPoint.weak(0, 0), _angle);

			/* Debugging related */
			lineSpr.fill(FlxColor.TRANSPARENT);
			lineSpr.drawLine(getMidpoint().x, getMidpoint().y, currentAttackPoint.x, currentAttackPoint.y, lineStyle);
		}
	}

	override function update(elapsed:Float)
	{
		updateMovement();
		this.scale = FlxPoint.weak(0.9 + (0.1 * Math.cos(Timer.stamp())), 0.9 + (0.1 * Math.sin(Timer.stamp())));
		super.update(elapsed);
	}
}
