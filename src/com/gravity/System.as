package com.gravity
{
	
	
	import com.gravity.constants.ScreenOrientation;
	import com.gravity.constants.BoardConstants;
	import com.gravity.events.SystemEvents;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import com.gravity.engine.World;
	import com.gravity.constants.BodyConstants;
	import com.gravity.utils.Body;
	
	/**
	 * ...
	 * @author Shawn Fiske
	 */
	public class System extends World
	{
		private var viewWidth:Number = 0;
		private var viewHeight:Number = 0;
		
		private var friction:Number = 0.1;
		
		private var _boardStyle:String = BoardConstants.BOUNCE_BOARDER;
		
		private var _orientation:int = 0;
		
		public function System(_width:Number, _height:Number) 
		{
			this.worldWidth = _width;
			this.worldHeight = _height;
			viewWidth = _width
			viewHeight = _height
			trace("set origin",_width / 2, _height / 2);
			origin(_width / 2, _height / 2);
		}
		
		public function genGravityBody(sprite:Sprite, bodyX:Number, bodyY:Number, bodyRadius:int, gravity:Number, bodyType:int = BodyConstants.GRAVATATIONAL_NON_MOVING_DESTROYER, callback:Function = null):void
		{
			var simBody:Body = new Body(bodyX, bodyY);
			
			simBody.radius = bodyRadius;
			simBody.gravity = gravity;
			simBody.bodyType = bodyType;
			
			
			trace("genGravityBody", bodyType);
	
			if (bodyType == BodyConstants.GRAVATATIONAL_NON_MOVING_TARGET)
			{
				simBody.stationary = true;
				if (sprite == null) {
					circle(simBody, bodyRadius, this.C_FIXED, "", callback);
				}else {
					addShape(simBody, bodyRadius, sprite as Sprite, callback);
				}
				
			}
			
			if (bodyType == BodyConstants.NON_GRAVATATIONAL_MOVING_INTERACTIVE)
			{
				simBody.stationary = false;
				simBody.vx = 0.3;
				simBody.vy = 0.3;
				
				if (sprite == null) {
					circle(simBody, bodyRadius, this.C_FIXED, "", callback);
				}else {
					addShape(simBody, bodyRadius, sprite as Sprite, callback);
				}
			
			}
			
			if (bodyType == BodyConstants.GRAVATATIONAL_MOVING_TARGET)
			{
				simBody.stationary = false;
				simBody.vx = 0.3;
				simBody.vy = 0.3;
				
				if (sprite == null) {
					circle(simBody, bodyRadius, this.C_FIXED, "", callback);
				}else {
					addShape(simBody, bodyRadius, sprite as Sprite, callback);
				}
			
			}
			
			if (bodyType == BodyConstants.GRAVATATIONAL_NON_MOVING_DESTROYER)
			{
				simBody.stationary = true;
				if (gravity > 0)
				{
					if (sprite == null) {
						circle(simBody, bodyRadius, this.C_FIXED, "", callback);
					}else {
						addShape(simBody, bodyRadius, sprite as Sprite, callback);
					}
				}else{
					if (sprite == null) {
						circle(simBody, bodyRadius, this.C_FIXED, "", callback);
					}else {
						addShape(simBody, bodyRadius, sprite as Sprite, callback);
					}
				}
			}
			
			if (bodyType == BodyConstants.GRAVATATIONAL_MOVING_DESTROYER)
			{
				simBody.stationary = false;
				simBody.vx = 0.3;
				simBody.vy = 0.3;
				
				if (gravity > 0)
				{
					if (sprite == null) {
						circle(simBody, bodyRadius, this.C_FIXED, "", callback);
					}else {
						addShape(simBody, bodyRadius, sprite as Sprite, callback);
					}
				}else{
					if (sprite == null) {
						circle(simBody, bodyRadius, this.C_FIXED, "", callback);
					}else {
						addShape(simBody, bodyRadius, sprite as Sprite, callback);
					}
				}
			}
			
			if (bodyType == BodyConstants.NON_GRAVATATIONAL_NON_MOVING_INTERACTIVE)
			{
				
				if (_orientation == ScreenOrientation.VERTICAL_ORIENTATION)
				{
					//this.dragTarget.x = 0;
					//this.dragTarget.y = shipStation.y + 40;
				}else {
					//this.dragTarget.x = shipStation.x + 40;
					//this.dragTarget.y = 0;
				}
				
				if (sprite == null) {
					circle(simBody, bodyRadius, this.C_FIXED, "", callback);
				}else {
					addShape(simBody, bodyRadius, sprite as Sprite, callback);
				}
			}
			
		}
		
		public function genObjectBody(sprite:Sprite, bodyX:Number, bodyY:Number, bodyVX:Number, bodyVY:Number, bodyRadius:int, callback:Function = null):void
		{
			var simBody:Body = new Body(bodyX, bodyY);
			simBody.radius = bodyRadius;
			simBody.vx = bodyVX;
			simBody.vy = bodyVY;
			simBody.bodyType = BodyConstants.NON_GRAVATATIONAL_MOVING_OBJECT;
			simBody.friction = 0//1.5;
			
			if (sprite == null) {
				circle(simBody, 3, this.C_MOVABLE, "", callback);
			}else {
				addShape(simBody, bodyRadius, sprite, callback);
			}
		}
		
		override protected function step():void 
		{		
			for (var i:int = 0; i < this.gravityBodies.length; ++i)
			{
				
				if (gravityBodies[i].obj.bodyType == BodyConstants.GRAVATATIONAL_MOVING_DESTROYER)
				{
					gravityBodies[i].obj.x += gravityBodies[i].obj.vx;
					gravityBodies[i].obj.y += gravityBodies[i].obj.vy;
					
				}
				
				if (gravityBodies[i].obj.bodyType == BodyConstants.NON_GRAVATATIONAL_MOVING_OBJECT)
				{
					gravityBodies[i].obj.x += gravityBodies[i].obj.vx;
					gravityBodies[i].obj.y += gravityBodies[i].obj.vy;
				}
				
				if (gravityBodies[i].obj.bodyType == BodyConstants.NON_GRAVATATIONAL_MOVING_INTERACTIVE)
				{
					gravityBodies[i].obj.x += gravityBodies[i].obj.vx;
					gravityBodies[i].obj.y += gravityBodies[i].obj.vy;
				}
				
				if (gravityBodies[i].obj.bodyType == BodyConstants.GRAVATATIONAL_MOVING_DESTROYER || gravityBodies[i].obj.bodyType == BodyConstants.NON_GRAVATATIONAL_MOVING_INTERACTIVE)
				{
					gravityBodies[i].sprite.rotation -= 1;
					
					//warp at boarders
					if(gravityBodies[i].obj.x > (viewWidth/2) + (gravityBodies[i].obj.radius))
					{
						gravityBodies[i].obj.x = -(viewWidth / 2) - (gravityBodies[i].obj.radius);
					}
					else if (gravityBodies[i].obj.x < -(viewWidth/2) - (gravityBodies[i].obj.radius))
					{
						gravityBodies[i].obj.x = (viewWidth/2) + (gravityBodies[i].obj.radius);
					}
					else if(gravityBodies[i].obj.y  > (viewHeight/2) + (gravityBodies[i].obj.radius))
					{
						gravityBodies[i].obj.y  = -(viewHeight/2) - (gravityBodies[i].obj.radius);
					}
					else if (gravityBodies[i].obj.y  < -(viewHeight/2) - (gravityBodies[i].obj.radius))
					{
						gravityBodies[i].obj.y  = (viewHeight/2) + (gravityBodies[i].obj.radius);
					}
				}
					
				for (var j:int = 0; j < this.moveingBodies.length; ++j)
				{
					var point1:Point = new Point(gravityBodies[i].obj.x, gravityBodies[i].obj.y);
					var point2:Point = new Point(moveingBodies[j].obj.x, moveingBodies[j].obj.y);
					
					var dist:Number = Point.distance(point1, point2);
					
					if (boardStyle == BoardConstants.BOUNCE_BOARDER)
					{
						checkBounceBoarders();
					}
					
					if (boardStyle == BoardConstants.WARP_BOARDER)
					{
						checkWarpBoarders();
					}
					
					if (boardStyle == BoardConstants.FREE_BOARDER)
					{
						checkFreeBoarders();
					}
					
					//trace(String(gravityBodies[i].obj.radius + moveingBodies[j].obj.radius));
					
					if (dist >= gravityBodies[i].obj.radius + moveingBodies[j].obj.radius) 
					{
						//moving main object
						if (gravityBodies[i].obj.gravity != 0)
						{
							moveingBodies[j].obj.vx += (gravityBodies[i].obj.x - moveingBodies[j].obj.x) / Math.pow(dist, 2) * (gravityBodies[i].obj.gravity);
							moveingBodies[j].obj.vy += (gravityBodies[i].obj.y - moveingBodies[j].obj.y) / Math.pow(dist, 2) * (gravityBodies[i].obj.gravity);
							//trace("gravity:", i, j, moveingBodies[j].obj.vx, moveingBodies[j].obj.vy);
							moveingBodies[j].obj.x += moveingBodies[j].obj.vx;
							moveingBodies[j].obj.y += moveingBodies[j].obj.vy;
							moveingBodies[j].sprite.rotation = FindAngle(point2, new Point(moveingBodies[j].obj.x, moveingBodies[j].obj.y));
						}
					} else {
						
						
						if (gravityBodies[i].obj.bodyType == BodyConstants.HINDER_OBJECT_MOVEMENT)
						{
							moveingBodies[j].obj.vx = moveingBodies[j].obj.vy = 0;
							if(moveingBodies[j].obj.callback != null){
								moveingBodies[j].obj.callback(BodyConstants.HINDER_OBJECT_MOVEMENT);
							}
							break;
						}
						
						if (gravityBodies[i].obj.bodyType == BodyConstants.GRAVATATIONAL_NON_MOVING_DESTROYER)
						{
							if (moveingBodies[j].obj.callback != null) {
								trace("check hits");
								moveingBodies[j].obj.callback(BodyConstants.GRAVATATIONAL_NON_MOVING_DESTROYER);
							}
							break;
						}
						
						if (gravityBodies[i].obj.bodyType == BodyConstants.GRAVATATIONAL_NON_MOVING_TARGET)
						{
							if (moveingBodies[j].obj.callback != null) {
								trace("check hits");
								moveingBodies[j].obj.callback(BodyConstants.GRAVATATIONAL_NON_MOVING_TARGET);
							}
						}
						
						if (gravityBodies[i].obj.bodyType == BodyConstants.GRAVATATIONAL_MOVING_DESTROYER)
						{
							if(moveingBodies[j].obj.callback != null){
								moveingBodies[j].obj.callback(BodyConstants.GRAVATATIONAL_MOVING_DESTROYER);
							}
							break;
						}
						
						//if (gravityBodies[i].obj.bodyType == BodyConstants.NON_GRAVATATIONAL_NON_MOVING_INTERACTIVE)
						//{
						//}
						//
						//if (gravityBodies[i].obj.bodyType == BodyConstants.NON_GRAVATATIONAL_MOVING_INTERACTIVE)
						//{
						//}
					}
				}
			}
		}
		
		private function checkFreeBoarders():void 
		{
			//for (var j:int = 0; j < this.moveingBodies.length; ++j)
			//{
			//}
		}
		
		private function checkBounceBoarders():void
		{
			for (var j:int = 0; j < this.moveingBodies.length; ++j)
			{
				// Check if we hit top
				if ((moveingBodies[j].obj.x - moveingBodies[j].obj.radius / 2) <= -(viewWidth/2) && (moveingBodies[j].obj.vx < 0)) 			
				{ 				
					moveingBodies[j].obj.vx = -moveingBodies[j].obj.vx; 			
				}
				
				// Check if we hit bottom 			
				if ((moveingBodies[j].obj.x + moveingBodies[j].obj.radius / 2) >= (viewWidth/2) && (moveingBodies[j].obj.vx > 0))
				{
					moveingBodies[j].obj.vx = -moveingBodies[j].obj.vx;
				}
				
				// Check Y
				// Check if we hit left side
				if ((moveingBodies[j].obj.y - moveingBodies[j].obj.radius / 2) <= -(viewHeight/2) && (moveingBodies[j].obj.vy < 0)) 			
				{ 				
					moveingBodies[j].obj.vy = -moveingBodies[j].obj.vy		
				}
				
				//Check if we hit right side 			
				if ((moveingBodies[j].obj.y + moveingBodies[j].obj.radius / 2) >= (viewHeight/2) && (moveingBodies[j].obj.vy > 0))
				{
					moveingBodies[j].obj.vy = -moveingBodies[j].obj.vy;
				}
			}
		}
		
		private function checkWarpBoarders():void
		{
			for (var j:int = 0; j < this.moveingBodies.length; ++j)
			{
				if(moveingBodies[j].obj.x > (viewWidth/2) + ( moveingBodies[j].obj.radius))
				{
					moveingBodies[j].obj.x = -(viewWidth / 2) - (moveingBodies[j].obj.radius);
				}
				else if (moveingBodies[j].obj.x < -(viewWidth/2) - (moveingBodies[j].obj.radius))
				{
					moveingBodies[j].obj.x = (viewWidth/2) + (moveingBodies[j].obj.radius);
				}
				else if(moveingBodies[j].obj.y  > (viewHeight/2) + (moveingBodies[j].obj.radius))
				{
					moveingBodies[j].obj.y  = -(viewHeight/2) - (moveingBodies[j].obj.radius);
				}
				else if (moveingBodies[j].obj.y  < -(viewHeight/2) - (moveingBodies[j].obj.radius))
				{
					moveingBodies[j].obj.y  = (viewHeight/2) + (moveingBodies[j].obj.radius);
				}
			}
		}
		
		private function destroySystem():void
		{
			destroyWorld();
		}
		
		public static function FindAngle(point1:Point, point2:Point):Number
		{
			var dx:Number = point2.x - point1.x;
			var dy:Number = point2.y - point1.y;
			return -Math.atan2(dx, dy)* 180 / Math.PI;
		}
		
		public function get boardStyle():String 
		{
			return _boardStyle;
		}
		
		public function set boardStyle(value:String):void 
		{
			_boardStyle = value;
		}
		
		public function set orientation(value:int):void 
		{
			_orientation = value;
		}
	}
}