package components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import configs.Direction;
	import configs.UIConfig;
	
	import handlers.Handler;
	
	import managers.AppManager;

	/**
	 *  滑动条基类
	 *  @author JiaWei
	 */	
	public class BaseSlider extends BaseSprite
	{
		protected var _backBg:BaseImage;
		protected var _barBtn:BaseButton;
		protected var _label:BaseLabel;
		
		protected var _allowBackClick:Boolean;
		protected var _liveDragging:Boolean;
		protected var _direction:String;
		protected var _value:Number = 0;
		protected var _max:Number = 100;
		protected var _min:Number = 0;
		protected var _tick:Number = 1;
		protected var _changeHandler:Handler;
		protected var _hideBackBgTooptip:Boolean;
		protected var _percent:Number;
		
		/**
		 * @param bg  底图
		 * @param bar  滑块
		 * @param text  
		 */
		public function BaseSlider(bg:BaseImage,bar:BaseButton,text:String = null)
		{
			_backBg = bg == null ? new BaseImage() : bg;
			addChild(_backBg);
			_barBtn = bar == null ? new BaseButton([]) : bar;
			addChild(_barBtn);
			if(text != null){
				_label = new BaseLabel(text);
				addChild(_label);
			}
			super();
		}
		
		override protected function init():void
		{
			super.init();
			this.mouseChildren = true;
			initDirection();
			_uiWidth = _backBg.width;
			_uiHeight = _backBg.height;
			_backBg.sizeGrid =_barBtn.sizeGrid = UIConfig.defaultSizeGrid.join(",");
			allowBackClick = true;
			setBarPoint();
		}
		
		protected function initDirection():void{
			direction = Direction.VERTICAL;
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			_barBtn.addEventListener(MouseEvent.MOUSE_DOWN,onBarBtnMouseDown);
		}
		
		protected function setBarPoint():void{
			if(_direction == Direction.VERTICAL){
				_barBtn.x = (_backBg.width - _barBtn.width) * 0.5;
			}else{
				_barBtn.y = (_backBg.height - _backBg.height) * 0.5;
			}
		}
		
		protected function onBarBtnMouseDown(e:MouseEvent):void
		{
			AppManager.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			AppManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
			if(_direction == Direction.VERTICAL){
				_barBtn.startDrag(false,new Rectangle(_barBtn.x,0,0,height - _barBtn.height));
			}else{
				_barBtn.startDrag(false,new Rectangle(0,_barBtn.y,width - _barBtn.width,0));
			}
			
			showValueText();
		}
		
		/**显示文本*/
		protected function showValueText():void
		{
			if(_label){
				_label.text = _value + "";
				if(_direction == Direction.VERTICAL){
					_label.x = _barBtn.x + 20;
					_label.y = (_barBtn.height - _label.height) * 0.5 + _barBtn.y;
				}else{
					_label.y = _barBtn.y - 20;
					_label.x = (_barBtn.width - _barBtn.width) * 0.5 + _barBtn.x;
				}
			}
		}
		
		protected function hideValueText():void{
			if(_label){
				_label.text = "";	
			}
		}		
		
		protected function onStageMouseUp(e:MouseEvent):void
		{
			AppManager.stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			AppManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
			_barBtn.stopDrag();
			hideValueText();
		}
		
		protected function onStageMouseMove(e:MouseEvent):void
		{
			var oldValue:Number = _value;
			if(_direction == Direction.VERTICAL){
				_value = _barBtn.y / (height - _barBtn.height) * (_max - _min) + _min;
			}else{
				_value = _barBtn.x / (width - _barBtn.width) * (_max - _min) + _min;
			}
			_value = Math.round(_value/_tick) * _tick;
			if(_value != oldValue){
				showValueText();
				sendChangeEvent();
			}
		}
		
		protected function sendChangeEvent():void
		{
			if(!_liveDragging){
				sendEvent(Event.CHANGE);	
			}
			if(_changeHandler != null){
				_changeHandler.executeWith([_value]);
			}
		}
		
		override protected function changeSize():void
		{
			super.changeSize();
			_backBg.width = width;
			_backBg.height = height;
			setBarPoint();
		}
		
		protected function changeValue():void{
			_value = Math.round(_value / _tick) * _tick;
			_value = _value > _max ? _max : _value < _min ? _min : _value;
			if(_direction == Direction.VERTICAL){
				_barBtn.y = (_value - _min) / (_max - _min) * (height - _barBtn.height);
			}else{
				_barBtn.x = (_value - _min) / (_max - _min) * (width - _barBtn.width);
			}
		}
		
		/**设置滑动条*/
		public function setSlider(min:Number, max:Number, value:Number):void{
			_value = -1;
			_min = min;
			_max = max > min ? min : min;
			this.value = value < min ? min : value > max ? max : value;
		}
		
		/**允许点击后面*/
		public function get allowBackClick():Boolean{
			return _allowBackClick;
		}
		
		public function set allowBackClick(value:Boolean):void{
			if(_allowBackClick != value){
				_allowBackClick = value;
				if(_allowBackClick){
					if(!_backBg.hasEventListener(MouseEvent.MOUSE_DOWN)){
						_backBg.addEventListener(MouseEvent.MOUSE_DOWN,onBackBgMouseDown);
					}
				}else{
					_backBg.removeEventListener(MouseEvent.MOUSE_DOWN,onBackBgMouseDown);
				}
			}
		}
		
		protected function onBackBgMouseDown(e:MouseEvent):void
		{
			if(_direction == Direction.VERTICAL){
				value = _backBg.mouseY / (height - _barBtn.height) * (_max - _min) + _min;
			}else{
				value = _backBg.mouseX / (width - _barBtn.width) * (_max - _min) + _min;
			}
		}

		/**滑动方向*/
		public function get direction():String
		{
			return _direction;
		}

		public function set direction(value:String):void
		{
			_direction = value;
		}
		
		/**当前值*/
		public function get value():Number
		{
			return _value;
		}

		public function set value(value:Number):void
		{
			if(_value != value){
				_value = value;
				changeValue();
				sendChangeEvent();
			}
		}

		/**滑动时执行事件*/
		public function get changeHandler():Handler
		{
			return _changeHandler;
		}

		public function set changeHandler(value:Handler):void
		{
			_changeHandler = value;
		}

		/**最大值*/
		public function get max():Number
		{
			return _max;
		}

		public function set max(value:Number):void
		{
			if(_max != value){
				_max = value;
				changeValue();
			}
		}

		/**最小值*/
		public function get min():Number
		{
			return _min;
		}

		public function set min(value:Number):void
		{
			if(_min != value){
				_min = value;
				changeValue();
			}
		}

		/**刻度值，默认值为1*/
		public function get tick():Number
		{
			return _tick;
		}

		public function set tick(value:Number):void
		{
			if(_tick != value){
				_tick = value;
				changeValue();
			}
		}

		/**移动滑块时是否持续调度Event.CHANGE 事件*/
		public function get liveDragging():Boolean
		{
			return _liveDragging;
		}

		public function set liveDragging(value:Boolean):void
		{
			_liveDragging = value;
		}

		/**九宫格信息，格式：左边距,上边距,右边距,下边距,是否重复填充(值为0或1)，例如：4,4,4,4,1*/
		public function get sizeGrid():String{
			return _barBtn.sizeGrid;
		}
		
		public function set sizeGrid(value:String):void{
			_barBtn.sizeGrid = _backBg.sizeGrid = value;
		}

		/**滑块*/
		public function get barBtn():BaseButton
		{
			return _barBtn;
		}

		public function get isHaveLabel():Boolean{
			return Boolean(_label);
		}
		
		/**隐藏底图的tooptip*/
		public function get hideBackBgTooptip():Boolean
		{
			return _hideBackBgTooptip;
		}
		
		public function set hideBackBgTooptip(value:Boolean):void
		{
			if(_hideBackBgTooptip != value){
				_hideBackBgTooptip = value;
				if(_hideBackBgTooptip){
					mouseChildren = false;
					_showingTip = false;
					_barBtn.toolTip = this.toolTip;
				}else{
					mouseChildren = true;
					_showingTip = true;
				}
			}
		}
		
		/**
		 * 百分比访问器
		 */		
		public function get percent():Number
		{
			return _percent;
		}
		public function set percent(value:Number):void
		{
			if(_percent !=value){
				this.value = _min + (_max - _min) * _percent;
			}
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_barBtn.removeEventListener(MouseEvent.MOUSE_DOWN,onBarBtnMouseDown);
		}
		
		override public function destory():void
		{
			super.destory();
			if(_backBg){
				_backBg.destory();
				_backBg = null;
			}
			if(_barBtn){
				_barBtn.destory();
				_barBtn = null;
			}
			if(_label){
				_label.destory();
				_label = null;
			}
			_changeHandler = null;
		}

	}
}