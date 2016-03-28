package components.button
{
	import flash.text.TextFieldAutoSize;
	
	import configs.UIConfig;
	import components.BaseButton;

	/**
	 *  文本按钮
	 *  @author JiaWei
	 */	
	public class LinkLabelButton extends BaseButton
	{
		public function LinkLabelButton(_label:String="")
		{
			super([], _label, 1);
		}
		
		override protected function init():void
		{
			super.init();
			_labelColors = UIConfig.linkLabelColors;
			_autoSize = false;
			buttonMode = true;
			_btnLabel.underline = true;
			_btnLabel.autoSize = TextFieldAutoSize.LEFT;
		}
		
		
	}
}