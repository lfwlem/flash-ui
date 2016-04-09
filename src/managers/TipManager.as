package managers
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import components.BaseBitmap;
	import components.BaseImage;
	import components.BaseLabel;
	import components.BaseSprite;
	
	import configs.AppConfig;
	import configs.UIConfig;
	
	import events.UIEvent;
	
	import handlers.Handler;
	
	import utils.BitmapUtils;
	
	/**
	 *  鼠标提示管理器
	 *  @author JiaWei
	 */	
	public class TipManager extends BaseSprite
	{
		public static var offsetX:int = 10;
		public static var offsetY:int = 15;
		private var _tipBox:Sprite;
		private var _tipBg:BaseImage;
		private var _tipText:BaseLabel;
		private var _defaultTipHandler:Function;
		/**关闭时促发*/
		public var closeHandler:Handler;
		
		public function TipManager()
		{
			super();
			_tipBox = new Sprite();
			mouseEnabled = mouseChildren = false;
			_defaultTipHandler = showDefaultTip;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(UIEvent.SHOW_TIP,onStageShowTip);
			stage.addEventListener(UIEvent.HIDE_TIP,onStageHideTip);
		}
		
		private function onStageHideTip(e:UIEvent):void{
			closeAll();
		}
		
		private function onStageShowTip(e:UIEvent):void{
			AppManager.timer.doOnce(AppConfig.tipDelay,showTip,[e.data]);
		}
		
		private function showTip(tip:Object):void{
			if(tip as String){
				var text:String = String(tip);
				if(Boolean(text)){
					showDefaultTip(text);
				}
			}else if(tip as Handler){
				(tip as Handler).execute();
			}else if(tip as Function){
				(tip as Function).apply();
			}
			if(AppConfig.tipFollowMove){
				stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
				stage.addEventListener(MouseEvent.MOUSE_DOWN,onStageMouseDown);
			}
			onStageMouseMove(null);
		}
		
		protected function onStageMouseDown(e:MouseEvent):void
		{
			closeAll();
		}
		
		protected function onStageMouseMove(e:MouseEvent):void
		{
			var x:int = stage.mouseX + offsetX;
			var y:int = stage.mouseY + offsetY;
			if(x < 0){
				x=0;
			}else if(x > stage.stageWidth - width){
				x = stage.stageWidth - width;
			}
			if(y < 0){
				y = 0;
			}else if(y > stage.stageHeight - height){
				y = stage.stageHeight - height;
			}
			this.x = x;
			this.y = y;
		}		
		
		/**关闭所有鼠标提示*/
		public function closeAll():void{
			if(closeHandler){
				closeHandler.execute();
				closeHandler = null;
			}
			AppManager.timer.clearTimer(showTip);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,onStageMouseDown);
			for (var i:int = numChildren - 1; i>-1; i--){
				var displayObject:DisplayObject =  removeChildAt(i);
				displayObject = null;
			}
		}

		public function get defaultTipHandler():Function
		{
			return _defaultTipHandler;
		}

		public function set defaultTipHandler(value:Function):void
		{
			_defaultTipHandler = value;
		}

		private function showDefaultTip(text:String):void{
			_tipText = _tipText || createTipText(); 
			_tipText.text = text;
			_tipText.commitMeasure();
			var th:int;
			//一行和多行的高度是有差别的
			if (_tipText.textField.numLines == 1)
			{
				th = _tipText.textField.textHeight + 10;
			}
			else
			{
				th = _tipText.textField.textHeight + 17;
			}
			_tipBg = _tipBg || createBg();
			_tipBg.width = _tipText.textField.textWidth + 16;
			_tipBg.height = th;
			addChild(_tipBox);
		}
		
		private function createTipText():BaseLabel
		{
			_tipText = new BaseLabel();
			_tipText.autoSize = "left";
			_tipText.isHtml = true;
			_tipText.multiline = true;
			_tipText.wordWrap = true;
			_tipText.leading = 4;
			_tipText.width = 260;
			_tipText.color=0xe5cb87;
			_tipText.stroke="0x0";
			_tipText.size=12;
			_tipBox.addChild(_tipText);
			_tipText.x = _tipText.y = 5;
			return _tipText;
		}
		
		private function createBg():BaseImage{
			_tipBg = new BaseImage();
			var bmp:BaseBitmap = new BaseBitmap();
			bmp.bitmapData = BitmapUtils.createBitmap(_tipText.width + 10,_tipText.height + 10,UIConfig.tipBgColor,1).bitmapData;
			_tipBg.content = bmp;
			_tipBox.addChildAt(_tipBg,0);
			return _tipBg;
		}
	}
}