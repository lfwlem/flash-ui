package components
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 位图的九宫格裁剪器 
	 * @author JiaWei
	 * 
	 */
	public class NineGridBitmapData
	{
		/**
		 * 分割后的九个位置的位图数据
		 * 
		 */
		private var m_TopLeftData: BitmapData;
		private var m_TopData: BitmapData;
		private var m_TopRightData: BitmapData;
		private var m_LeftData: BitmapData;
		private var m_CenterData: BitmapData;
		private var m_RightData: BitmapData;
		private var m_BottomLeftData: BitmapData;
		private var m_BottomData: BitmapData;
		private var m_BottomRightData: BitmapData;
		/**
		 * 原始位图的数据
		 * 
		 */
		private var m_BitmapData: BitmapData;
		
		/**
		 * 分割位置
		 * 
		 */
		private var m_nLeftSpace: int;//左侧的宽度
		private var m_nTopSpace: int;//顶部的高度
		private var m_nRightSpace: int;//右侧的宽度
		private var m_nBottomSpace: int;//底部的高度
		
		private var m_boSmoothing: Boolean;//拉伸是否平滑
		
		public function NineGridBitmapData(bitmapData: BitmapData = null, leftSpace: int = 1, topSpace: int = 1, rightSpace: int = 1, scaleBottom: int = 1, smoothing: Boolean = false)
		{
			m_BitmapData = bitmapData;
			m_boSmoothing = smoothing;
			if ( bitmapData )
			{
				spliteBitmap(bitmapData, leftSpace, topSpace, rightSpace, scaleBottom);
			}
		}
		public function get bitmapData(): BitmapData
		{
			return m_BitmapData;
		}
		/**
		 * 设置位图数据  
		 * @param BmData
		 * 
		 */
		public function set bitmapData(BmData: BitmapData): void
		{
			if ( !BmData )
				throw new ArgumentError("位图数据不能为空");
			var bmWidth: int = BmData.width;
			var bmHeight: int = BmData.height;
			if ( bmWidth < 3 || bmHeight < 3 )
				throw new ArgumentError("无效的位图数据，最为九宫格分割图使用的位图数据，其宽度和高度必须大于等于3。");
				
			var scaleLeft: int = m_nLeftSpace;
			var scaleTop: int = m_nTopSpace;
			var scaleRight: int = m_nRightSpace;//m_BitmapData.width - m_nRightSpace;
			var scaleBottom: int = m_nBottomSpace;//m_BitmapData.height - m_nBottomSpace;
			
			//没有设定过分割数据则设置默认值
			if ( !scaleLeft )
			{
				scaleLeft = 1;
				scaleTop = 1;
				scaleRight = 1;
				scaleBottom = 1;
			}
			//设定过分割数据则检查是否仍然有效
			else
			{
				if ( bmWidth - scaleRight >= scaleLeft )
				{
					scaleLeft = 1;
					scaleRight = 1;
				}
				if ( bmHeight - scaleBottom >= scaleTop )
				{
					scaleTop = 1;
					scaleBottom = 1;
				}
			}
			spliteBitmap(BmData, scaleLeft, scaleTop, scaleRight, scaleBottom); 
		}
		/**
		 * 覆盖父类设置九宫格坐标的方法
		 * @param innerRectangle
		 * 
		 */
		public function get scale9Grid(): Rectangle
		{
			if ( !m_nLeftSpace )
				return null;
			return new Rectangle(m_nLeftSpace - 1, m_nTopSpace - 1, 
				m_BitmapData.width - m_nRightSpace, m_BitmapData.height - m_nBottomSpace)
		}
		public function set scale9Grid(innerRectangle:Rectangle):void
		{
			//如果已经具有位图数据则检查有效性
			if ( !m_BitmapData )
				throw new Error("尚未设置bitmapData");
			spliteBitmap(bitmapData, innerRectangle.x + 1, innerRectangle.y + 1, 
				m_BitmapData.width - innerRectangle.x - 1 - innerRectangle.width, 
				m_BitmapData.height - innerRectangle.y - 1 - innerRectangle.height);
		}
		/**
		 * 各个分割点的位图数据 
		 * @return 
		 * 
		 */
		public function get topLeft(): BitmapData
		{
			return m_TopLeftData;
		}
		public function get top(): BitmapData
		{
			return m_TopData;
		}
		public function get topRight(): BitmapData
		{
			return m_TopRightData;
		}
		public function get left(): BitmapData
		{
			return m_LeftData;
		}
		public function get center(): BitmapData
		{
			return m_CenterData;
		}
		public function get right(): BitmapData
		{
			return m_RightData;
		}
		public function get bottomLeft(): BitmapData
		{
			return m_BottomLeftData;
		}
		public function get bottom(): BitmapData
		{
			return m_BottomData;
		}
		public function get bottomRight(): BitmapData
		{
			return m_BottomRightData;
		}
		/**
		 * 分割点坐标的访问器 
		 * @return 
		 * 
		 */
		public function get leftSpace(): int
		{
			return m_nLeftSpace;
		}
		public function get topSpace(): int
		{
			return m_nTopSpace;
		}
		public function get rightSpace(): int
		{
			return m_nRightSpace;
		}
		public function get bottomSpace(): int
		{
			return m_nBottomSpace;
		}
		/**
		 * 拉伸时是否进行平滑处理
		 * @return 
		 * 
		 */		
		public function get smoothing():Boolean
		{
			return m_boSmoothing;
		}
		/**
		 * 生成指定大小的位图数据
		 * @return 
		 * 
		 */
		public function generateBitmapData(width: int, height: int): BitmapData
		{
			var Result: BitmapData = new BitmapData(width, height, true, 0);
			
			var src: Rectangle = new Rectangle;
			var dest: Point = new Point;
			var mt: Matrix = new Matrix();
			var bmData: BitmapData = m_BitmapData;
			var bmWidth: int = bmData.width;
			var bmHeight: int = bmData.height;
			var bmHWidth: int = bmWidth - m_nLeftSpace - m_nRightSpace;
			var bmVHeight: int = bmHeight - m_nTopSpace - m_nBottomSpace;
			var topScale: Number = (width - m_nLeftSpace - m_nRightSpace)/bmHWidth;
			var leftScale: Number = (height - m_nTopSpace - m_nBottomSpace)/bmVHeight;
			
			//top;
			mt.tx = m_nLeftSpace;
			mt.a = topScale;
			Result.draw(m_TopData, mt, null, null, null, m_boSmoothing);
			
			//bottom
			mt.ty = height - m_nBottomSpace;
			Result.draw(m_BottomData, mt, null, null, null, m_boSmoothing);
			
			//left
			mt.tx = 0;
			mt.ty = m_nTopSpace;
			mt.a = 1;
			mt.d = leftScale;
			Result.draw(m_LeftData, mt, null, null, null, m_boSmoothing);
			
			//right
			mt.tx = width - m_nRightSpace;
			Result.draw(m_RightData, mt, null, null, null, m_boSmoothing);
			
			//center
			mt.tx = m_nLeftSpace;
			mt.ty = m_nTopSpace;
			mt.a = topScale;
			mt.d = leftScale;
			Result.draw(m_CenterData, mt, null, null, null, m_boSmoothing);
			
			//top-left
			src.width = m_nLeftSpace;
			src.height = m_nTopSpace;
			Result.copyPixels(bmData, src, dest);
			
			//top-right
			src.x = bmWidth - m_nRightSpace;
			src.width = m_nRightSpace;
			dest.x = width - m_nRightSpace;
			Result.copyPixels(bmData, src, dest);
			
			//bottom-left
			src.x = 0;
			src.y = bmHeight - m_nBottomSpace;
			src.width = m_nLeftSpace;
			src.height = m_nBottomSpace;
			dest.x = 0;
			dest.y = height - m_nBottomSpace;
			Result.copyPixels(bmData, src, dest);
			
			//bottom-right
			src.x = bmWidth - m_nRightSpace;
			dest.x = width - m_nRightSpace;
			src.width = m_nRightSpace;
			Result.copyPixels(bmData, src, dest);
			
			return Result;
		}
		/**
		 * 按照分割点坐标分割9张位图数据 
		 * @param bitmapData
		 * @param scaleLeft
		 * @param scaleTop
		 * @param scaleRight
		 * @param scaleBottom
		 * 
		 */
		private function spliteBitmap(bitmapData:BitmapData, leftSpace: int, topSpace: int, rightSpace: int, bottomSpace: int): void
		{
			//检查分割参数的有效性
			checkScaleArguments(bitmapData.width, bitmapData.height, leftSpace, topSpace, rightSpace, bottomSpace);
			
			var nCenterWidth: int = bitmapData.width - leftSpace - rightSpace;
			var nCenterHeight: int = bitmapData.height - topSpace - bottomSpace;
			//生成9个位置的位图
			m_TopLeftData = copyBitmapData(bitmapData, 0, 0, leftSpace, topSpace);
			m_TopData = copyBitmapData(bitmapData, leftSpace, 0, nCenterWidth, topSpace);
			m_TopRightData = copyBitmapData(bitmapData, bitmapData.width - rightSpace, 0, rightSpace, topSpace);
			
			m_LeftData = copyBitmapData(bitmapData, 0, topSpace, leftSpace, nCenterHeight);
			m_CenterData = copyBitmapData(bitmapData, leftSpace, topSpace, nCenterWidth, nCenterHeight);
			m_RightData = copyBitmapData(bitmapData, bitmapData.width - rightSpace, topSpace, rightSpace, nCenterHeight);
			
			m_BottomLeftData = copyBitmapData(bitmapData, 0, bitmapData.height - bottomSpace, leftSpace, bottomSpace);
			m_BottomData = copyBitmapData(bitmapData, leftSpace, bitmapData.height - bottomSpace, nCenterWidth, bottomSpace);
			m_BottomRightData = copyBitmapData(bitmapData, bitmapData.width - rightSpace, bitmapData.height - bottomSpace, rightSpace, bottomSpace);
			
			m_BitmapData = bitmapData;
			//保存分割坐标
			m_nLeftSpace = leftSpace;
			m_nTopSpace = topSpace;
			m_nRightSpace = rightSpace;
			m_nBottomSpace = bottomSpace;
		}
		/**
		 * 检查指定的九宫格分割参数是否有效 
		 * 如果参数无效则会抛出异常
		 * @param width
		 * @param height
		 * @param scale9GridLeft
		 * @param scale9GridTop
		 * @param scale9Right
		 * @param scale9Bottom
		 * 
		 */
		private function checkScaleArguments(width: int, height: int, leftSpace: int, topSpace: int, rightSpace: int, bottomSpace: int):void
		{
			if ( leftSpace <= 0 || topSpace <= 0 || rightSpace <= 0 || bottomSpace <= 0
				|| leftSpace + rightSpace > width || topSpace + bottomSpace > height )
			{
				throw new ArgumentError("无效的九宫格分割参数");
			}
		}
		/**
		 * 从bitmapData拷贝一个矩形区域并生成新的位图 
		 * @param bitmapData
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @return 
		 * 
		 */
		private function copyBitmapData(bitmapData: BitmapData, x: int, y: int, width: int, height: int): BitmapData
		{
			var newBitmapData: BitmapData = new BitmapData(width, height);
			newBitmapData.copyPixels(bitmapData, new Rectangle(x, y, width, height), new Point(0, 0));
			return newBitmapData;
		}
	}
}