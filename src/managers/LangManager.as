package managers
{
	import lang.EN_US;
	import lang.Language;
	import lang.ZH_CN;
	import lang.ZH_TW;

	/**
	 *  语言管理器
	 * 	 @example  LangManager.Lang.common[0]
	 *  @author JiaWei
	 */	
	public class LangManager
	{
		static public const CHINESE:String = "zh-cn";//简体中文
		static public const CHINESE_TRADITIONAL:String = "zh-tw";//繁体中文
		static public const ENGLISH:String = "en-us";//英文(美国)
		static private var _langCode:String;//语种代码
		static public var Lang:Language;//语言包
		
		public function LangManager(langcode:String)
		{
			langCode = langcode;
		}

		public static function get langCode():String
		{
			return _langCode;
		}

		public static function set langCode(value:String):void
		{
			if(_langCode != value){
				_langCode = value;
				
				switch(_langCode){
					case CHINESE:
						Lang = new ZH_CN() as Language;
						break;
					case CHINESE_TRADITIONAL:
						Lang = new ZH_TW() as Language;
						break;
					case ENGLISH:
						Lang = new EN_US() as Language;
						break;
				}
			}
			
		}
		
		/**
		 * 提供统一的分割字符串的方法 
		 * @param s
		 * @param sp
		 */		
		static public function SplitString(s:String,sp:String = ","):Array
		{
			return s.split(sp);
		}

	}
}