package com.gravity.engine 
{
	import com.gravity.constants.BodyConstants;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Graphics;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat
	
	import com.gravity.utils.Body;
	
	/**
	 * ...
	 * @author Shawn Fiske
	 */
	public class World extends Sprite
	{
		private var canvas:Sprite;
		public var dragTarget:MovieClip = null;
		private var gCanvas:Sprite;

		public var gravityBodies:Array;
		public var moveingBodies:Array;
		
		public var shapeList:Array;
		private var pathList:Array;
		private var lineList:Array;
		private var handleList:Array;
		
		private var left:Number, right:Number, top:Number, bottom:Number;

		protected const C_MOVABLE:uint = 0xFF6600;
		protected const C_DRAGGABLE:uint = 0x0066FF;
		protected const C_FIXED:uint = 0xFFFFFF;
		protected const C_GUIDE:uint = 0xAAAAAA;
		
		private var _worldWidth:Number = 0;
		private var _worldHeight:Number = 0;
		
		private var _targetX:Number = 0;
		private var _targetY:Number = 0;
		
		private var controlIsSet:Boolean = false;
		
		public function World() 
		{
			buildWorld();
			origin(0,0);
		}
		
		public function buildWorld():void
		{
			
			
			gravityBodies = new Array();
			moveingBodies = new Array();

			pathList = new Array();
			lineList = new Array();
			shapeList = new Array();
			handleList = new Array();
			
			//gCanvas.graphics.lineStyle(0, C_GUIDE, 0.5);
			
			addChild(canvas = new Sprite());
			
			addEventListener(Event.ENTER_FRAME, process);
		}
		
		public function destroyWorld():void
		{
			removeEventListener(Event.ENTER_FRAME, process);
			
			trace("canvas count: a", canvas.numChildren, gravityBodies.length);
			for (var g:int = 0; g < gravityBodies.length; ++g )
			{
				canvas.removeChild(gravityBodies[g].sprite);
			}
			
			trace("canvas count: b", canvas.numChildren, moveingBodies.length);
			
			for (var m:int = 0; m < moveingBodies.length; ++m )
			{
				canvas.removeChild(moveingBodies[m].sprite);
			}
			
			trace("canvas count: c", canvas.numChildren);
			
			gravityBodies = [];
			moveingBodies =[];

			pathList = [];
			lineList = [];
			shapeList = [];
			handleList = [];

			removeChild(gCanvas);
			removeChild(canvas);
			//removeChild(tCanvas);
			//removeChild(textout);
			
		}
		
		public function killProcess():void
		{
			removeEventListener(Event.ENTER_FRAME, process);
		}
		
		protected function process(evt:Event):void 
		{
			step();
			updateGraphics();
		}

		protected function step():void {}
		
		private function updateDrag(e:MouseEvent):void 
		{
			
			if (e.type == "mouseUp")
			{
				_targetX = e.stageX;
				_targetY = e.stageY;
			}
		}
		
		private function updateGraphics():void 
		{
			var g:Graphics = canvas.graphics;
			var item:Object;
			
			for (var i:uint = 0; i < shapeList.length; i ++) 
			{
				item = shapeList[i];
				item.sprite.x = item.obj.x;
				item.sprite.y = item.obj.y;
			}
		}
		
		/*
		* origin
		*/
		protected function origin(x:Number, y:Number):void 
		{
			canvas.x = x//gCanvas.x = canvas.x = x;
			canvas.y = y//gCanvas.y = canvas.y = y;
			left = x - _worldWidth;
			right = _worldWidth - x;
			top = y - _worldHeight;
			bottom = _worldHeight - y;
		}
		
		 /*
		* guide
		*/
		protected function guide(x1:Number, y1:Number, x2:Number, y2:Number):void 
		{
			var g:Graphics = gCanvas.graphics;
			g.moveTo(x1,y1);
			g.lineTo(x2,y2);
		}
		
		protected function guideLabel(x:Number, y:Number, str:String):void 
		{
			var t:TextField = label(str, C_GUIDE);
			t.x = x;
			t.y = y;
			gCanvas.addChild(t);
		}
		
		/*
		* graphic items
		*/
		
		public function circle(obj:Body, radius:Number = 3, col:uint = C_FIXED, labelStr:String = "", cb:Function = null):void 
		{
			var s:Sprite = new Sprite();
			s.graphics.beginFill(col, 0.5);
			s.graphics.drawCircle(0,0,radius);
			s.graphics.endFill();
			
			addShape(obj, radius ,s, cb);
		}
		
		public function addShape(obj:Body, radius:Number,s:Sprite = null, cb:Function = null):void 
		{
			var item:Object = { obj:obj, sprite:s, callback:cb };
			s.x = obj.x;
			s.y = obj.y;
			s.width = radius * 2;
			s.height = radius * 2;
			
			canvas.addChild(s as Sprite);
			
			if (obj.stationary)
			{
				trace("shape gravityBodies");
				gravityBodies.push(item);
				
			}
			else if (!obj.stationary && obj.bodyType == BodyConstants.NON_GRAVATATIONAL_MOVING_INTERACTIVE)
			{
				gravityBodies.push(item);
			}
			else if (!obj.stationary && obj.bodyType == BodyConstants.GRAVATATIONAL_MOVING_DESTROYER)
			{
				gravityBodies.push(item);
			}
			else
			{
				trace("shape moveingBodies",s.name);
				moveingBodies.push(item);
			}
			
			shapeList.push(item);
			
			//canvas.setChildIndex(dragTarget, canvas.numChildren-1);
			//return item
		}
		
		public function addElement(s:Sprite):void
		{
			canvas.addChild(s);
		}
		
		public function removeMovingBody():void
		{
			
		}
		
		public function removeGravityBody(index:int):void
		{
			for (var g:int = gravityBodies.length - 1; g > 0 ; --g )
			{
				if (g == index)
				{
					canvas.removeChild(gravityBodies[g].sprite);
					gravityBodies.splice(g, 1);
				}
			}
		}
		
		protected function path(obj1:Body, obj2:Body, col:uint = C_MOVABLE, w:Number = 0):Object 
		{
			var item:Object = {obj1:obj1,obj2:obj2,col:col,w:w};
			pathList.push(item);
			return item
		}

		protected function line(obj1:Body, obj2:Body, col:uint = C_MOVABLE, w:Number = 0):Object 
		{
			var item:Object = {obj1:obj1,obj2:obj2,col:col,w:w};
			lineList.push(item);
			return item
		}

		/*
		* text
		*/

		private function label(str:String, col:uint):TextField 
		{
			var t:TextField = new TextField();
			var tf:TextFormat = new TextFormat();
			t.autoSize = TextFieldAutoSize.LEFT;
			t.selectable = false;
			tf.font = "_sans";
			tf.color = col;
			t.defaultTextFormat = tf;
			t.text = str;
			return t;
		}

		private function getTextout():TextField 
		{
			var t:TextField = new TextField();
			var tf:TextFormat = new TextFormat();
			t.width = _worldWidth - 20;
			t.height = _worldHeight - 20;
			t.x = t.y = 10;
			t.multiline = true;
			t.autoSize = TextFieldAutoSize.LEFT;
			t.selectable = false;
			tf.font = "_sans";
			tf.color = C_GUIDE;
			t.defaultTextFormat = tf;
			return t;
		}

		protected function print(str:String):void 
		{
			//textout.appendText(str + "\n");
		}
		protected function clearText():void 
		{
			//textout.text = "";
		}
		/*
		* drag
		*/

		protected function enableDrag(...args):void 
		{
			var s:Sprite;
			var item:Object;
			
			for (var i:uint = 0; i < args.length; i ++) 
			{
				for (var j:uint = 0; j < shapeList.length; j ++) 
				{
					if (shapeList[j].obj == args[i]) 
					{ 
						s = shapeList[j].sprite;
						s.addEventListener(MouseEvent.MOUSE_DOWN, h_draggable_mouseDown);      
						s.addEventListener(MouseEvent.MOUSE_UP, h_draggable_mouseUp);
						s.useHandCursor = true;
						s.buttonMode = true;
						s.tabEnabled = false;
						item = {obj:args[i],sprite:s};
						handleList.push(item);
					}
				}
			}
		}


		private function h_draggable_rollOver(evt:Event):void 
		{
			evt.currentTarget.alpha = 0.5;
		}

		private function h_draggable_rollOut(evt:Event):void {
			
			evt.currentTarget.alpha = 1;
		}

		private function h_draggable_mouseDown(evt:Event):void 
		{
			//dragTarget = evt.currentTarget as Sprite;
		}

		private function h_draggable_mouseUp(evt:Event):void 
		{
			//dragTarget = null;
		}

		/*
		* util
		*/
		protected function radToDeg(n:Number):Number 
		{
			return n / Math.PI * 180;
		}
		
		protected function degToRad(n:Number):Number 
		{
			return n * Math.PI / 180;
		}
		
		protected function rd(n:Number):Number 
		{
			return Math.round(n * 100) / 100;
		}
		
		public function set worldWidth(value:Number):void 
		{
			_worldWidth = value;
		}
		
		public function set worldHeight(value:Number):void 
		{
			_worldHeight = value;
		}
		
		public function get targetX():Number 
		{
			return _targetX;
		}
		
		public function get targetY():Number 
		{
			return _targetY;
		}
	}
}