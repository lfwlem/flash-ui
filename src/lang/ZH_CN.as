package lang
{
	/**
	 *  中文语言包
	 *  @author JiaWei
	 */	
	public class ZH_CN extends Language
	{
		public function ZH_CN()
		{
			super();
			
			initCommon();
		}
		
		private function initCommon():void{
			common = [];
			common[0] = "天";
			common[1] = "小时";
			common[2] = "分";
			common[3] = "秒";
			common[4] = "确定";
		}
	}
}