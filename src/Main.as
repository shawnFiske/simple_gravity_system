package 
{
	import com.gravity.events.SystemEvents;
	import com.utils.VirtualGridConstants;
	import flash.desktop.NativeApplication;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import com.gravity.constants.BoardConstants;
	import com.gravity.constants.BodyConstants;
	import com.gravity.constants.ScreenOrientation;
	import com.gravity.System;
	
	import com.utils.VirtualGrid;
	//import com.utils.GenerateNebula;
	/**
	 * ...
	 * @author Shawn Fiske
	 */
	public class Main extends Sprite 
	{
		private var newSystem:System;
		private var orientation:int = 0;
		private var resizeFired:Boolean = false;
		
		private var grid:VirtualGrid;
		
		private var rocketBooster:Number = 5;
		//private var nebula:GenerateNebula;
		
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			//stage.addEventListener(Event.RESIZE, screenResize);
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// entry point
			buildUI(stage.stageWidth, stage.stageHeight)
		}
		
		private function screenResize(e:Event):void 
		{
			trace("screenResize", stage.stageWidth, stage.stageHeight);
			if (resizeFired)
			{
	
				
				if (stage.stageWidth - stage.stageHeight > 1)
				{
					//var landRect:Rectangle = new Rectangle(10, 10, stage.stageWidth - 10, stage.stageWidth-10);
					//drawRect(screenView, 10, 10, stage.stageWidth - 20, stage.stageWidth - 20);
					orientation = ScreenOrientation.HORAZONTAL_ORIENTATION;
				}else {
	
					//var portRect:Rectangle = new Rectangle(10, 10, stage.stageHeight - 10, stage.stageHeight - 10);
					//drawRect(screenView, 10, 10, stage.stageHeight - 20, stage.stageHeight - 20);
					orientation = ScreenOrientation.VERTICAL_ORIENTATION;
				}
			}
			
			resizeFired = true;
		}
		
		
		private function buildGame():void 
		{
			trace("buildGame", stage.stageWidth, stage.stageHeight);
			grid = new VirtualGrid(stage, VirtualGridConstants.CENTER_GRID);
			newSystem = new System(stage.stageWidth, stage.stageHeight);
			newSystem.boardStyle = BoardConstants.BOUNCE_BOARDER;
			
			//addChildAt(newSystem, 1);
			
			if (stage.stageWidth - stage.stageHeight > 1)
			{
				orientation = ScreenOrientation.HORAZONTAL_ORIENTATION;
				newSystem.orientation = ScreenOrientation.HORAZONTAL_ORIENTATION;
			}else {
				
				orientation = ScreenOrientation.VERTICAL_ORIENTATION;
				newSystem.orientation = ScreenOrientation.VERTICAL_ORIENTATION;
			}
			
			addChild(newSystem);
		}
		
		private function buildField():void 
		{
			grid.clearNodeList();
			
			var point:Point
			
			//stationary gravatational objects
			point = grid.getRandPoint(80);
			newSystem.genGravityBody(null, point.x, point.y, 10, 1, BodyConstants.GRAVATATIONAL_NON_MOVING_DESTROYER);
			point = grid.getRandPoint(80);
			newSystem.genGravityBody(null, point.x, point.y, 10, 1, BodyConstants.GRAVATATIONAL_NON_MOVING_DESTROYER);
			point = grid.getRandPoint(80);
			newSystem.genGravityBody(null, point.x, point.y, 10, 1, BodyConstants.GRAVATATIONAL_NON_MOVING_DESTROYER);
			
			
			//stationary gravatational objects
			point = grid.getRandPoint(60);
			newSystem.genGravityBody(null, point.x, point.y, 10, -1, BodyConstants.GRAVATATIONAL_NON_MOVING_TARGET);
			point = grid.getRandPoint(60);
			newSystem.genGravityBody(null, point.x, point.y, 10, -1.5, BodyConstants.GRAVATATIONAL_MOVING_DESTROYER);
			
			//object influenced by gravity
			point = grid.getRandPoint(60);
			newSystem.genObjectBody(null,  point.x ,  point.y, 0, 0, 5, trackHit);
			point = grid.getRandPoint(60);
			newSystem.genObjectBody(null,  point.x ,  point.y, 0, 0, 5, trackHit);
			point = grid.getRandPoint(60);
			newSystem.genObjectBody(null,  point.x ,  point.y, 0, 0, 5, trackHit);
			point = grid.getRandPoint(60);
			newSystem.genObjectBody(null,  point.x ,  point.y, 0, 0, 5, trackHit);
			point = grid.getRandPoint(60);
			newSystem.genObjectBody(null,  point.x ,  point.y, 0, 0, 5, trackHit);
			
		}
		
		private function trackHit(str:String):void {
			trace("Hit: ", str);
		}
		
		private function endGame():void
		{
			//End game code here
		}
		
		private function buildUI(_width:Number, _height:Number):void
		{
			trace("buildUI");
			buildGame();
			buildField();
		}
		
		public static function FindAngle(point1:Point, point2:Point):Number
		{
			var dx:Number = point2.x - point1.x;
			var dy:Number = point2.y - point1.y;
			//return -Math.atan2(dx, dy) * 180 / Math.PI;
			var range:Number = (Math.PI / -Math.atan2(dx, dy));
			
			if (range < 0)
			{
				range = (range + 1) * 10;
				
				
			}else {
				range = (range - 1) * 10;
			}
			
			return -range;
		}
		
		public static function FindDistance(firstPoint:Point, secondPoint:Point):Number
		{
			var dist:Number = (Point.distance(firstPoint, secondPoint) / 2) / 100;
			return -dist;
		}
		
		private function drawRect(tar:Sprite, tarX:int, tarY:int, tarWidth:Number, tarHeight:Number):void
		{
			tar.graphics.lineStyle(0,0x00ff00);
			tar.graphics.beginFill(0x0000FF);
			tar.graphics.drawRect(tarX, tarY, tarWidth, tarHeight);
			tar.graphics.endFill();
		}
		
		private function deactivate(e:Event):void 
		{
			// auto-close
			NativeApplication.nativeApplication.exit();
		}
		
	}
	
}