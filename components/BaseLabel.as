package components
{
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import configs.UIConfig;
	
	import utils.FilterUtils;
	import utils.StringUtils;

	/**
	 *  文本基类
	 *  @author JiaWei
	 */	
	public class BaseLabel extends BaseSprite
	{
		private var reg:RegExp = new RegExp("\\n","g");
		protected var _text:String = "";
		protected var _textField:TextField;
		protected var _format:TextFormat;
		protected var _isHtml:Boolean;
		protected var _stroke:String;
		protected var _margin:Array;
		
		public function BaseLabel(text:String = "")
		{
			_text = text;
			_textField = new TextField();
			addChild(_textField);
			super();
		}
		
		override protected function init():void
		{
			super.init();
			mouseEnabled = mouseChildren = false;  //默认取消组件及子对象的鼠标事件，节省性能开销
			_format = _textField.defaultTextFormat;
			_format.font = UIConfig.fontName;
			_format.size = UIConfig.fontSize;
			_format.color = UIConfig.labelColor;
			_textField.selectable = false;
			_textField.embedFonts = TextFieldAutoSize.LEFT;
			_textField.embedFonts = UIConfig.embedFonts;
			_margin = UIConfig.labelMargin;
		}

		/**显示的文本*/
		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			if(_text != value){
				_text = value;
				_text = _text.replace(reg,"\n");
				changeText();
				sendEvent(Event.CHANGE);
			}
		}
		
		/**Html文本*/
		public function get htmlText():String{
			return _text;
		}
		
		public function set htmlText(value:String):void{
			_isHtml = true;
			text = value;
		}
		
		protected function changeText():void{
			_textField.defaultTextFormat = _format;
//			_isHtml ? _textField.htmlText = _text : _textField.text = _text;
			var s: String = "";
			if( !StringUtils.checkHtmlLab(_text)){
				_textField.htmlText = _text;
			}else{
				if(isHtml){
					s = "<FONT FACE='"+_format.font+"' COLOR='#" + uint(_format.color).toString(16) + "' SIZE ='" + _format.size + "'>";
					if ( _format.bold )
						s += "<B>" + _text + "</B></FONT>";
					else
						s += _text + "</FONT>";
					_textField.htmlText = s;
				}else{
					_textField.text = _text;
				}
			}
		}
		
		override protected function changeSize():void
		{
			
			super.changeSize();
		}
		
		
		/**是否是html格式*/
		public function get isHtml():Boolean
		{
			return _isHtml;
		}

		public function set isHtml(value:Boolean):void
		{
			_isHtml = value;
		}
		
		/**描边(格式:color,alpha,blurX,blurY,strength,quality)*/
		public function get stroke():String {
			return _stroke;
		}
		
		public function set stroke(value:String):void {
			if(value != ""){
				if (_stroke != value) {
					_stroke = value;
					FilterUtils.clearFilter(_textField, GlowFilter);
					if (Boolean(_stroke)) {
						var a:Array = StringUtils.fillArray(UIConfig.labelStroke, _stroke);
						FilterUtils.addFilter(_textField, new GlowFilter(a[0], a[1], a[2], a[3], a[4], a[5]));
					}
				}
			}else{
				FilterUtils.clearFilter(_textField, GlowFilter);
			}
		}
		
		/**是否是多行*/
		public function get multiline():Boolean {
			return _textField.multiline;
		}
		
		public function set multiline(value:Boolean):void {
			_textField.multiline = value;
		}
		
		/**是否是密码*/
		public function get asPassword():Boolean {
			return _textField.displayAsPassword;
		}
		
		public function set asPassword(value:Boolean):void {
			_textField.displayAsPassword = value;
		}
		
		/**宽高是否自适应*/
		public function get autoSize():String {
			return _textField.autoSize;
		}
		
		public function set autoSize(value:String):void {
			_textField.autoSize = value;
		}
		
		/**是否自动换行*/
		public function get wordWrap():Boolean {
			return _textField.wordWrap;
		}
		
		public function set wordWrap(value:Boolean):void {
			_textField.wordWrap = value;
		}
		
		/**是否可选*/
		public function get selectable():Boolean {
			return _textField.selectable;
		}
		
		public function set selectable(value:Boolean):void {
			_textField.selectable = value;
			this.mouseEnabled = value;
		}
		
		/**是否具有背景填充*/
		public function get background():Boolean {
			return _textField.background;
		}
		
		public function set background(value:Boolean):void {
			_textField.background = value;
		}
		
		/**文本字段背景的颜色*/
		public function get backgroundColor():uint {
			return _textField.backgroundColor;
		}
		
		public function set backgroundColor(value:uint):void {
			_textField.backgroundColor = value;
		}
		
		/**字体颜色*/
		public function get color():uint {
			return uint(_format.color);
		}
		
		public function set color(value:uint):void {
			_format.color = value;
			changeText();
		}
		
		
		/**字体类型*/
		public function get font():String {
			return _format.font;
		}
		
		public function set font(value:String):void {
			_format.font = value;
			changeText();
		}
		
		/**对齐方式*/
		public function get align():String {
			return _format.align;
		}
		
		public function set align(value:String):void {
			_format.align = value;
			changeText();
		}
		
		/**粗体类型*/
		public function get bold():Boolean {
			return _format.bold;
		}
		
		public function set bold(value:Boolean):void {
			_format.bold = value;
			changeText();
		}
		
		/**垂直间距*/
		public function get leading():Object {
			return _format.leading;
		}
		
		public function set leading(value:Object):void {
			_format.leading = value;
			changeText();
		}
		
		/**第一个字符的缩进*/
		public function get indent():int {
			return int(_format.indent);
		}
		
		public function set indent(value:int):void {
			_format.indent = value;
			changeText();
		}
		
		/**字体大小*/
		public function get size():int {
			return int(_format.size);
		}
		
		public function set size(value:int):void {
			_format.size = value;
			changeText();
		}
		
		/**下划线类型*/
		public function get underline():Boolean {
			return _format.underline;
		}
		
		public function set underline(value:Boolean):void {
			_format.underline = value;
			changeText();
		}
		
		/**字间距*/
		public function get letterSpacing():int {
			return int(_format.letterSpacing);
		}
		
		public function set letterSpacing(value:int):void {
			_format.letterSpacing = value;
			changeText();
		}
		
		
		/**边距(格式:左边距,上边距,右边距,下边距)*/
		public function get margin():String {
			return _margin.join(",");
		}
		
		public function set margin(value:String):void {
			_margin = StringUtils.fillArray(_margin, value, int);
			_textField.x = _margin[0];
			_textField.y = _margin[1];
			changeSize();
		}
		
		/**是否嵌入*/
		public function get embedFonts():Boolean {
			return _textField.embedFonts;
		}
		
		public function set embedFonts(value:Boolean):void {
			_textField.embedFonts = value;
		}
		
		/**格式*/
		public function get format():TextFormat {
			return _format;
		}
		
		public function set format(value:TextFormat):void {
			_format = value;
			changeSize();
		}
		
		/**文本控件实体*/
		public function get textField():TextField {
			return _textField;
		}
		
		/**将指定的字符串追加到文本的末尾*/
		public function appendText(newText:String):void {
			text += newText;
		}
		
		public function commitMeasure():void{
			changeText();
			changeSize();
		}
		
		override public function destory():void
		{
			super.destory();
			if(Boolean(_stroke)){
				FilterUtils.clearFilter(_textField, GlowFilter);
			}
			if(this.contains(_textField)){
				this.removeChild(_textField);
			}
			_textField = null;
			_format = null;
			_margin = null;
		}
		
	}
}