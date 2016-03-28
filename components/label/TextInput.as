package components.label
{
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import components.BaseLabel;

	/**
	 *  输入框
	 *  @author JiaWei
	 */	
	public class TextInput extends BaseLabel
	{
		public function TextInput(text:String="")
		{
			super(text);
		}
		
		override protected function init():void
		{
			super.init();
			this.mouseChildren = true;
			this.width = 128;
			this.height = 22;
			selectable = true;
			_textField.type = TextFieldType.INPUT;
			_textField.autoSize = TextFieldAutoSize.NONE;
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			_textField.addEventListener(Event.CHANGE,onTextFieldChange);
			_textField.addEventListener(TextEvent.TEXT_INPUT,onTextFieldInput);
		}
		
		protected function onTextFieldChange(e:Event):void
		{
			text = _isHtml ? _textField.htmlText : _textField.text;
			e.stopPropagation();
		}
		
		protected function onTextFieldInput(e:TextEvent):void
		{
			dispatchEvent(e);
		}
		
		/**指示用户可以输入到控件的字符集*/
		public function get restrict():String{
			return _textField.restrict;
		}
		
		public function set restrict(value:String):void{
			_textField.restrict = value;
		}
		
		/**是否可编辑*/
		public function get editable():Boolean{
			return _textField.type == TextFieldType.INPUT;
		}
		
		public function set editable(value:Boolean):void{
			_textField.type == value ? TextFieldType.INPUT : TextFieldType.DYNAMIC;	
		}
		
		/**最多可包含的字符数*/
		public function get maxChars():int{
			return _textField.maxChars;
		}
		
		public function set maxChars(value:int):void{
			_textField.maxChars = value;
		}
		
	}
}