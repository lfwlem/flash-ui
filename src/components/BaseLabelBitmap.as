package components
{
	import configs.UIConfig;
	
	import utils.LabelUtils;

	/**
	 *  文字图片基类 
	 *  @author JiaWei
	 */	
	public class BaseLabelBitmap extends BaseBitmap
	{
		protected var _text:String;
		protected var _grandientTextFilter:Array;
		protected var _grandientTextColor:Array;
		protected var _grandientTextBlod:Boolean;       //是否是粗体
		protected var _isHtml:Boolean;
		
		protected var _grandientTextSize:int;
		protected var _grandientTextType:String;      //渐变类型   GradientType.LINEAR 或 GradientType.RADIAL。
		protected var _grandientTextRotate:int;  //旋转量（以弧度为单位）。
		protected var _grandientTextSpreadMethod:String;   //渐变方法  SpreadMethod.PAD、SpreadMethod.REFLECT 或 SpreadMethod.REPEAT。

		
		/**
		 * 带有渐变颜色的文字
		 * @param text （可为html文本）
		 * @param filter
		 * @param color
		 * @param blod
		 * */
		public function BaseLabelBitmap(text:String,color:Array = null,filter:Array=null,blod:Boolean=false)
		{
			this.text = text;
			_grandientTextFilter = [];
			_grandientTextColor = [];
			_grandientTextBlod = UIConfig.grandientTextBlod;
			_grandientTextSize = UIConfig.fontSize;
			_grandientTextType = UIConfig.grandientTextType;
			_grandientTextRotate = UIConfig.grandientTextRotate;
			_grandientTextSpreadMethod = UIConfig.grandientTextSpreadMethod;
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
				changeText();
			}
			
		}

		/**滤镜*/
		public function get grandientTextFilter():Array
		{
			return _grandientTextFilter;
		}

		public function set grandientTextFilter(value:Array):void
		{
			if(_grandientTextFilter != value){
				_grandientTextFilter = value;
				changeText();
			}
		}

		/**文本颜色*/
		public function get grandientTextColor():Array
		{
			return _grandientTextColor;
		}

		public function set grandientTextColor(value:Array):void
		{
			if(_grandientTextColor != value){
				_grandientTextColor = value;
				changeText();
			}
		}

		/**是否是粗体*/
		public function get grandientTextBlod():Boolean
		{
			return _grandientTextBlod;
		}

		public function set grandientTextBlod(value:Boolean):void
		{
			if(_grandientTextBlod != value){
				_grandientTextBlod = value;
				changeText();
			}
		}

		protected function changeText():void{
			if (!Boolean(_text))
			{
				if (bitmapData)
					bitmapData.dispose();
				bitmapData = null;
				return;
			}
			
			if(_isHtml){
				this.bitmapData = LabelUtils.createHtmlText(_text, _grandientTextFilter);
			}else{
				if(grandientTextColor){
					switch(grandientTextColor.length){
						case 1:
							this.bitmapData = LabelUtils.createText(_text, (_grandientTextColor[0] as uint), _grandientTextBlod, _grandientTextFilter,_grandientTextSize);
							break;
						case 2:
							bitmapData = LabelUtils.createGradientText(_text,_grandientTextFilter,_grandientTextColor,_grandientTextRotate,_grandientTextType,_grandientTextSpreadMethod,_grandientTextBlod);
							break;
						case 4:
							bitmapData = LabelUtils.createGradientText2(_text,_grandientTextFilter,_grandientTextColor,_grandientTextRotate,_grandientTextType,_grandientTextSpreadMethod,_grandientTextBlod);
							break;
					}
				}	
			}
		}

		/**是否是html*/
		public function get isHtml():Boolean
		{
			return _isHtml;
		}

		public function set isHtml(value:Boolean):void
		{
			if(_isHtml != value){
				_isHtml = value;
				changeText();
			}
		}

		/**显示的文本字体大小*/
		public function get grandientTextSize():int
		{
			return _grandientTextSize;
		}

		public function set grandientTextSize(value:int):void
		{
			if(_grandientTextSize != value){
				_grandientTextSize = value;	
				changeText();
			}
		}

		/**渐变类型   GradientType.LINEAR 或 GradientType.RADIAL*/
		public function get grandientTextType():String
		{
			return _grandientTextType;
		}

		public function set grandientTextType(value:String):void
		{
			if(_grandientTextType != value){
				_grandientTextType = value;
				changeText();
			}
		}

		/**旋转量（以弧度为单位）*/
		public function get grandientTextRotate():int
		{
			return _grandientTextRotate;
		}

		public function set grandientTextRotate(value:int):void
		{
			if(_grandientTextRotate != value){
				_grandientTextRotate = value;
				changeText();
			}
		}

		/**渐变方法  SpreadMethod.PAD、SpreadMethod.REFLECT 或 SpreadMethod.REPEAT*/
		public function get grandientTextSpreadMethod():String
		{
			return _grandientTextSpreadMethod;
		}

		public function set grandientTextSpreadMethod(value:String):void
		{
			if(_grandientTextSpreadMethod != value){
				_grandientTextSpreadMethod = value;
				changeText();
			}
		}


	}
}