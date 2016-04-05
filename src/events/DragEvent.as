package events
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 *  拖动事件类
	 *  @author JiaWei
	 */	
	public class DragEvent extends Event
	{
		public static const DRAG_START:String = "drag_start";
		public static const DRAG_DROP:String = "drag_drop";
		public static const DRAG_COMPLETE:String = "drag_complete";
		
		protected var _data:Object;
		protected var _drapInitiator:DisplayObject;
		
		public function DragEvent(type:String, drapInitiator:DisplayObject=null, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_drapInitiator = drapInitiator;
			_data = data;
		}

		/**拖动传递的数据*/
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

		/**拖动的源对象*/
		public function get drapInitiator():DisplayObject
		{
			return _drapInitiator;
		}

		public function set drapInitiator(value:DisplayObject):void
		{
			_drapInitiator = value;
		}
		
		override public function clone():Event
		{
			return new DragEvent(type,_drapInitiator,_data,bubbles,cancelable);
		}
		

	}
}