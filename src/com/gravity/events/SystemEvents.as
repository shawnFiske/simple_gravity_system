package com.gravity.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Shawn Fiske
	 */
	public class SystemEvents extends Event 
	{
		public var data:* = null;
		
		public function SystemEvents(type:String, bubbles:Boolean=false, cancelable:Boolean=false, eventData:* = null) 
		{ 
			super(type, bubbles, cancelable);
			data = eventData;
		} 
		
		public override function clone():Event 
		{ 
			return new SystemEvents(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SystemEvents", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}