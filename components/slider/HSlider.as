package components.slider
{
	import components.BaseButton;
	import components.BaseImage;
	import components.BaseSlider;
	
	import configs.Direction;
	
	/**
	 *  水平滚动条
	 *  @author JiaWei
	 */	
	public class HSlider extends BaseSlider
	{
		public function HSlider(bg:BaseImage, bar:BaseButton, text:String=null)
		{
			super(bg, bar, text);
		}
		
		override protected function initDirection():void
		{
			super.initDirection();
			direction = Direction.HORIZONTAL;
		}
		
	}
}