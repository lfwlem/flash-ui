package components.slider
{
	import components.BaseButton;
	import components.BaseImage;
	import components.BaseSlider;
	
	import configs.Direction;
	
	/**
	 *  垂直滑动条
	 *  @author JiaWei
	 */	
	public class VSlider extends BaseSlider
	{
		public function VSlider(bg:BaseImage, bar:BaseButton, text:String=null)
		{
			super(bg, bar, text);
		}		
		
		override protected function initDirection():void
		{
			super.initDirection();
			direction = Direction.VERTICAL;
		}
	}
}