package utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.ByteArray;

	/**
	 *  工具集
	 *  @author JiaWei
	 */	
	public class OtherUtils
	{
		/**读取AMF*/
		public static function readAMF(bytes:ByteArray):Object {
			if (bytes && bytes.length > 0 && bytes.readByte() == 0x11) {
				return bytes.readObject();
			}
			return null;
		}
		
		/**写入AMF*/
		public static function writeAMF(obj:Object):ByteArray {
			var bytes:ByteArray = new ByteArray();
			bytes.writeByte(0x11);
			bytes.writeObject(obj);
			return bytes;
		}
		
		/**clone副本*/
		public static function clone(source:*):* {
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(source);
			bytes.position = 0;
			return bytes.readObject();
		}
		
		/**
		 * 判断组件是否可处理鼠标事件
		 * 如果组件mouseEnabled为false或其容器的mouseChildren为false则返回视组件为不可处理鼠标事件状态
		 * @param control
		 * @return 
		 * 
		 */
		static public function controlMouseEnabled(control: InteractiveObject): Boolean
		{
			var container: DisplayObjectContainer;
			
			if ( !control.mouseEnabled )
				return false;
			
			control = control.parent;
			while ( control )
			{
				container = control as DisplayObjectContainer;
				if ( container && !container.mouseChildren )
					return false;
				control = control.parent;
			}
			return true;
		}
		/**
		 * 判断stage中是否有激活的文本输入组件 
		 * @param stage
		 * @return 
		 * 
		 */
		static public function hasInputFocused(stage: Stage): Boolean
		{
			if (!stage)
				return false;
			var tf: TextField = stage.focus as TextField;
			if (!tf)
				return false;
			if (tf.type != TextFieldType.INPUT)
				return false;
			return true;
		}
		/**
		 * 判断 child是否是parent的子组件或孙组件 
		 * @param parent
		 * @param child
		 * @return 
		 * 
		 */
		static public function isDeepChildren(parent: DisplayObjectContainer, child: DisplayObject): Boolean
		{
			child = child.parent;
			while ( child )
			{
				if ( child == parent )
					return true;
				child = child.parent;
			}
			return false;
		}
		
	}
}