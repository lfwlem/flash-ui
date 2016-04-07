package managers
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.system.Capabilities;
	import flash.system.IME;
	
	import configs.AppConfig;

	/**
	 * 	 UI管理器
	 *  @author JiaWei
	 */	
	public class AppManager
	{
		/**全局stage引用*/
		public static var stage:Stage;
		static private var _stageWidth: Number = 1024;//有效宽度（不具备裁剪显示区域的功能，只是为了各项处理中判断边界）
		static private var _stageHeight: Number = 1024;//有效高度
		static private var IMEEnabled: Boolean;//是否允许启用IME
		
		/**资源管理器*/
		public static var asset:AssetManager;
		/**时钟管理器*/
		public static var timer:TimerManager;
		/**日志管理器*/
		public static var log:LogManager;
		/**提示管理器*/
		public static var tip:TipManager;
		/**语言管理器*/
		public static var lang:LangManager;
		/**拖动管理器*/
		public static var drag:DragManager;
		
		public static function init(main:DisplayObjectContainer):void{
			stage = main.stage;
			stage.frameRate = AppConfig.GAME_FPS;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.stageFocusRect = false;
			stage.tabChildren = false;
			
			IMEEnabled = Capabilities.hasIME && IME.enabled;
			
			asset = new AssetManager();
			timer = new TimerManager();
			lang = new LangManager(LangManager.CHINESE);
			drag = new DragManager();
			
			tip = new TipManager();
			stage.addChild(tip);
			log = new LogManager();
			stage.addChild(log);
			
		}
		
		static public function get width(): Number
		{
			return _stageWidth;
		}
		
		static public function get height(): Number
		{
			return _stageHeight;
		}
		
		static public function get x(): Number
		{
			return stage ? stage.x : 0;
		}
		static public function get y(): Number
		{
			return stage ? stage.y : 0;
		}
		
		/**
		 * 是否允许IME的属性 
		 * @return 
		 */
		static public function get imeEnabled(): Boolean
		{
			return IMEEnabled;
		}
		static public function set imeEnabled(value: Boolean): void
		{
			/** 必须不能出于优化的目的在此判断value不等于m_boIMEEnabled才进行相关操作
			 * 这样会导致flash激活后重新设置值缺不会产生作用的BUG，因为flash内部自行将
			 * 输入法启用否的属性给改了 **/
			IMEEnabled = value;
			if (Capabilities.hasIME)
				IME.enabled = value;
		}
		
	}
}