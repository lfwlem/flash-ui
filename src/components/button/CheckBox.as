package components.button
{
	import flash.text.TextFieldAutoSize;
	import components.BaseButton;

	/**
	 *  多选按钮
	 *  @author JiaWei
	 */	
	public class CheckBox extends BaseButton
	{
		public function CheckBox(_list:Array, _label:String="", _btnLabelType:int=1)
		{
			super(_list, _label, _btnLabelType);
		}
		
		override protected function init():void
		{
			super.init();
			_toggle = true;
			_autoSize = false;
			_btnLabel.autoSize = TextFieldAutoSize.LEFT;
		}
		
		override protected function changeLabelSize():void
		{
			super.changeLabelSize();
			_btnLabel.x = _bitmap.width + _labelMargin[0];
			_btnLabel.y = (_bitmap.width - _btnLabel.height) * 0.5 + _labelMargin[1];
		}
		
		
	}
}