package events
{
	import flash.events.Event;
	
	/**
	 *  UI事件类
	 *  @author JiaWei
	 */	
	public class UIEvent extends Event
	{
		/**移动组件*/
		public static const MOVE:String = "move";
		/**显示鼠标提示*/
		public static const SHOW_TIP:String = "showTip";
		/**隐藏鼠标提示*/
		public static const HIDE_TIP:String = "hideTip";
		//-----------------Image-----------------
		/**图片加载完毕*/
		public static const IMAGE_LOADED:String = "imageLoaded";
		//-----------------TextArea-----------------
		/**滚动*/
		public static const SCROLL:String = "scroll";
		//-----------------FrameClip-----------------
		/**帧跳动*/
		public static const FRAME_CHANGED:String = "frameChanged";
		//-----------------List-----------------
		/**项渲染*/
		public static const ITEM_RENDER:String = "listRender";
		
		private var _data:*;
		
		public function UIEvent(type:String, data:*,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		override public function clone():Event
		{
			return new UIEvent(type,_data,bubbles,cancelable);
		}

		public function get data():*
		{
			return _data;
		}

		public function set data(value:*):void
		{
			_data = value;
		}
		
		
	}
}