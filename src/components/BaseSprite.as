package components
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import events.UIEvent;
	
	import handlers.Handler;
	
	import managers.AppManager;
	
	import utils.FilterUtils;
	
	
	/**重置大小后触发*/
	[Event(name="resize",type="flash.events.Event")]
	/**移动组件后触发*/
	[Event(name="move",type="morn.core.events.UIEvent")]
	
	
	/**
	 * 基类
	 *  @author JiaWei
	 */	
	public class BaseSprite extends Sprite
	{
		protected var _width:Number = Number.NaN;
		protected var _height:Number = Number.NaN;
		protected var _uiWidth:Number = 0;
		protected var _uiHeight:Number = 0;
		protected var _events:Array;
		protected var _toolTip:Object;
		protected var _showingTip:Boolean = false;
		protected var hadDestroy:Boolean = false;
		protected var _enabled:Boolean;
		
		public function BaseSprite()
		{
			super();
			mouseChildren = tabEnabled = tabChildren = false;
			_events = [];
			init();
			initEvent();
		}
		
		protected function init():void
		{
		}
		
		protected function initEvent():void
		{
		}
		
		protected function removeEvent():void
		{
		}
		
		/**派发事件，可以携带数据*/
		public function sendEvent(type:String, data:* = null,cancelable:Boolean=false):void
		{
			if (hasEventListener(type))
			{
				dispatchEvent(new UIEvent(type, data,cancelable));
			}
		}
		
		/**
		 * 设置组件大小
		 * @param width
		 * @param height
		 * */
		public function setSize(width:Number, height:Number):void
		{
			this.width = width;
			this.height = height;
		}
		
		protected function changeSize():void
		{
			sendEvent(Event.RESIZE);
		}
		
		/**高度(值为NaN时，高度为自适应大小)*/
		override public function get height():Number{
			if(!isNaN(_height)){
				return _height;
			}else if(_uiHeight != 0){
				return _uiHeight;
			}else{
				return measureHeight();
			}
		}
		
		/**显示的高度(height * scaleY)*/
		public function get displayHeight():Number {
			return height * scaleY;
		}
		
		/**组件的最大高度*/
		protected function get measureHeight():Number {
			var max:Number = 0;
			for(var i:int = numChildren-1;i > -1; i--){
				var comp:DisplayObject = getChildAt(i);
				if(comp.visible){
					max = Math.max(comp.y + comp.height * comp.scaleY,max);
				}
			}
			return max;
		}
		
		override public function set height(value:Number):void
		{
			if(_height != value){
				_height = value;
				changeSize();
			}
		}
		
		/**宽度(值为NaN时，宽度为自适应大小)*/
		override public function get width():Number {
			if(!isNaN(_width)){
				return _width;
			}else if(_uiWidth != 0){
				return _uiWidth;
			}else{
				return measureWidth();
			}
		}
		
		/**显示的宽度(width * scaleX)*/
		public function get displayWidth():Number {
			return width * scaleX;
		}
		
		/**组件的最大宽度*/
		protected function get measureWidth():Number {
			var max:Number = 0;
			for(var i:int = numChildren-1;i > -1; i--){
				var comp:DisplayObject = getChildAt(i);
				if(comp.visible){
					max = Math.max(comp.x + comp.width * comp.scaleX,max);
				}
			}
			return max;
		}
		
		override public function set width(value:Number):void
		{
			if(_width != value){
				_width = value;
				changeSize();
			}
		}
		
		/**
		 * 设置组件位置
		 * @param x
		 * @param y
		 * 
		 */		
		public function move(_x:Number,_y:Number):void{
			this.x = _x;
			this.y = _y;
		}
		
		protected function changeMove():void
		{
			sendEvent(UIEvent.MOVE);
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
			changeMove();
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
			changeMove();
		}
		
		/**
		 * 设置缩放比例(等同于同时设置scaleX，scaleY)
		 * @param value
		 */	
		public function set scale(value:Number):void
		{
			scaleX = scaleY = value;
		}
		
		/**鼠标提示
		 * 可以赋值为文本及函数，以实现自定义鼠标提示和参数携带等
		 * @example 下面例子展示了三种鼠标提示
		 * <listing version="3.0">
		 *	private var _testTips:TestTipsUI = new TestTipsUI();
		 *	private function testTips():void {
		 *		//简单鼠标提示
		 *		btn2.toolTip = "这里是鼠标提示&lt;b&gt;粗体&lt;/b&gt;&lt;br&gt;换行";
		 *		//自定义的鼠标提示
		 *		btn1.toolTip = showTips1;
		 *		//带参数的自定义鼠标提示
		 *		clip.toolTip = new Handler(showTips2, ["clip"]);
		 *	}
		 *	private function showTips1():void {
		 *		_testTips.label.text = "这里是按钮[" + btn1.label + "]";
		 *		App.tip.addChild(_testTips);
		 *	}
		 *	private function showTips2(name:String):void {
		 *		_testTips.label.text = "这里是" + name;
		 *		App.tip.addChild(_testTips);
		 *	}
		 * </listing>*/
		public function get toolTip():Object{
			return _toolTip;
		}
		
		public function set toolTip(value:Object):void{
			var _preTip:Object = _toolTip;
			if(_toolTip != value){
				_toolTip = value;
				if(Boolean(value)){
					addEventListener(MouseEvent.ROLL_OVER, onRollMouse);
					addEventListener(MouseEvent.ROLL_OUT, onRollMouse);
					if(_showingTip && Boolean(_preTip)){
						sendEvent(UIEvent.SHOW_TIP,_toolTip,true);
					}
				}else{
					removeEventListener(MouseEvent.ROLL_OVER, onRollMouse);
					removeEventListener(MouseEvent.ROLL_OUT, onRollMouse);
				}
			}
		}
		
		protected function onRollMouse(e:MouseEvent):void
		{
			var handleType:String = e.type == MouseEvent.ROLL_OVER ? UIEvent.SHOW_TIP:UIEvent.HIDE_TIP;
			sendEvent(handleType,_toolTip,true);
			if(handleType == UIEvent.SHOW_TIP){
				_showingTip = true;
				AppManager.tip.closeHandler = new Handler(hideTipHandler);
			}else{
				hideTipHandler();
			}
		}
		
		private function hideTipHandler():void
		{
			_showingTip = false;
		}
		
		override public function set doubleClickEnabled(value:Boolean):void {
			super.doubleClickEnabled = value;
			for (var i:int = numChildren - 1; i > -1; i--) {
				var display:InteractiveObject = getChildAt(i) as InteractiveObject;
				if (display) {
					display.doubleClickEnabled = value;
				}
			}
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_events.push({type: type, fun: listener});
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			super.removeEventListener(type, listener, useCapture);
			for (var i:int = 0; i < _events.length; i++)
			{
				if (_events[i].type == type && _events[i].fun == listener)
				{
					_events.splice(i, 1)
				}
			}
		}
		
		/**从父容器删除自己，如已经被删除不会抛出异常*/
		public function remove():void
		{
			if (parent)
			{
				parent.removeChild(this);
			}
		}
		
		/**
		 * 根据名字删除子对象，如找不到不会抛出异常
		 * @param name
		 */	
		public function removeChildByName(name:String):void
		{
			var display:DisplayObject = getChildByName(name);
			if (display)
			{
				removeChild(display);
			}
		}
		
		/**是否禁用*/
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			if(_enabled != value){
				_enabled = value;
				mouseEnabled = !value;
				super.mouseChildren = value ? false : mouseChildren;
				FilterUtils.gray(this,_enabled);
			}
		}
		
		/**添加显示对象*/
		public function addElement(element:DisplayObject,x:Number,y:Number):void{
			element.x = x;
			element.y = y;
			addChild(element);
		}
		
		/**增加显示对象到index层*/
		public function addElementAt(element:DisplayObject,index:int,x:Number,y:Number):void{
			element.x = x;
			element.y = y;
			addChildAt(element,index);
		}
		
		/**批量增加显示对象*/
		public function addElements(elements:Array):void{
			for(var i:int = 0,n:int = elements.length; i< n ; i++){
				var item:DisplayObject = elements[i];
				addChild(item);
			}
		}
		
		/**删除子显示对象，子对象为空或者不包含子对象时不抛出异常*/
		public function removeElement(element:DisplayObject):void{
			if(element && contains(element)){
				removeChild(element);
			}
		}
		
		/**删除所有子显示对象
		 * @param except 例外的对象(不会被删除)*/
		public function removeAllChild(except:DisplayObject = null):void{
			for(var i:int = numChildren-1;i > -1 ;i--){
				if(except != getChildAt(i)){
					removeChildAt(i);
				}
			}
		}
		
		/**增加显示对象到某对象上面
		 @param element 要插入的对象
		 @param compare 参考的对象*/
		public function insertAbove(element:DisplayObject,compare:DisplayObject):void{
			removeElement(element);
			var index:int = getChildIndex(compare);
			addChildAt(element,Math.min(index+1,numChildren));
		}
		
		/**增加显示对象到某对象下面
		 @param element 要插入的对象
		 @param compare 参考的对象*/
		public function insertBelow(element:DisplayObject,compare:DisplayObject):void{
			removeElement(element);
			var index:int = getChildIndex(compare);
			addChildAt(element,Math.max(index+1,numChildren));
		}
		
		public function destory():void{
			hadDestroy = true;
			removeEvent();
			
			var evt:Object;
			while(_events.length){
				evt = _events.pop();
				super.removeEventListener(evt.type,evt.fun);
			}
			evt = null;
			_toolTip = null;
			
			var _child:*;
			while(this.numChildren>0){
				_child = getChildAt(0);
				if(_child as BaseSprite){
					(_child as BaseSprite).destory();
				}
				if(this.contains(_child)){
					this.removeChild(_child);
				}
			}
			_child = null;
			remove();
		}

	}
}