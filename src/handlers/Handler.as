package handlers
{
	/**
	 *	处理器
	 *  @author JiaWei
	 */	
	public class Handler
	{
		/**处理方法*/
		public var handler:*;
		/**参数*/
		public var args:Array;
		/**调用者*/
		public var caller:*;
		
		/**
		 * 
		 * @param handler 函数
		 * @param args 参数数组
		 * @param caller 调用者
		 */		
		public function Handler(handler:* = null, args:Array = null, caller:* = null)
		{
			this.handler = handler;
			this.args = args;
			this.caller = caller;
		}
		
		/**执行处理*/
		public function execute():* {
			if (handler is Function) {
				return handler.apply(caller, args);
			}
			return handler;
		}
		
		/**执行处理(增加数据参数)*/
		public function executeWith(data:Array):* {
			if (data == null) {
				return execute();
			}
			if (handler is Function) {
				return handler.apply(caller, args ? args.concat(data) : data);
			}
			return handler;
		}
		
		/**
		 * 转换成Function
		 * @return 
		 * 
		 */
		public function toFunction():Function
		{
			return function (...parameters):*{return execute()};	
		}
	}
}