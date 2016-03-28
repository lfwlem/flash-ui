package components
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import configs.AppConfig;
	import configs.Direction;
	import configs.UIConfig;
	
	import handlers.Handler;
	
	import managers.AppManager;

	/**
	 *  滚动条基类
	 *  @author JiaWei
	 */	
	public class BaseScrollBar extends BaseSprite
	{
		protected var _slider:BaseSlider;
		protected var _upBtn:BaseButton;
		protected var _downBtn:BaseButton;
		
		protected var _changeHandler:Handler;
		protected var _scrollSize:Number = 1;
		protected var _autoHide:Boolean;
		protected var _scaleBar:Boolean;
		protected var _thumbPercent:Number = 1;
		protected var _target:InteractiveObject;
		protected var _touchScrollEnable:Boolean;
		protected var _mouseWheelEnable:Boolean;
		protected var _lastOffset:Number = 0;
		protected var _lastPoint:Point;
		
		public function BaseScrollBar(bg:BaseImage,bar:BaseButton,up:BaseButton,down:BaseButton)
		{
			if(bg && bar){
				_slider = new BaseSlider(bg,bar);
				addChild(_slider);
			}
			if(up){
				_upBtn = up;
				addChild(_upBtn);
			}
			if(down){
				_downBtn = down;
				addChild(_downBtn);
			}
			super();
		}
		
		override protected function init():void
		{
			super.init();
			mouseChildren = true;
			_slider.setSlider(0,0,0);
			if(_slider.direction == Direction.VERTICAL){
				_slider.y = _upBtn.height;
			}else{
				_slider.x = _upBtn.width;
			}
			resetPositions();
			_touchScrollEnable = AppConfig.touchScrollEnable;
			_mouseWheelEnable = AppConfig.mouseWheelEnable;
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			_slider.addEventListener(Event.CHANGE, onSliderChange);
			_upBtn.addEventListener(MouseEvent.MOUSE_DOWN,onButtonMouseDown);
			_downBtn.addEventListener(MouseEvent.MOUSE_DOWN,onButtonMouseDown);
		}
		
		protected function onSliderChange(e:Event):void
		{
			sendEvent(Event.CHANGE);
			if(_changeHandler != null){
				_changeHandler.executeWith([value]);
			}
		}
		
		protected function onButtonMouseDown(e:MouseEvent):void
		{
			var isUp:Boolean = e.currentTarget == _upBtn;
			slider(isUp);
			AppManager.timer.doOnce(UIConfig.scrollBarDelayTime,startLoop,[isUp]);
			AppManager.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
		}
		
		protected function startLoop(isUp:Boolean):void
		{
			AppManager.timer.doFrameLoop(1,slider,[isUp]);
		}
		
		protected function slider(isUp:Boolean):void
		{
			if(isUp){
				value -= _scrollSize;
			}else{
				value += _scrollSize;
			}
		}		
		
		protected function onStageMouseUp(e:MouseEvent):void{
			AppManager.stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			AppManager.timer.clearTimer(startLoop);
			AppManager.timer.clearTimer(slider);
		}
		
		override protected function changeSize():void
		{
			super.changeSize();
			resetPositions();
		}
		
		protected function resetPositions():void{
			if(_slider.direction == Direction.VERTICAL){
				_slider.height = height - _upBtn.height - _downBtn.height;
			}else{
				_slider.width = width - _upBtn.width - _downBtn.width;
			}
			resetButtonPosition();
		}
		
		protected function resetButtonPosition():void{
			if(_slider.direction == Direction.VERTICAL){
				_downBtn.y = _slider.y + _slider.height;
				_uiWidth = _slider.width;
				_uiHeight = _downBtn.y + _downBtn.height;
			}else{
				_downBtn.x + _slider.x + _slider.width;
				_uiHeight = _slider.height;
				_uiWidth = _downBtn.x + _downBtn.width;
			}
		}
		
		public function setScroll(min:Number, max:Number, value:Number):void{
			changeSize();
			_slider.setSlider(min,max,value);
			_upBtn.enabled = max <= 0;
			_downBtn.enabled = max <= 0;
			_slider.barBtn.visible = max > 0;
			this.visible = !(_autoHide && max <= min);
		}

		/**滚动变化时回调，回传value参数*/
		public function get changeHandler():Handler
		{
			return _changeHandler;
		}

		public function set changeHandler(value:Handler):void
		{
			_changeHandler = value;
		}

		/**移动滑块时是否持续调度Event.CHANGE 事件*/
		public function get liveDragging():Boolean
		{
			return _slider.liveDragging;
		}
		
		public function set liveDragging(value:Boolean):void
		{
			_slider.liveDragging = value;
		}
		
		/**当前滚动位置*/
		public function get value():Number
		{
			return _slider.value;
		}
		
		public function set value(value:Number):void
		{
			if(_slider.value != value){
				_slider.value = value;
			}
		}
		
		/**滚动方向*/
		public function get direction():String
		{
			return _slider.direction;
		}
		
		public function set direction(value:String):void
		{
			_slider.direction = value;
		}
		
		/**最大滚动位置*/
		public function get max():Number
		{
			return _slider.max;
		}
		
		public function set max(value:Number):void
		{
			if(_slider.max != value){
				_slider.max = value;
			}
		}
		
		/**最小滚动位置*/
		public function get min():Number
		{
			return _slider.min;
		}
		
		public function set min(value:Number):void
		{
			if(_slider.min != value){
				_slider.min = value;
			}
		}

		/**是否自动隐藏滚动条(无需滚动时)，默认为true*/
		public function get autoHide():Boolean
		{
			return _autoHide;
		}

		public function set autoHide(value:Boolean):void
		{
			_autoHide = value;
		}

		/**点击按钮滚动量*/
		public function get scrollSize():Number
		{
			return _scrollSize;
		}

		public function set scrollSize(value:Number):void
		{
			_scrollSize = value;
		}

		/**九宫格信息，格式：左边距,上边距,右边距,下边距,是否重复填充(值为0或1)，例如：4,4,4,4,1*/
		public function get sizeGrid():String{
			return _slider.sizeGrid;
		}
		
		public function set sizeGrid(value:String):void{
			_slider.sizeGrid = value;
		}

		/**滑条长度比例(0-1)*/
		public function get thumbPercent():Number
		{
			return _thumbPercent;
		}

		public function set thumbPercent(value:Number):void
		{
			changeSize();
			_thumbPercent = value;
			if(_scaleBar){
				if(_slider.direction == Direction.VERTICAL){
					_slider.barBtn.height = Math.max(int(_slider.height * value),UIConfig.scrollBarMinNum);
				}else{
					_slider.barBtn.width = Math.max(int(_slider.width * value),UIConfig.scrollBarMinNum);
				}
			}
			
		}

		/**滚动对象*/
		public function get target():InteractiveObject
		{
			return _target;
		}

		public function set target(value:InteractiveObject):void
		{
			if(_target){
				_target.removeEventListener(MouseEvent.MOUSE_WHEEL,onMousewheel);
				_target.removeEventListener(MouseEvent.MOUSE_DOWN,onTargetMouseDown);
				
			}
			_target = value;
			if(_target){
				if(_mouseWheelEnable){
					_target.addEventListener(MouseEvent.MOUSE_WHEEL,onMousewheel);
				}
				if(_touchScrollEnable){
					_target.addEventListener(MouseEvent.MOUSE_DOWN,onTargetMouseDown);
				}
			}
		}
		
		protected function onMousewheel(e:MouseEvent):void
		{
			value += (e.delta < 0 ? 3 : -3) * _scrollSize;
			if(value < max && value > min){
				e.stopPropagation();
			}
		}
		
		protected function onTargetMouseDown(e:MouseEvent):void
		{
			AppManager.timer.clearTimer(tweenMove);
			if(!this.contains(e.target as DisplayObject)){
				AppManager.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp2);
				AppManager.stage.addEventListener(Event.ENTER_FRAME,onStageEnterFrame);
				_lastPoint = new Point(AppManager.stage.mouseX,AppManager.stage.mouseY);
			}
		}
		
		protected function tweenMove():void {
			_lastOffset = _lastOffset * 0.92;
			value -= _lastOffset;
			if(Math.abs(_lastOffset) < 0.5){
				AppManager.timer.clearTimer(tweenMove);
			}
		}
		
		protected function onStageMouseUp2(e:MouseEvent):void{
			AppManager.stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp2);
			AppManager.stage.removeEventListener(Event.ENTER_FRAME,onStageEnterFrame);
			_lastOffset = _slider.direction == Direction.VERTICAL ? AppManager.stage.mouseY - _lastPoint.y : AppManager.stage.mouseX - _lastPoint.x;
			if(Math.abs(_lastOffset) > 50){
				_lastOffset = _lastOffset > 0 ? 50 : -50;
			}
			AppManager.timer.doFrameLoop(1,tweenMove);
		}
		
		protected function onStageEnterFrame(e:Event):void{
			_lastOffset = _slider.direction == Direction.VERTICAL ? AppManager.stage.mouseY - _lastPoint.y : AppManager.stage.mouseX - _lastPoint.x;
			if(Math.abs(_lastOffset) >= 1){
				_lastPoint.x = AppManager.stage.mouseX;
				_lastPoint.y = AppManager.stage.mouseY;
				value -= _lastOffset;
			}
		}
		
		/**是否触摸滚动，默认为true*/
		public function get touchScrollEnable():Boolean
		{
			return _touchScrollEnable;
		}

		public function set touchScrollEnable(value:Boolean):void
		{
			_touchScrollEnable = value;
			target = _target;
		}

		/**是否滚轮滚动，默认为true*/
		public function get mouseWheelEnable():Boolean
		{
			return _mouseWheelEnable;
		}

		public function set mouseWheelEnable(value:Boolean):void
		{
			_mouseWheelEnable = value;
			target = _target;
		}

		/**是否缩放滑条*/
		public function get scaleBar():Boolean
		{
			return _scaleBar;
		}

		public function set scaleBar(value:Boolean):void
		{
			_scaleBar = value;
		}
		
		override public function destory():void
		{
			super.destory();
			if(_upBtn){
				_upBtn.destory();
				_upBtn = null;
			}
			if(_slider){
				_slider.destory();
				_slider = null;
			}
			if(_downBtn){
				_downBtn.destory();
				_downBtn = null;
			}
			_changeHandler = null;
			_target = null;
			_lastPoint = null;
		}
		
	}
}