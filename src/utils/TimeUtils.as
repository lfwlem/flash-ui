package utils
{
	import managers.LangManager;

	/**
	 *  时间工具集
	 *  @author JiaWei
	 */	
	public class TimeUtils
	{
		
		/**
		 * 格式化毫秒数显示为:?分?.???秒
		 * @param tick
		 * @param showType 显示类型 由低到高,每位分别表示MS S M H D的显示, 为0不显示对应值, 默认只不显示MS
		 * @return 
		 * 
		 */
		static private const MinPerMilSec: Number = 60 * 1000;
		static private const HourPerMilSec: Number = 60 * 60 * 1000;
		static private const DayPerMilSec: Number = 24 * 60 * 60 * 1000;
		static public function tickCountToStr(tick: Number, showType: int = 0x1e): String
		{
			var nVal: Number = 0;
			var Result: String = "";
			
			nVal = int(tick / DayPerMilSec); 
			if ( nVal > 0 && (showType & 0x10))
			{
				tick -= nVal * DayPerMilSec;
				Result += nVal +LangManager.Lang.common[0];//lang:"天";
			}
			
			nVal = int(tick / HourPerMilSec); 
			if ( nVal > 0 && (showType & 0x08))
			{
				tick -= nVal * HourPerMilSec;
				Result += nVal + LangManager.Lang.common[1];//lang:"小时";
			}
			
			nVal = int(tick / MinPerMilSec); 
			if ( nVal > 0 && (showType & 0x04))
			{
				tick -= nVal * MinPerMilSec;
				Result += nVal + LangManager.Lang.common[2];//lang:"分";
			}
			
			if ( tick > 0 && (showType & 0x02))
			{				
				nVal = int(tick / 1000); 
				tick -= nVal * 1000;
				Result += nVal;
				if ( tick > 0  && (showType & 0x01)) //显示毫秒
				{
					Result += "." + int(tick);
				} 
				Result += LangManager.Lang.common[3];//lang:"秒"
			}
			return Result;
		}
		
		/**
		 * 没有文字的时间  格式化毫秒数显示为:00:00:00
		 * @param tick
		 * @return 
		 */	
		static public function  tickCountToStr2(tick: Number): String
		{
			var nVal: Number = 0;
			var Result: String = "";
			
			
			nVal = int(tick / HourPerMilSec); 
			if ( nVal > 0)
			{
				tick -= nVal * HourPerMilSec;
				if(nVal >= 10)
					Result += nVal + ":";
				else
					Result += "0" + nVal + ":";
			}
			else
			{
				Result += "00"+ ":";
			}
			
			nVal = int(tick / MinPerMilSec); 
			if ( nVal > 0)
			{
				tick -= nVal * MinPerMilSec;
				if(nVal>=10)
					Result += nVal + ":";
				else
					Result +=  "0" + nVal + ":";
			}
			else
			{
				Result += "00"+ ":"
			}
			
			if ( tick > 0 )
			{				
				nVal = int(tick / 1000); 
				tick -= nVal * 1000;
				if(nVal>=10)
					Result += nVal;
				else
					Result +=  "0" + nVal;//lang:"分";
				
				//				if ( tick > 0 ) //显示毫秒
				//				{
				//					Result += "." + int(tick);
				//				} 
			}
			else
				Result += "00";
			
			return Result;
		}
		
		
	}
}