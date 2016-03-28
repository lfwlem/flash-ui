package components
{
	import flash.events.Event;

	/**
	 *	图片基类
	 *  @author JiaWei
	 */	
	public class BaseImage extends BaseSprite
	{
		protected var _content:BaseBitmap;//内容
		protected var _autoSize:Boolean = true;//是否在内容加载完成后自动调整尺寸
		
		public function BaseImage()
		{
			super();
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			_autoSize = false;
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			_autoSize = false;
		}
		
		override public function setSize(width:Number, height:Number):void
		{
			super.setSize(width, height);
			_uiWidth = width;
			_uiHeight = height;
			_autoSize = false;
		}

		/**
		 * 组件内容访问器
		 * @return 
		 */
		public function get content():BaseBitmap
		{
			return _content;
		}

		public function set content(value:BaseBitmap):void
		{
			if(_content != value){
				removeContent();
				_content = value;
				if(value){
					listenEventOfContent();
					this.addChild(value);
					updateContent();
				}
			}
		}
		
		/**
		 * 移除内容
		 */
		protected function removeContent():void{
			if(_content){
				if(this.contains(_content)){
					this.removeChild(_content);
				}
				_content.removeEventListener(Event.CHANGE,onContentChange);
				_content.destory();
				_content = null;
			}
		}
		
		/**
		 * 侦听内容事件
		 */	
		protected function listenEventOfContent():void{
			if(_content && _content is BaseBitmap){
				if(!(_content as BaseBitmap).bitmapData){
					_content.addEventListener(Event.CHANGE,onContentChange);
				}
			}
		}
		
		/**
		 * 处理内容变更
		 * @param e
		 */	
		protected function onContentChange(e:Event):void{
			_content.removeEventListener(Event.CHANGE,onContentChange);
			updateContent();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 更新内容
		 */		
		protected function updateContent():void
		{
			if(_autoSize){
				setSize(_content.width, _content.height);	
			}else{
				_content.width = _width;
				_content.height = _height;
			}
		}
		
		/**是否对位图进行平滑处理*/
		public function get smoothing():Boolean {
			return _content.smoothing;
		}
		
		public function set smoothing(value:Boolean):void {
			_content.smoothing = value;
		}
		
		/**九宫格信息，格式：左边距,上边距,右边距,下边距,是否重复填充(值为0或1)，例如：4,4,4,4,1*/
		public function get sizeGrid():String{
			return _content.sizeGrid.join(",");
		}
		
		public function set sizeGrid(value:String):void{
			_content.sizeGrid = value.split(",");
		}
		
		public function get url():String{
			return _content.url;
		}
		
		override public function destory():void
		{
			removeContent();
			super.destory();
		}
		
		
	}
}