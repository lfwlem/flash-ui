package managers
{
	import flash.display.BitmapData;
	import flash.system.ApplicationDomain;
	
	import components.BaseBitmap;

	/**
	 *  资源管理器
	 *  @author JiaWei
	 */	
	public class AssetManager
	{
		private var _bmdMap:Object = {};
		private var _domain:ApplicationDomain;
		public function AssetManager()
		{
			_domain = ApplicationDomain.currentDomain;
			
		}
		
		/**判断是否有类的定义*/
		public function hasClass(name:String,domain:ApplicationDomain = null):Boolean{
			if(domain == null){
				domain = _domain;
			}
			return domain.hasDefinition(name);
		}
		
		/**获取类*/
		public function getClass(name:String,domain:ApplicationDomain = null):Class{
			if(domain == null){
				domain = _domain;
			}
			if(hasClass(name,domain)){
				return domain.getDefinition(name) as Class;
			}
			AppManager.log.error("缺少资源：",name);
			return null;
		}
		
		/**获取资源*/
		public function getAssets(name:String):*{
			var ResClsRef:Class = getClass(name);
			if(ResClsRef != null){
				return new ResClsRef(0,0);
			}
			return null;
		}
		
		/**获取位图数据*/
		public function getBitmapData(name:String,cache:Boolean = true,domain:ApplicationDomain = null):BitmapData{
			var bmd:BitmapData = _bmdMap[name];
			if(bmd == null){
				var bmdClass:Class = getClass(name,domain);
				if(bmdClass != null){
					bmd = new bmdClass(1,1);
					if(cache){
						_bmdMap[name] = bmd;
					}
				}
			}
			return bmd;
		}
		
		/**获取位图*/
		public function getBaseBitmap(name:String,cache:Boolean = true,domain:ApplicationDomain = null):BaseBitmap{
			var bmd:BitmapData = getBitmapData(name,cache,domain);
			if(bmd){
				var bbm:BaseBitmap = new BaseBitmap();
				bbm.bitmapData = bmd;
				bbm.url = "Assets/" + name;
				return bbm;
			}
			return null;
		}
		
		/**缓存位图数据*/
		public function cacheBitmapDate(name:String,bmd:BitmapData):void{
			if(bmd){
				_bmdMap[name] = bmd;
			}
		}
		
		/**销毁位图数据*/
		public function disposeBitmapData(name:String):void{
			var bmd:BitmapData = _bmdMap[name];
			if(bmd){
				delete _bmdMap[name];
				bmd.dispose();
			}
		}
		
		
	}
}