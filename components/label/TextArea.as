package components.label
{
	import flash.events.Event;
	
	import components.scrollBar.HScrollBar;
	import components.scrollBar.VScrollBar;
	
	import events.UIEvent;

	/**
	 *  文本域
	 *  @author JiaWei
	 */	
	public class TextArea extends TextInput
	{
		protected var _vScrollBar:VScrollBar;
		protected var _hScrollBar:HScrollBar;
		
		public function TextArea(text:String="")
		{
			super(text);
		}
		
		override protected function init():void
		{
			super.init();
			this.width = 180;
			this.height = 150;
			_textField.wordWrap = true;
			_textField.multiline = true;
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			_textField.addEventListener(Event.SCROLL,onTextFieldScroll);
		}
		
		protected function onTextFieldScroll(e:Event):void
		{
			changeScroll();
			sendEvent(UIEvent.SCROLL);
		}		
		
		private function changeScroll():void
		{
			var vShow:Boolean = _vScrollBar && _textField.maxScrollV > 1;
			var hShow:Boolean = _hScrollBar && _textField.maxScrollH > 1;
			var showWidth:Number = vShow ? _width - (_vScrollBar == null ? 0 : _vScrollBar.width) : _width;
			var showHeight:Number = hShow ? _height - (_hScrollBar == null ? 0 : _hScrollBar.height) : _height;
			
			_textField.width = showWidth - _margin[0] - _margin[2];
			_textField.height = showHeight - _margin[1] - margin[3];
			
			if(_vScrollBar){
				_vScrollBar.x = _width - vScrollBar.width - _margin[2];
				_vScrollBar.y = _margin[1];
				_vScrollBar.height = _height - (hShow ? _hScrollBar.height : 0) - _margin[1] - _margin[3];
				_vScrollBar.height = 1;
				_vScrollBar.scrollSize = 1;
				_vScrollBar.thumbPercent = (_textField.numLines - _textField.maxScrollV + 1 ) / _textField.numLines;
				_vScrollBar.setScroll(1,_textField.maxScrollV,_textField.scrollV);
			}
			
			if(_hScrollBar){
				_hScrollBar.x = _margin[0];
				_hScrollBar.y = _height - hScrollBar.height - _margin[3];
				_hScrollBar.width = _width - (vShow ? _vScrollBar.width : 0) - _margin[0] - _margin[2];
				_hScrollBar.scrollSize = Math.max(showWidth * 0.33,1);
				_hScrollBar.thumbPercent = showWidth / Math.max(_textField.textWidth,showWidth);
				_hScrollBar.setScroll(0,_textField.maxScrollH,_textField.scrollH);
			}
		}

		/**垂直滚动条实体*/
		public function get vScrollBar():VScrollBar
		{
			return _vScrollBar;
		}

		public function set vScrollBar(value:VScrollBar):void
		{
			if(value != null){
				if(_vScrollBar == null){
					_vScrollBar = value;
					addChild(_vScrollBar);
					_vScrollBar.addEventListener(Event.CHANGE,onScrollBarChange);
					_vScrollBar.target = _textField;
				}
				_vScrollBar = value;
				changeScroll();	
			}
		}
		
		/**水平滚动条实体*/
		public function get hScrollBar():HScrollBar
		{
			return _hScrollBar;
		}

		public function set hScrollBar(value:HScrollBar):void
		{
			if(value != null){
				if(_hScrollBar == null){
					_hScrollBar = value;
					addChild(_hScrollBar);
					_hScrollBar.addEventListener(Event.CHANGE,onScrollBarChange);
					_hScrollBar.target = _textField;
				}
				_hScrollBar = value;
				changeScroll();	
			}
		}
		
		protected function onScrollBarChange(e:Event):void
		{
			if(e.currentTarget == _vScrollBar){
				if(_textField.scrollV != _vScrollBar.value){
					_textField.removeEventListener(Event.SCROLL,onTextFieldScroll);
					_textField.scrollV = _vScrollBar.value;
					_textField.addEventListener(Event.SCROLL,onTextFieldScroll);
					sendEvent(UIEvent.SCROLL);
				}
			}else{
				if(_textField.scrollH != _hScrollBar.value){
					_textField.removeEventListener(Event.SCROLL,onTextFieldScroll);
					_textField.scrollH = _hScrollBar.value;
					_textField.addEventListener(Event.SCROLL,onTextFieldScroll);
					sendEvent(UIEvent.SCROLL);
				}
			}
		}
		
		/**垂直滚动最大值*/
		public function get maxScrollV():int{
			return _textField.maxScrollV;
		}
		
		/**水平滚动最大值*/
		public function get maxScrollH():int{
			return _textField.maxScrollH;
		}
		
		/**垂直滚动值*/
		public function get scrollV():int{
			return _textField.scrollV;
		}
		
		/**水平滚动值*/
		public function get scrllH():int{
			return _textField.scrollH;
		}
		
		/**
		 *   滚动到某个位置
		 * @param line 行数
		 */
		public function scrollTo(line:int):void{
			_textField.scrollV = line;
			changeText();
			changeSize();
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			changeScroll();
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			changeScroll();
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_textField.removeEventListener(Event.SCROLL,onTextFieldScroll);
			if(_vScrollBar)
				_vScrollBar.removeEventListener(Event.CHANGE,onScrollBarChange);
			if(_hScrollBar)
				_hScrollBar.removeEventListener(Event.CHANGE,onScrollBarChange);
		}
		
		override public function destory():void
		{
			super.destory();
			if(_vScrollBar){
				_vScrollBar.destory();
				_vScrollBar = null;
			}
			if(_hScrollBar){
				_vScrollBar.destory();
				_vScrollBar = null;
			}
		}
		
	}
}