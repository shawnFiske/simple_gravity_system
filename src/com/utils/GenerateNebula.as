package com.utils 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	
	import com.utils.VirtualGrid;
	/**
	 * ...
	 * @author ...
	 */
	public class GenerateNebula extends Sprite 
	{
		private var nebulas:Sprite = new Sprite();
		private var nebula:Shape;
		//private var nebulaHighLights:Shape;
		
		private var mathUtils:VirtualGrid
		private var _width:Number = 0;
		private var _height:Number = 0;
		
		private var nebulaSize:int = 3000;
		
		private var blur:BlurFilter;
		
		private var lineLength:int = 20;
		
		public function GenerateNebula(width:Number, height:Number) 
		{
			_width = width;
			_height = height;
			mathUtils = new VirtualGrid(width, height, VirtualGridConstants.CENTER_GRID);
			trace("GenerateNebula:", mathUtils.randRange(1, 100));
			
			blur =	new BlurFilter(8, 8, 8);
			
			buildNebula(0x800000, 0xFF0000); //dark red
			buildNebula(0x0000FF, 0x80FFFF); //dark blue
			buildNebula(0xFF80C0, 0xFFFFFF); //pink
			buildNebula(0x713800, 0xFFC9AE); //orange
			buildNebula(0x400080, 0xE1C4FF); //purple
			buildNebula(0x004000, 0x80FF80); //green
			
			addChild(nebulas);
		}
		
		private function buildNebula(color:uint, color2:uint):void
		{
			
			
			var cPosX:Number = mathUtils.randRange(_width , -(_width/2));
			var cPosY:Number = mathUtils.randRange(_height / 2 , -(_height / 2));
			
			trace("build nebula", cPosX, cPosY);
			
			nebula = new Shape(); 
			//nebulaHighLights = new Shape();
			 
			nebula.graphics.lineStyle(3, color, .30);
			nebula.graphics.moveTo(cPosX, cPosY); 
				
			//nebulaHighLights.graphics.lineStyle(1, color2, .30);
			//nebulaHighLights.graphics.moveTo(cPosX, cPosY); 
			
			for (var i:int = 0; i < nebulaSize; ++i )
			{
				// red triangle, starting at point 0, 0 
				cPosX += mathUtils.randRange(-lineLength , lineLength);
				cPosY += mathUtils.randRange(-lineLength , lineLength);
				//trace("line:", cPosX, cPosY);
				nebula.graphics.lineTo(cPosX, cPosY); 
				//nebulaHighLights.graphics.lineTo(cPosX, cPosY); 
			}
			
			nebula.filters = [blur];
			//nebulaHighLights.filters = [blur];
			
			nebulas.addChild(nebula);
			//nebulas.addChild(nebulaHighLights);
			
			dispatchEvent(new Event("FINISHED_NEBULA"));
		}
	}

}