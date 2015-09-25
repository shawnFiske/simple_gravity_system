package com.gravity.utils 
{
	/**
	 * ...
	 * @author Shawn Fiske
	 */
	import flash.geom.Point;
	
	public dynamic class Body extends Point 
	{
		
		private var _gravity:Number = 0;
		private var _stationary:Boolean = false;
		private var _friction:Number = 0;
		private var _bodyType:int = 0;
		
		public function Body(x:Number, y:Number):void 
		{
			super(x,y);
		}
		
		public function get gravity():Number { return _gravity; }
		
		public function set gravity(value:Number):void 
		{
			_gravity = value;
		}
		
		public function get stationary():Boolean { return _stationary; }
		
		public function set stationary(value:Boolean):void 
		{
			_stationary = value;
		}
		
		public function get friction():Number { return _friction; }
		
		public function set friction(value:Number):void 
		{
			_friction = value;
		}
		
		public function get bodyType():int { return _bodyType; }
		
		public function set bodyType(value:int):void 
		{
			_bodyType = value;
		}
		
	}

}