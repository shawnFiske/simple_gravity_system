package com.utils 
{
	import flash.display.Sprite;
	import com.utils.VirtualGridConstants
	import com.utils.GridNode;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	/**
	 * ...
	 * @author Shawn Fiske
	 */
	public class VirtualGrid extends Sprite
	{
		private var left:Number = 0;
		private var right:Number = 0;
		private var top:Number = 0;
		private var bottom:Number = 0;
		
		private var originPoint:String = VirtualGridConstants.CENTER_GRID;
		
		private var currentNodes:Array;
		
		private var gridStage:Stage;
		
		public function VirtualGrid(stage:Stage, zero:String = VirtualGridConstants.CENTER_GRID) 
		{
			gridStage = stage;
			originPoint = zero;
			origin(stage.width, stage.height);
			
			currentNodes = new Array();
			
			trace("VirtualGrid:", stage.width, stage.height);
		}
		
		private function origin(_width:Number, _height:Number):void 
		{
			if (originPoint == VirtualGridConstants.CENTER_GRID)
			{
				left = (_width / 2) - _width;
				right = _width - (_width / 2);
				top = (_height / 2) - _height;
				bottom = _height - (_height / 2);
			}
			
			if (originPoint == VirtualGridConstants.CORN_GRID)
			{
				left = 0;
				right = _width;
				top = 0;
				bottom = _height;
			}
			
			trace(left, right, top, bottom);
		}
		
		private function drawRect(tar:Sprite, tarX:int, tarY:int, tarWidth:Number, tarHeight:Number):void
		{
			tar.graphics.lineStyle(0,0x00ff00);
			tar.graphics.beginFill(0x0000FF);
			tar.graphics.drawRect(tarX, tarY, tarWidth, tarHeight);
			tar.graphics.endFill();
		}
		
		public function getRandPoint(padding:int):Point
		{
			var i:int = 0
			
			var pX:Number = randRange(((gridStage.stageWidth / 2) - gridStage.stageWidth) + padding, (gridStage.stageWidth / 2) - padding);
			var pY:Number = randRange(((gridStage.stageHeight / 2) - gridStage.stageHeight) + padding, (gridStage.stageHeight / 2) - padding);
			var value:Point = new Point(pX, pY);
				
			if (currentNodes.length != 0)
			{
				for (i = 0; i < currentNodes.length; ++i)
				{
					
					var testPoint:Number = Point.distance(currentNodes[i], value);
					//trace("start test", testPoint, padding)
					if (testPoint < padding)
					{
						pX = randRange(((gridStage.stageWidth / 2) - gridStage.stageWidth) + padding, (gridStage.stageWidth / 2) - padding);
						pY = randRange(((gridStage.stageHeight / 2) - gridStage.stageHeight) + padding, (gridStage.stageHeight / 2) - padding);
						value = new Point(pX, pY);
						i = 0;
						//trace("Retested!!!!!!!!!!")
					}
					//trace("end test", i);
				}
			}
			
			currentNodes.push(value);
			
			return value;
		}
		
		public function getRandWidth(padding:int):Number
		{
			var value:Number = randRange(((gridStage.stageWidth / 2) - gridStage.stageWidth) + padding, (gridStage.stageWidth / 2) - padding);
			trace(value);
			return value;
		}
		
		public function getRandHeight(padding:int):Number
		{
			var value:Number = randRange(((gridStage.stageHeight / 2) - gridStage.stageHeight) + padding, (gridStage.stageHeight / 2) - padding);
			trace(value);
			return value;
		}
		
		public function checkDistance(point1:Point, point2:Point):Number
		{
			return Point.distance(point1, point2);
		}
		
		public function clearNodeList():void
		{
			currentNodes = new Array();
		}
		
		public function randRange(minNum:Number, maxNum:Number):Number 
        {
            return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
        }
		
		private function generateGrid(count:int, gridSize:int):void
		{
			
		}
		
		private function generateZone():void
		{
			
		}
	}

}