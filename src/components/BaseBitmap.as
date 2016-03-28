package components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import utils.BitmapUtils;
	
	/**
	 *  增强的Bitmap类
	 *  @author JiaWei
	 */	
	public class BaseBitmap extends Bitmap
	{
		private var _url:String;
		private var _width:Number = Number.NaN;
		private var _height:Number = Number.NaN;
		private var _sizeGrid:Array;
		
		public function BaseBitmap()
		{
			super();
		}
		
		override public function set bitmapData(value:BitmapData):void
		{
			if(value){
				super.bitmapData = value;
				dispatchEvent(new Event(Event.CHANGE));
			}else{
				super.bitmapData = null;
			}
		}
		
		/**
		 * 克隆图像
		 * 因为一个图像资源可能在游戏中的多个地方使用
		 * @return 
		 * *****注意：被克隆的对象必须不是克隆出来的对象
		 */
		private function clone():BaseBitmap{
			var bmp:BaseBitmap = new BaseBitmap();
			if(bitmapData){
				bmp.bitmapData = bitmapData;
			}else{
				addEventListener(Event.CHANGE,bmp.sourceLoadComplete);
			}
			bmp.url = this.url;
			return bmp;
		}
		
		/**
		 *如果源图像的图片加载成功则会调用此事件通知，以便在克隆图像中设定图片 
		 * @param e
		 * 
		 */
		private function sourceLoadComplete(e: Event): void{
			var src:BaseBitmap = new BaseBitmap();
			src.removeEventListener(e.type, sourceLoadComplete);
			initBitmapData = src.bitmapData;
			src.url = this.url;
		}
		
		public function set initBitmapData(bmd:BitmapData):void
		{
			super.bitmapData = bmd;
		}
		
		public function destory():void{
			_sizeGrid = null;
			super.bitmapData = null;
			_url = null;
			_width = Number.NaN;
			_height = Number.NaN;
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}
		
		override public function get height():Number
		{
			return isNaN(_height) ? (super.bitmapData ? super.bitmapData.height : super.height) : _height;
		}
		
		override public function set height(value:Number):void
		{
			if(_height != value){
				_height = value;
				changeSize();
			}
		}
		
		override public function get width():Number
		{
			return isNaN(_width) ? (super.bitmapData ? super.bitmapData.width : super.width) : _width;
		}
		
		override public function set width(value:Number):void
		{
			if(_width != value){
				_width = value;
				changeSize();
			}
		}
		
		/**九宫格信息，格式：左边距,上边距,右边距,下边距,是否重复填充(值为0或1)，例如：4,4,4,4,1*/
		public function get sizeGrid():Array {
			return _sizeGrid;
		}
		
		public function set sizeGrid(value:Array):void {
			_sizeGrid = value;
			changeSize();
		}
		
		protected function changeSize():void{
			if(super.bitmapData){
				var w:int = Math.round(width);
				var h:int = Math.round(height);
				if(_sizeGrid){
					BitmapUtils.scale9Bmd(this.bitmapData,_sizeGrid,w,h);
				}
				super.width = w;
				super.height = h;
			}
		}
	}
}