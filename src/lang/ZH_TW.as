package lang
{
	/**
	 *	繁体语言包
	 *  @author JiaWei
	 */	
	public class ZH_TW extends Language
	{
		public function ZH_TW()
		{
			super();
			
			initCommon();
		}
		
		private function initCommon():void{
			common = [];
			common[0] = "天";
			common[1] = "小時";
			common[2] = "分";
			common[3] = "秒";
			common[4] = "確定";
		}
	}
}