package components.button
{
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import components.BaseButton;

	/**
	 *  单选按钮
	 *  @author JiaWei
	 */	
	public class RadioButton extends BaseButton
	{
		protected var _value:Object;
		
		public function RadioButton(_list:Array, _label:String="")
		{
			super(_list, _label, 1);
		}		
		
		override protected function init():void
		{
			super.init();
			_toggle = false;
			_autoSize = false;
			_btnLabel.autoSize = TextFieldAutoSize.LEFT;
			addEventListener(MouseEvent.CLICK,onMouseClick);
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			addEventListener(MouseEvent.CLICK,onMouseClick);
		}
		
		protected function onMouseClick(e:MouseEvent):void
		{
			_selected = true;
		}		
		
		override protected function changeLabelSize():void
		{
			super.changeLabelSize();
			_btnLabel.x = _bitmap.width + _labelMargin[0];
			_btnLabel.y = (_bitmap.width - _btnLabel.height) * 0.5 + _labelMargin[1];
		}
		
		public function get value():Object
		{
			return _value==null? label : value;
		}
		
		public function set value(value:Object):void
		{
			_value = value;
		}
		
		override public function destory():void
		{
			super.destory();
			value = null;
		}
		
	}
}