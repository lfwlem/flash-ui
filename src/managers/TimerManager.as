package managers
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import handlers.TimerHandler;

	/**
	 *  时间管理器
	 *  @author JiaWei
	 */	
	public class TimerManager
	{
		private var _shape:Shape;
		private var _pool:Vector.<TimerHandler>;
		private var _handlers:Dictionary;
		private var _currTimer:int;
		private var _currFrame:int = 0;
		private var _count:int = 0;
		private var _index:uint = 0;
		
		public function TimerManager()
		{
			_shape = new Shape();
			_pool = new Vector.<TimerHandler>();
			_handlers = new Dictionary();
			_currTimer = getTimer();
			
			_shape.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		protected function onEnterFrame(e:Event):void
		{
			_currFrame++;
			_currTimer = getTimer();
			for(var key:Object in _handlers){
				var handler:TimerHandler = _handlers[key];
				var t:int = handler.userFrame ? _currFrame : _currTimer;
				if(t > handler.exeTime){
					var method:Function = handler.method;
					var args:Array = handler.args;
					if(handler.repeat){
						while(t > handler.exeTime && (key in _handlers) && handler.repeat){
							handler.exeTime += handler.delay;
							method.apply(null,args);
						}
					}else{
						clearTimer(key);
						method.apply(null,args);
					}
				}
			}
		}		
		
		/**清理定时器
		 * @param	method 创建时的cover=true时method为回调函数本身，否则method为返回的唯一ID
		 */
		public function clearTimer(method:Object):void {
			var handler:TimerHandler = _handlers[method];
			if(handler != null){
				delete _handlers[method];
				handler.clear();
				_pool.push(handler);
				_count--;
			}
		}
		
		/**定时执行一次
		 * @param	delay  延迟时间(单位毫秒)
		 * @param	method 结束时的回调方法
		 * @param	args   回调参数
		 * @param	cover  是否覆盖(true:同方法多次计时，后者覆盖前者。false:同方法多次计时，不相互覆盖)
		 * @return  cover=true时返回回调函数本身，cover=false时，返回唯一ID，均用来作为clearTimer的参数*/
		public function doOnce(delay:int, method:Function, args:Array = null, cover:Boolean = true):Object {
			return create(false, false, delay, method, args, cover);
		}
		
		/**定时重复执行
		 * @param	delay  延迟时间(单位毫秒)
		 * @param	method 结束时的回调方法
		 * @param	args   回调参数
		 * @param	cover  是否覆盖(true:同方法多次计时，后者覆盖前者。false:同方法多次计时，不相互覆盖)
		 * @return  cover=true时返回回调函数本身，cover=false时，返回唯一ID，均用来作为clearTimer的参数*/
		public function doLoop(delay:int, method:Function, args:Array = null, cover:Boolean = true):Object {
			return create(false, true, delay, method, args, cover);
		}
		
		/**定时执行一次(基于帧率)
		 * @param	delay  延迟时间(单位为帧)
		 * @param	method 结束时的回调方法
		 * @param	args   回调参数
		 * @param	cover  是否覆盖(true:同方法多次计时，后者覆盖前者。false:同方法多次计时，不相互覆盖)
		 * @return  cover=true时返回回调函数本身，cover=false时，返回唯一ID，均用来作为clearTimer的参数*/
		public function doFrameOnce(delay:int, method:Function, args:Array = null, cover:Boolean = true):Object {
			return create(true, false, delay, method, args, cover);
		}
		
		/**定时重复执行(基于帧率)
		 * @param	delay  延迟时间(单位为帧)
		 * @param	method 结束时的回调方法
		 * @param	args   回调参数
		 * @param	cover  是否覆盖(true:同方法多次计时，后者覆盖前者。false:同方法多次计时，不相互覆盖)
		 * @return  cover=true时返回回调函数本身，否则返回唯一ID，均用来作为clearTimer的参数*/
		public function doFrameLoop(delay:int, method:Function, args:Array = null, cover:Boolean = true):Object {
			return create(true, true, delay, method, args, cover);
		}
		
		/**定时器执行数量*/
		public function get count():int {
			return _count;
		}
		
		private function create(useFrame:Boolean, repeat:Boolean, delay:int, method:Function, args:Array = null, cover:Boolean = true):Object {
			var key:Object;
			if(cover){
				//先删除相同函数的计时
				clearTimer(method);
				key = method;
			}else{
				key = _index++;
			}
			//如果执行时间小于1，直接执行
			if(delay<1){
				method.apply(null,args);
				return -1;
			}
			var handler:TimerHandler = _pool.length>0 ? _pool.pop() : new TimerHandler();
			handler.userFrame = useFrame;
			handler.repeat = repeat;
			handler.delay = delay;
			handler.method = method;
			handler.args = args;
			handler.exeTime = delay + (useFrame ? _currFrame : _currTimer);
			_handlers[key] = handler;
			_count++;
			return key;
		}
		
	}
}