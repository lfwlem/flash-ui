package managers
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.ui.KeyboardType;
	
	import utils.BitmapUtils;

	/**
	 *  日志管理器
	 *  @author JiaWei
	 */	
	public class LogManager extends Sprite
	{
		private var _box:Sprite;
		private var _selectedText:TextField;
		private var _clearBtn:TextField;
		private var _copyBtn:TextField;
		private var _pauseBtn:TextField;
		private var _text:TextField;
		
		private var _msgs:Array = [];
		private var _selecteds:Array = [];
		private var _canPause:Boolean = true;
		private var _maxMsg:int = 300;
		
		public function LogManager()
		{
			//容器
			_box = new Sprite();
			var bmp:Bitmap = BitmapUtils.createBitmap(400, 300, 0x333333, 0.9);
			_box.addChild(bmp);
			_box.visible = false;
			addChild(_box);
			
			//筛选栏
			_selectedText = new TextField();
			_selectedText.y = _selectedText.x = 3;
			_selectedText.width = 250;
			_selectedText.height = 20;
			_selectedText.type = "input";
			_selectedText.textColor = 0xFFFFFF;
			_selectedText.border = true;
			_selectedText.borderColor = 0xBFBFBF;
			_selectedText.defaultTextFormat = new TextFormat("Microsoft YaHei,Arial", 12);
			_box.addChild(_selectedText);
			
			//控制按钮
			_clearBtn = createLinkButton("Clear");
			_clearBtn.x = 260;
			_box.addChild(_clearBtn);
			_copyBtn = createLinkButton("Copy");
			_copyBtn.x = 300;
			_box.addChild(_copyBtn);
			_pauseBtn = createLinkButton("Pause");
			_pauseBtn.x = 340;
			_box.addChild(_pauseBtn);
			
			//信息栏
			_text = new TextField();
			_text.width = 400;
			_text.height = 280;
			_text.y = 25;
			_text.multiline = true;
			_text.wordWrap = true;
			_text.defaultTextFormat = new TextFormat("Microsoft YaHei,Arial");
			_box.addChild(_text);
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		protected function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			_selectedText.addEventListener(KeyboardEvent.KEY_DOWN,onSelectedTextKeyDown);
			_selectedText.addEventListener(FocusEvent.FOCUS_OUT,onSelectedTextFocusOut);
			_copyBtn.addEventListener(MouseEvent.CLICK,onClearClick);
			_copyBtn.addEventListener(MouseEvent.CLICK,onCopyClick);
			_pauseBtn.addEventListener(MouseEvent.CLICK,onPauseClick);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onStageKeyDown);
		}
		
		/**创建文本按钮*/
		private function createLinkButton(text:String):TextField{
			var tf:TextField = new TextField();
			tf.selectable = false;
			tf.autoSize = "left";
			tf.defaultTextFormat = new TextFormat("Microsoft YaHei,Arial", 14, 0x0080C0, false, null, true);
			tf.text = text;
			return tf;
		}
		
		protected function onSelectedTextKeyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.ENTER){
				AppManager.stage.focus = _box;
			}
		}
		
		protected function onSelectedTextFocusOut(e:FocusEvent):void
		{
			_selecteds = Boolean(_selectedText) ? _selectedText.text.split(",") : [];
			refresh(null);
		}
		
		protected function onClearClick(e:MouseEvent):void
		{
			clear();
		}
		
		protected function onCopyClick(e:MouseEvent):void
		{
			System.setClipboard(_text.text);
		}
		
		protected function onPauseClick(e:MouseEvent):void
		{
			_canPause = !_canPause;
			_pauseBtn.text = _canPause ? "Pause" : "Start";
			if(_canPause){
				refresh(null);
			}
		}
		
		protected function onStageKeyDown(e:KeyboardEvent):void
		{
			if((e.ctrlKey || e.shiftKey) && e.keyCode == Keyboard.L){
				trace("toggle");
				toggle();
			}
		}
		
		/**清理所有日志*/
		private function clear():void{
			_msgs = [];
			_text.htmlText = ""
		}
		
		/**打开或隐藏面板*/
		public function toggle():void {
			_box.visible = !_box.visible;
			if(_box.visible){
				refresh(null);
			}
		}
		
		/**根据过滤刷新显示*/
		private function refresh(newMsg:String):void {
			var msg:String = "";
			if(newMsg != null){
				if(isFilter(newMsg)){
					if(_text.numLines > 500){
						_text.htmlText = "";
					}
					msg = (_text.htmlText || "") + newMsg;
					_text.htmlText = msg;
				}
			}else{
				_text.htmlText = getMsgFromCache();
			}
			
			if(_canPause){
				_text.scrollV = _text.maxScrollV;
			}
		}
		
		/**是否是筛选属性*/
		private function isFilter(msg:String):Boolean {
			if(_selecteds.length<1){
				return true;
			}
			for each(var item:String in _selecteds){
				if(msg.indexOf(item) > -1){
					return true;
				}
			}
			return false;
		}
		
		private function getMsgFromCache():String {
			var msg:String = "";
			for each(var item:String in _msgs){
				if(isFilter(item)){
					msg += item;
				}
			}
			return msg;
		}
		
		/**打印文本*/
		public function print(type:String, args:Array, color:uint):void {
			var str:String = args.join(",");
			var msg:String = "<p><font color='#" + color.toString(16) + "'><b>[" + type + "]</b></font> <font color='#EEEEEE'>" + str + "</font></p>";
			trace("[" + type + "]" + str);
			if(_msgs.length > _maxMsg){
				_msgs.length = 0;
			}
			_msgs.push(msg);
			if(_box.visible){
				refresh(msg);
			}
		}
		
		/**信息*/
		public function info(... args:Array):void {
			print("info", args, 0x3EBDF4);
		}
		
		/**消息*/
		public function echo(... args:Array):void {
			print("echo", args, 0x00C400);
		}
		
		/**调试*/
		public function debug(... args:Array):void {
			print("debug", args, 0xdddd00);
		}
		
		/**错误*/
		public function error(... args:Array):void {
			print("error", args, 0xFF4646);
		}
		
		/**警告*/
		public function warn(... args:Array):void {
			print("warn", args, 0xFFFF80);
		}
		
	}
}