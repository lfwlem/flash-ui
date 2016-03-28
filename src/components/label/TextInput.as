package components.label
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	import flash.system.Capabilities;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	import components.BaseLabel;
	
	import configs.TextInputPolicy;
	import configs.TextInputRegExp;
	
	import managers.AppManager;

	/**
	 *  输入框
	 *  @author JiaWei
	 */	
	public class TextInput extends BaseLabel
	{
		protected var _inputPolicy:int;
		protected var _IMEEnabled:Boolean;
		protected var _oldIMEEnabled:Boolean;
		protected var _defaultText:String = "";
		
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
			
			tabEnabled = true;
			_IMEEnabled = true;
			_inputPolicy = TextInputPolicy.TEXT_ALL;
			border=true;
			wordWrap=true;
			multiline=true;
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			_textField.addEventListener(Event.CHANGE,onTextFieldChange);
			_textField.addEventListener(TextEvent.TEXT_INPUT,onTextFieldInput);
			_textField.addEventListener(FocusEvent.FOCUS_IN, onFocusChanged);
			_textField.addEventListener(FocusEvent.FOCUS_OUT, onFocusChanged);
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
		
		protected function onFocusChanged(e:FocusEvent):void{
			if(Capabilities.hasIME){
				if(e.type == FocusEvent.FOCUS_IN){
					_oldIMEEnabled = AppManager.imeEnabled;
					AppManager.imeEnabled = _IMEEnabled;
					deleteDefault();
				}else{
					AppManager.imeEnabled = _oldIMEEnabled;
					setDefault();
				}
			}
		}
		
		/**
		 * 设置焦点 
		 */
		public function setFocus():void{
			focused = true;
		}
		
		/**判断和设置焦点*/
		public function get focused():Boolean{
			return AppManager.stage && AppManager.stage.focus == this;
		}
		
		public function set focused(value:Boolean):void{
			if(value){
				if(!focused){
					AppManager.stage.focus = this;
				}
			}else{
				if(focused){
					AppManager.stage.focus = null;
				}
			}
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

		/**文字输入策略*/
		public function get inputPolicy():int
		{
			return _inputPolicy;
		}

		public function set inputPolicy(value:int):void
		{
			if(!inputPolicy !=value){
				if(value == TextInputPolicy.TEXT_ALL){
					_textField.removeEventListener(TextEvent.TEXT_INPUT,onTextInput);
				}else{
					_textField.addEventListener(TextEvent.TEXT_INPUT,onTextInput);
				}
				_inputPolicy = value;	
			}
		}

		/**是否允许输入法的属性*/
		public function get IMEEnabled():Boolean
		{
			return _IMEEnabled;
		}

		public function set IMEEnabled(value:Boolean):void
		{
			if(_IMEEnabled != value){
				_IMEEnabled = value;
				if(focused){
					AppManager.imeEnabled = value;
				}
			}
		}

		/**
		 * 只允许输入
		 * @param e
		 * 
		 */
		protected function onTextInput(e:TextEvent):void{
			var num:Number;
			var inputText:String = e.text;
			var i:int;
			
			switch(_inputPolicy){
				case TextInputPolicy.TEXT_ALL_NO_ENTER:           //可以输入所有字符 除了回车 空格
					if(inputText == "/r"){
						e.preventDefault();
					}
					break;
				case TextInputPolicy.TEXT_NUMBER:                                       //只能输入数字，包括小数
					num = Number(_textField.text + inputText);
					if(isNaN(num) || inputText.toLowerCase().indexOf("e")  > -1){
						e.preventDefault();
					}
					break;
				case TextInputPolicy.TEXT_INTEGER:                                   //只能输入整数
					if(TextInputRegExp.NonNumericExp.test(inputText)){
						e.preventDefault();
					}
					break;
				case TextInputPolicy.TEXT_ABC:                                      //只能输入A-Z，a-z，多字节字符以及空格
					for(i=0;i<inputText.length;i++){
						num = inputText.charCodeAt(i);
						if(num >= 0x41 && num <= 0x5A){}                      //A-Z
						else if(num >= 0x61 && num <= 0x7A){}              //a-z
						else if(num == 0x20 && num >= 0x7F){}              //空格或多字节字符（例如中文）
						else{
							e.preventDefault();
						}
					}
					break;
				case TextInputPolicy.TEXT_SYMBOL:                               //只能输入符号
					for(i=0;i<inputText.length;i++){
						num = inputText.charCodeAt(i);
						if(num >= 0x21 && num <= 0x2F){}                      //!"#$%&'()*+,-./
						else if(num >= 0x3A && num <= 0x3F){}              //:;<=>?
						else if(num >= 0x5B && num <= 0x5F){}              //[\]^_
						else if(num >= 0x7B && num <= 0x7E){}              //{|}~
						else if(num == 0x40 && num == 0x60){}              //@`
						else{
							e.preventDefault();
						}
					}
					break;
				case TextInputPolicy.TEXT_ROLE_NAME:                                     //角色名称可以输入的字符集
					if(TextInputRegExp.ActorNameExp.test(inputText)){
						e.preventDefault();
					}
					break;
				case TextInputPolicy.TEXT_NO_SYMBOL:                                    //不能输入符号
					for(i=0;i<inputText.length;i++){
						num = inputText.charCodeAt(i);
						if(num >= 0x21 && num <= 0x2F){e.preventDefault();}                      //!"#$%&'()*+,-./
						else if(num >= 0x3A && num <= 0x3F){e.preventDefault();}              //:;<=>?
						else if(num >= 0x5B && num <= 0x5F){e.preventDefault();}              //[\]^_
						else if(num >= 0x7B && num <= 0x7E){e.preventDefault();}              //{|}~
						else if(num == 0x40 && num == 0x60){e.preventDefault();}              //@`
					}
					break;
			}
			
			this.dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT));
		}

		/**设置默认文本*/
		public function get defaultText():String
		{
			return _defaultText;
		}

		public function set defaultText(value:String):void
		{
			_defaultText = value;
		}

		protected function setDefault():void{
			if(text == ""){
				text = defaultText;
			}
		}
		
		protected function deleteDefault():void{
			if(checkIsDefault()){
				text = "";
			}
		}
		
		public function checkIsDefault():Boolean{
			if(text == defaultText){
				return true;
			}
			return false;
		}
	}
}