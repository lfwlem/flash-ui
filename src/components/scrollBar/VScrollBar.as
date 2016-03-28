package components.scrollBar
{
	import components.BaseButton;
	import components.BaseImage;
	import components.BaseScrollBar;
	
	import configs.Direction;
	
	/**
	 *  垂直滚动条
	 *  @author JiaWei
	 */	
	public class VScrollBar extends BaseScrollBar
	{
		public function VScrollBar(bg:BaseImage, bar:BaseButton, up:BaseButton, down:BaseButton)
		{
			super(bg, bar, up, down);			
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