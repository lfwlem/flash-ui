package components.scrollBar
{
	import components.BaseButton;
	import components.BaseImage;
	import components.BaseScrollBar;
	
	import configs.Direction;
	
	/**
	 *  水平滚动条
	 *  @author JiaWei
	 */	
	public class HScrollBar extends BaseScrollBar
	{
		public function HScrollBar(bg:BaseImage, bar:BaseButton, up:BaseButton, down:BaseButton)
		{
			super(bg, bar, up, down);
			if(_slider){
				_slider.direction = Direction.VERTICAL;
			}
		}
		
		override protected function init():void
		{
			if(_slider){
				_slider.direction = Direction.VERTICAL;
			}
			super.init();
		}
		
	}
}