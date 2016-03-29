package handlers
{
	/**
	 *  定时处理器
	 *  @author JiaWei
	 */	
	public class TimerHandler
	{
		/**执行间隔*/
		public var delay:int;
		/**是否重复执行*/
		public var repeat:Boolean;
		/**是否用帧率*/
		public var userFrame:Boolean;
		/**执行时间*/
		public var exeTime:int;
		/**处理方法*/
		public var method:Function;
		/**参数*/
		public var args:Array;
		
		public function TimerHandler()
		{
		}
		
		/**清理*/
		public function clear():void {
			method = null;
			args = null;
		}
	}
}