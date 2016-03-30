package lang
{
	/**
	 *	英文（美国）语言包
	 *  @author JiaWei
	 */	
	public class EN_US extends Language
	{
		public function EN_US()
		{
			super();
			
			initCommon();
		}
		
		private function initCommon():void{
			common = [];
			common[0] = "day";
			common[1] = "hour";
			common[2] = "minute";
			common[3] = "second";
			common[4] = "OK";
		}
	}
}