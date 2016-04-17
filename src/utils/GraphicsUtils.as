package utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 *  图形工具集
	 *  @author JiaWei
	 */	
	public class GraphicsUtils
	{
		static public var Mat:Matrix = new Matrix();//公共转换矩阵，用于优化
		static public var SourceRect:Rectangle = new Rectangle();//源矩形
		static public var DestPoint:Point = new Point();//目标点
		static public var ClrMatFilter:ColorMatrixFilter = new ColorMatrixFilter();//颜色矩阵滤镜
		//颜色转换矩阵
		static public var MatArr:Array = [
			1, 0, 0, 0, 0,
			0, 1, 0, 0, 0,
			0, 0, 1, 0, 0,
			0, 0, 0, 1, 0];
		
		/**
		 * 重置转换矩阵
		 * 
		 */		
		static public function resetMatrix():void
		{
			Mat.a = Mat.d = 1;
			Mat.b = Mat.c = 0;
			Mat.tx = Mat.ty = 0;
		}
		/**
		 * 重置颜色转换矩阵
		 * 
		 */		
		static public function resetMatrixArray():void
		{
			var w:int = 5;
			var h:int = 4;
			for(var i:int = 0; i < h; i++)
			{
				for(var j:int = 0; j < w; j++)
				{
					MatArr[i * w + j] = (i == j) ? 1 : 0;
				}
			}
		}
		
		/**
		 * 五角星
		 * 画出角度不断递增并且半径交替变化的一系列线条，就可以构成一个五角星
		 * 通过设置形状半径，可以改变星星的形状，比如当值和起始半径相等时，星星变成了一个等边形
		 * 形状半径还可以改变星星的尺寸，比如当值等于起始半径2倍时，星星就会比原来大一倍
		 * @param radius 起始半径，即中心点到起始点的距离
		 * @param radius2 形状半径
		 * @param lineColor 线条颜色
		 * @param fillColor 填充颜色
		 * @param degrees 起始角度，可以改变星星的朝向
		 * @return 
		 * 
		 */		
		static public function star(radius:Number, radius2:Number = NaN, lineColor:uint = 0xFFFF00, fillColor:uint = 0xFFFF00, degrees:Number = -90):BitmapData
		{
			//获取形状半径,默认为:起始半径/2
			if(!radius2) radius2 = radius / 2;
			//计算起始角度
			var startAngle:Number = degrees * Math.PI / 180;
			
			//创建一个临时Shape
			var shape:Shape = new Shape();
			//			shape.graphics.lineStyle(0, lineColor);
			shape.graphics.beginFill(fillColor);
			//设置起点
			shape.graphics.moveTo(Math.cos(startAngle) * radius, Math.sin(startAngle) * radius);
			//画10条线
			var r:Number;
			var angle:Number;
			for(var i:int = 1; i < 11; i++)
			{
				r = i % 2 > 0 ? radius2 : radius;
				angle = Math.PI * 2 / 10 * i + startAngle;
				shape.graphics.lineTo(Math.cos(angle) * r, Math.sin(angle) * r);
			}
			
			//计算星星的半径
			r = Math.max(radius, radius2);
			//设置矩阵
			resetMatrix();
			Mat.tx = Mat.ty = r;
			//创建一个和星星大小一致的BitmapData，把星星填充进去
			var bmpd:BitmapData = new BitmapData(r * 2, r * 2, true, 0);
			bmpd.draw(shape, Mat);
			
			return bmpd;
		}
		/**
		 * 以bmpd填充一个网格
		 * @param bmpd 源位图
		 * @param rows 行数
		 * @param cols 列数
		 * @param rowSpace 行距
		 * @param colSpace 列距
		 * @param scoopPoints 要挖空的点(不填充)
		 * @return 
		 * 
		 */		
		static public function drawGrid(bmpd:BitmapData, rows:int, cols:int, rowSpace:int = 0, colSpace:int = 0, scoopPoints:Array = null):BitmapData
		{
			resetMatrix();
			var mat:Matrix = Mat;
			
			var cw:Number = bmpd.width;
			var ch:Number = bmpd.height;
			var w:int = (cw + colSpace) * cols - colSpace;
			var h:int = (ch + rowSpace) * rows - rowSpace;
			var targetBmpd:BitmapData = new BitmapData(w, h, true, 0);
			for(var r:int = 0; r < rows; r++)
			{
				mat.ty = r * (ch + rowSpace);
				for(var c:int = 0; c < cols; c++)
				{
					if(scoopPoints)
					{
						if(scoopPoints.indexOf(r*cols+c) < 0)
						{
							mat.tx = c * (cw + colSpace);
							targetBmpd.draw(bmpd, mat);
						}
					}
					else
					{
						mat.tx = c * (cw + colSpace);
						targetBmpd.draw(bmpd, mat);
					}
				}
			}
			return targetBmpd;
		}
		
		
		/**
		 * 以bmpd填充一个网格
		 * @param bmpds 源位图
		 * @param rows 行数
		 * @param cols 列数
		 * @param rowSpace 行距
		 * @param colSpace 列距
		 * @param scoopPoints 要挖空的点(不填充)
		 * @return 
		 * 
		 */		
		static public function drawGridByOtherBmpd(bmpds:Array, rows:int, cols:int, rowSpace:int = 0, colSpace:int = 0, scoopPoints:Array = null):BitmapData
		{
			resetMatrix();
			var mat:Matrix = Mat;
			
			var cw:Number = bmpds[0].width;
			var ch:Number = bmpds[0].height;
			var w:int = (cw + colSpace) * cols - colSpace;
			var h:int = (ch + rowSpace) * rows - rowSpace;
			var targetBmpd:BitmapData = new BitmapData(w, h, true, 0);
			for(var r:int = 0; r < rows; r++)
			{
				mat.ty = r * (ch + rowSpace);
				for(var c:int = 0; c < cols; c++)
				{
					if(scoopPoints)
					{
						if(scoopPoints.indexOf(r*cols+c) < 0)
						{
							mat.tx = c * (cw + colSpace);
							targetBmpd.draw(bmpds[r], mat);
						}
					}
					else
					{
						mat.tx = c * (cw + colSpace);
						targetBmpd.draw(bmpds[r], mat);
					}
				}
			}
			return targetBmpd;
		}
		
		
		/**
		 * 从源位图数据生成高亮位图数据
		 * @param srcBmpd
		 * @return 
		 * 
		 */		
		static public function createOverStateBmpd(srcBmpd:BitmapData):BitmapData
		{
			return createStateBmpd(srcBmpd, 60);
		}
		/**
		 * 从源位图数据生成灰暗位图数据
		 * @param srcBmpd
		 * @return 
		 * 
		 */		
		static public function createDownStateBmpd(srcBmpd:BitmapData):BitmapData
		{
			return createStateBmpd(srcBmpd, -60);
		}
		/**
		 * 从源位图数据生成灰暗位图数据  (不可用状态)
		 * @param srcBmpd
		 * @return 
		 * 
		 */		
		static public function createDisableStateBmpd(srcBmpd:BitmapData):BitmapData
		{
			return createStateBmpd(srcBmpd,0,true);
		}
		
		/**
		 * 从源位图数据和指定的亮度生成新的位图数据
		 * @param srcBmpd
		 * @param brightness
		 * @return 
		 * 
		 */		
		static public function createStateBmpd(srcBmpd:BitmapData, brightness:Number,disable:Boolean = false):BitmapData
		{
			SourceRect.x = SourceRect.y = 0;
			SourceRect.width = srcBmpd.width;
			SourceRect.height = srcBmpd.height;
			
			var mat:ColorMatrixFilter;
			if(!disable)
			{
				resetMatrixArray();
				MatArr[4] = MatArr[9] = MatArr[14] = brightness;
				ClrMatFilter.matrix = MatArr;
				mat = ClrMatFilter;
			}
			else
			{
				mat = FilterUtils.grayFilter;
			}
			
			var bmpd:BitmapData = new BitmapData(srcBmpd.width, srcBmpd.height, srcBmpd.transparent, 0);
			bmpd.applyFilter(srcBmpd, SourceRect, DestPoint, mat);
			
			return bmpd;
		}
		/**
		 * 从源位图数据生成平移位图数据
		 * @param srcBmpd
		 * @param dx
		 * @param dy
		 * @return 
		 * 
		 */		
		static public function createTranslateBmpd(srcBmpd:BitmapData, dx:Number=0, dy:Number=0):BitmapData
		{
			resetMatrix();
			Mat.translate(dx, dy);
			
			var bmpd:BitmapData = new BitmapData(srcBmpd.width + dx, srcBmpd.height + dy, srcBmpd.transparent, 0);
			bmpd.draw(srcBmpd, Mat);
			
			return bmpd;
		}
		
		/**
		 * 得到圆形的点 
		 * @param r
		 * @param   pointGap    创建点的间隔
		 */		
		static public function getCircelPoint(r:int,offsetX:int = 0,offsetY:int = 0,pointGap:int = 1,start:int = 0,end:int = 360):Vector.<Point>
		{
			var pointList:Vector.<Point> = new Vector.<Point>();
			var x1:int;
			var y1:int;
			var p:Point;
			var nextPoint:int = start;
			for(var i:int = start;i<end;i++)
			{
				if(nextPoint == i)
				{
					x1 = Math.cos(i*Math.PI/180)*r + r + offsetX;
					y1 = Math.sin(i*Math.PI/180)*r + r + offsetY;
					
					p = new Point(x1,y1);
					pointList.push(p);
					nextPoint += pointGap;
				}
			}
			
			return pointList;
		}
		
		/**
		 *绘制相反的位图数据 
		 * @param bmd
		 * @param scalex
		 * @param scaley
		 * @return 
		 * 
		 */		
		static public function createContraryBmd(bmd:BitmapData,scalex:Number,scaley:Number):BitmapData
		{
			var cbmd:BitmapData = new BitmapData(bmd.width,bmd.height,true,0);
			var bmp:Bitmap = new Bitmap(bmd);
			bmp.scaleX = scalex;
			bmp.scaleY = scaley;
			cbmd.draw(bmp);
			return cbmd;
		}
	}
}