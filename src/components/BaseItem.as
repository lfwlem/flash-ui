package components
{
	/**
	 *  网格对象基类
	 *  @author JiaWei
	 */	
	public class BaseItem extends BaseSprite
	{
		protected var _data:Object;
		protected var _image:BaseImage;
		
		public function BaseItem()
		{
			super();
		}

		/**
		 * 网格数据对象
		 * @return 
		 * 
		 */
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

		/**
		 * 格子图片 
		 * @return 
		 * 
		 */
		public function get image():BaseImage
		{
			return _image;
		}

		public function set image(value:BaseImage):void
		{
			if(_image && value){
				_image.removeAllChild();
				_image.remove();
				_image = null;
			}
			if(value){
				_image = value;
				addChild(_image);
			}
		}


	}
}