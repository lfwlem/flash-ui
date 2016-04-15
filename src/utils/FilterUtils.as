package utils
{
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;

	/**
	 *  滤镜工具集
	 *  @author JiaWei
	 */	
	public class FilterUtils
	{
		public static const grayFilter:ColorMatrixFilter = new ColorMatrixFilter([
			0.3086, 0.6094, 0.082, 0,
			0, 0.3086, 0.6094, 0.082, 
			0, 0, 0.3086, 0.6094, 
			0.082, 0, 0, 0,
			0, 0, 1, 0]);
		
		//原始的颜色矩阵,没做任何改变
		static public const OriginalColorFilter:ColorMatrixFilter = new ColorMatrixFilter([
			1, 0, 0, 0, 0,
			0, 1, 0, 0, 0,
			0, 0, 1, 0, 0,
			0, 0, 0, 1, 0]);
		
		/**添加滤镜*/
		public static function addFilter(target:DisplayObject, filter:BitmapFilter):void {
			var filters:Array = target.filters || [];
			filters.push(filter);
			target.filters = filters;
		}
		
		/**清除滤镜*/
		public static function clearFilter(target:DisplayObject, filterType:Class):void {
			var filters:Array = target.filters;
			if (filters != null && filters.length > 0) {
				for (var i:int = filters.length - 1; i > -1; i--) {
					var filter:* = filters[i];
					if (filter is filterType) {
						filters.splice(i, 1);
					}
				}
				target.filters = filters;
			}
		}
		
		/**让显示对象变成灰色*/
		public static function gray(traget:DisplayObject, isGray:Boolean = true):void {
			if (isGray) {
				addFilter(traget, grayFilter);
			} else {
				clearFilter(traget, ColorMatrixFilter);
			}
		}
		
		/**
		 * 根据颜色创建一个颜色滤镜 
		 * @param color
		 * @return 
		 * 
		 */		
		static public function createColorFilter(color:int):ColorMatrixFilter
		{
			var filter:ColorMatrixFilter = OriginalColorFilter.clone() as ColorMatrixFilter;
			
			var ma:Array = OriginalColorFilter.matrix.concat();
			//分离并得到颜色的偏移量
			ma[4] = ((color & 0xFF0000) >> 16) - 255;
			ma[9] = ((color & 0xFF00) >> 8) - 255;
			ma[14] = (color & 0xFF) - 255;
			
			filter.matrix = ma;
			
			return filter;
		}
		
		static public function createMB(color:int):Array
		{
			return [new GlowFilter(color, 1, 2, 2, 10)];
		}
		
		/**
		 *亮度(N取值为-255到255) 
		 * @param n
		 * @return 
		 * 
		 */
		static public function createBrightnessFilter(n:Number):ColorMatrixFilter
		{
			return new ColorMatrixFilter([1, 0, 0, 0, n, 0, 1, 0, 0, n, 0, 0, 1, 0, n, 0, 0, 0, 1, 0]);
		}
		
	}
}