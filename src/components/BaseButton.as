package components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	import configs.BtnLabelType;
	import configs.UIConfig;
	
	import handlers.Handler;
	
	import uiInterface.ISelect;
	
	import utils.StringUtils;
	
	/**
	 *  按钮基类
	 *  @author JiaWei
	 */	
	public class BaseButton extends BaseSprite implements ISelect
	{
		protected static var stateMap:Object = {"rollOver":1, "rollOut":0, "mouseDown":2, "mouseUp":1, "selected":2};
		protected var _bitmap:BaseBitmap;
		protected var _btnLabel:BaseLabel;
		protected var _btnLabelBitmap:BaseLabelBitmap;
		protected var _bitmapList:Array;
		
		protected var _btnLabelType:int;
		protected var _selected:Boolean;
		protected var _clickHandler:Handler;
		protected var _toggle:Boolean;
		protected var _state:int = 0;
		protected var _labelColors:Array;
		protected var _labelMargin:Array;
		protected var _stateNum:int;
		protected var _autoSize:Boolean = true;
		
		public function BaseButton(_list:Array,_label:String = "",_btnLabelType:int = 0)
		{
			super();
			initBitmap();
			bitmapList = _list;
			btnLabelType = _btnLabelType;
			initLabel(_label);
		}

		private function initBitmap():void
		{
			_bitmap = new BaseBitmap();
			addChild(_bitmap);
			
			_bitmap.sizeGrid = UIConfig.defaultSizeGrid;
			_stateNum = UIConfig.buttonStateNum;
			_btnLabelType = BtnLabelType.btnDefaultType;
			
		}		
		
		private function initLabel(_label:String):void{
			switch(_btnLabelType){
				case BtnLabelType.btnLabelType:
					_btnLabel = new BaseLabel();
					addChild(_btnLabel);
					label = _label;
					_btnLabel.align = TextFieldAutoSize.CENTER;
					_labelColors = UIConfig.buttonLabelColors;
					_labelMargin = UIConfig.buttonLabelMargin;
					break;
				case BtnLabelType.btnLabelBitmapType:
					_btnLabelBitmap = new BaseLabelBitmap(_label,UIConfig.buttonLabelBitmapColors);
					addChild(_btnLabelBitmap);
					_labelColors = UIConfig.buttonLabelBitmapColors;
					_labelMargin = UIConfig.buttonLabelMargin;
					break;
				default:
					break;
			}
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			addEventListener(MouseEvent.ROLL_OVER,onMouseEvent);
			addEventListener(MouseEvent.ROLL_OUT,onMouseEvent);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
			addEventListener(MouseEvent.MOUSE_UP,onMouseEvent);
			addEventListener(MouseEvent.CLICK,onMouseEvent);
		}
		
		protected function onMouseEvent(e:MouseEvent):void{
			if ((_toggle == false && _selected) || this.enabled){
				return;
			}
			if(e.type == MouseEvent.CLICK){
				if(_toggle){
					selected = !_selected;
				}
				if(_clickHandler){
					_clickHandler.execute();
				}
				return;
			}
			if(_selected == false){
				state = stateMap[e.type];
			}
		}
		
		/**按钮文本类型*/
		public function get btnLabelType():int
		{
			return _btnLabelType;
		}
		
		public function set btnLabelType(value:int):void
		{
			if(_btnLabelType != value){
				_btnLabelType = value <=0 ? 0 : value >=2 ? 2 : value;	
			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected != value){
				_selected = value;	
				state = _selected ? stateMap["selected"] : stateMap["rollOut"];
				sendEvent(Event.CHANGE);
			}
		}
		
		public function get clickHandler():Handler
		{
			return _clickHandler;
		}
		
		public function set clickHandler(value:Handler):void
		{
			_clickHandler = value;
		}

		public function get bitmapList():Array
		{
			return _bitmapList;
		}

		public function set bitmapList(value:Array):void
		{
			if(_bitmapList != value){
				_bitmapList = value;	
				changeState();
			}
		}

		/**支持单态，两态和三态*/
		public function get number():int
		{
			return _bitmapList.length;
		}

		/**是否是切换状态*/
		public function get toggle():Boolean
		{
			return _toggle;
		}

		public function set toggle(value:Boolean):void
		{
			_toggle = value;
		}

		public function get state():int
		{
			return _state;
		}

		public function set state(value:int):void
		{
			if(_state != value){
				_state = value;	
				changeState();
			}
		}
		
		override public function set enabled(value:Boolean):void
		{
			if(enabled != value){
				state = _selected ? stateMap["selected"] : stateMap["rollOut"];
				super.enabled = value;	
			}
		}
		
		protected function changeState():void{
			var index:int = _state;
			if(_stateNum == 2){
				index = index < 2 ? index : 1;
			}else if(_stateNum == 1){
				index = 0;
			}
			_bitmap = _bitmapList[index];
			if(_btnLabel){
				_btnLabel.color = _labelColors[_state];	
			}
			if(_btnLabelBitmap){
				_btnLabelBitmap.grandientTextColor = _labelColors;
			}
			if(_autoSize){
				setSize(_bitmap.width,_bitmap.height);
			}
		}
		
		//--------------------------btnLabel-------------------------------------------
		
		/**按钮标签*/
		public function get label():String{
			return _btnLabelType ==BtnLabelType.btnDefaultType ? null : _btnLabelType ==BtnLabelType.btnLabelType ?_btnLabel.text : _btnLabelBitmap.text;
		}
		
		public function set label(value:String):void{
			if(_btnLabelType == BtnLabelType.btnDefaultType){
				return;
			}
			if(_btnLabel && _btnLabel.text != value){
				_btnLabel.text = value;
			}
			if(_btnLabelBitmap && _btnLabelBitmap.text != value){
				_btnLabelBitmap.text = value;
			}
		}
		
		/**按钮标签控件*/
		public function get btnLabel():BaseLabel
		{
			return _btnLabel;
		}
		
		/**按钮渐变标签控件*/
		public function get btnLabelBitmap():BaseLabelBitmap
		{
			return _btnLabelBitmap;
		}

		/**按钮标签颜色(格式:upColor,overColor,downColor,disableColor) 或渐变颜色*/
		public function get labelColors():String
		{
			return String(_labelColors);
		}

		public function set labelColors(value:String):void
		{
			if(_btnLabelType == BtnLabelType.btnDefaultType){
				return;
			}
			_labelColors = StringUtils.fillArray(_labelColors,value,uint);
			changeState();
		}

		/**按钮标签边距(格式:左边距,上边距,右边距,下边距)*/
		public function get labelMargin():String
		{
			return String(_labelMargin);
		}

		public function set labelMargin(value:String):void
		{
			if(_btnLabelType == BtnLabelType.btnDefaultType){
				return;
			}
			_labelMargin = StringUtils.fillArray(_labelMargin,value,int);
			changeLabelSize();
		}
		
		/**按钮标签描边(格式:color,alpha,blurX,blurY,strength,quality)*/
		public function get labelStroke():String{
			return _btnLabelType == BtnLabelType.btnLabelType ?  _btnLabel.stroke : null;
		}
		
		public function set labelStroke(value:String):void{
			if(_btnLabelType != BtnLabelType.btnLabelType){
				return;
			}
			if(_btnLabel){
				_btnLabel.stroke = value;	
			}
		}
		
		/**渐变文本滤镜*/
		public function get grandientTextFilter():Array
		{
			return _btnLabelType == BtnLabelType.btnLabelBitmapType ?  _btnLabelBitmap.grandientTextFilter : null;;
		}
		
		public function set grandientTextFilter(value:Array):void
		{
			if(_btnLabelType != BtnLabelType.btnLabelBitmapType){
				return;
			}
			if(_btnLabelBitmap){
				_btnLabelBitmap.grandientTextFilter = value;	
			}
		}
		
		/**按钮标签大小*/
		public function get labelSize():int{
			return _btnLabelType ==BtnLabelType.btnDefaultType ? null : _btnLabelType ==BtnLabelType.btnLabelType ?_btnLabel.size : _btnLabelBitmap.grandientTextSize;
		}
		
		public function set labelSize(value:int):void{
			if(_btnLabelType == BtnLabelType.btnDefaultType){
				return;
			}
			if(_btnLabel){
				_btnLabel.size = value;	
			}
			if(_btnLabelBitmap){
				_btnLabelBitmap.grandientTextSize = value;
			}
			changeLabelSize();
		}
		
		/**按钮标签粗细*/
		public function get labelBold():Boolean{
			return _btnLabelType ==BtnLabelType.btnDefaultType ? null : _btnLabelType ==BtnLabelType.btnLabelType ?_btnLabel.bold : _btnLabelBitmap.grandientTextBlod;
		}
		
		public function set labelBold(value:Boolean):void{
			if(_btnLabelType == BtnLabelType.btnDefaultType){
				return;
			}
			if(_btnLabel){
				_btnLabel.bold = value;	
			}
			if(_btnLabelBitmap){
				_btnLabelBitmap.grandientTextBlod = value;
			}
			changeLabelSize();
		}
		
		/**字间距*/
		public function get letterSpacing():int{
			return _btnLabelType == BtnLabelType.btnLabelType ?  _btnLabel.letterSpacing : null;
		}
		
		public function set letterSpacing(value:int):void{
			if(_btnLabelType != BtnLabelType.btnLabelType){
				return;
			}
			if(_btnLabel){
				_btnLabel.letterSpacing = value;	
			}
			changeLabelSize();
		}
		
		/**按钮标签字体*/
		public function get labelFont():String{
			return _btnLabelType == BtnLabelType.btnLabelType ?  _btnLabel.font : null;
		}
		
		public function set labelFont(value:String):void{
			if(_btnLabelType != BtnLabelType.btnLabelType){
				return;
			}
			if(_btnLabel){
				_btnLabel.font = value;	
			}
			changeLabelSize();
		}
		
		protected function changeLabelSize():void{
			changeBitmapSize();
			if(_btnLabel){
				_btnLabel.width = width - _labelMargin[0] - _labelMargin[2];
				_btnLabel.height = StringUtils.getTextField(_btnLabel.format).height;
				_btnLabel.x = _labelMargin[0];
				_btnLabel.y = (height - _btnLabel.height) * 0.5 + _labelMargin[1] -_labelMargin[3];	
			}
			if(_btnLabelBitmap){
//				_btnLabel.width = width - _labelMargin[0] - _labelMargin[2];
//				_btnLabel.height = StringUtils.getTextField(_btnLabelBitmap.format).height;
				_btnLabel.x = _labelMargin[0];
				_btnLabel.y = (height - _btnLabelBitmap.height) * 0.5 + _labelMargin[1] -_labelMargin[3];	
			}
		}
		
		//--------------------------btnLabel-------------------------------------------
		
		override public function setSize(width:Number, height:Number):void
		{
			super.setSize(width, height);
			changeLabelSize();
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			if(_autoSize){
				_bitmap.height = value;
			}
			changeLabelSize();
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			if(_autoSize){
				_bitmap.width = value;
			}
			changeLabelSize();
		}
		
		protected function changeBitmapSize():void{
//			_bitmap = _bitmapList[_stateNum];
			if(_autoSize){
				_uiWidth = _bitmap.width;
				_uiHeight = _bitmap.height;
			}
		}
		
		/**九宫格信息，格式：左边距,上边距,右边距,下边距,是否重复填充(值为0或1)，例如：4,4,4,4,1*/
		public function get sizeGrid():String {
			if (_bitmap.sizeGrid) {
				return _bitmap.sizeGrid.join(",");
			}
			return null;
		}
		
		public function set sizeGrid(value:String):void {
			_bitmap.sizeGrid = StringUtils.fillArray(UIConfig.defaultSizeGrid, value, int);
		}

		/**皮肤的状态数，支持单态，两态和三态按钮，分别对应1,2,3值，默认是三态*/
		public function get stateNum():int
		{
			return _stateNum;
		}

		public function set stateNum(value:int):void
		{
			if(_stateNum != value){
				_stateNum = value < 1 ? 1 : value >3 ? 3 : value;	
				changeBitmapSize();
				changeState();
			}
		}

		/**销毁*/
		override public function destory():void{
			super.destory();
			if(_bitmap && this.contains(_bitmap)){
				this.removeChild(_bitmap);
				_bitmap.destory();
			}
			if(_btnLabel && this.contains(_btnLabel)){
				this.removeChild(_btnLabel);
				_btnLabel.destory();
			}
			if(_btnLabelBitmap && this.contains(_btnLabelBitmap)){
				this.removeChild(_btnLabelBitmap);
				_btnLabelBitmap.destory();
			}
			_bitmap = null;
			_btnLabel = null;
			_btnLabelBitmap = null;
			_clickHandler = null;
			_labelColors = null;
			_labelMargin = null;
			_bitmapList = null;
		}

	}
}