package components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import configs.Direction;
	
	import handlers.Handler;
	
	import uiInterface.IItem;
	import uiInterface.ISelect;
	
	/**
	 *  集合基类，Tab和RadioGroup的基类
	 *  @author JiaWei
	 */	
	public class BaseGroup extends BaseSprite implements IItem
	{
		protected var _items:Vector.<ISelect>;
		protected var _selectHandler:Handler;
		protected var _selectIndex:int = -1;
		protected var _direction:String;
		protected var _space:Number = 0;
		
		public function BaseGroup()
		{
			super();
		}
		
		/**初始化*/
		public function initItems():void
		{
			_items = new Vector.<ISelect>();
			for(var i:int=0; i < int.MAX_VALUE; i++){
				var item:ISelect = getChildByName("item" + i) as ISelect;
				if(item != null){
					_items.push(item);
					item.selected = (i == _selectIndex);
					item.clickHandler = new Handler(itemClick,[i]);
				}
			}
		}
		
		/**增加项，返回索引id
		 * @param autoLayOut 是否自动布局，如果为true，会根据direction和space属性计算item的位置*/
		public function addItem(item:ISelect,autpLayOut:Boolean = true):int{
			var display:DisplayObject = item as DisplayObject;
			var index:int = _items.length;
			display.name = "item" + index;
			addChild(display);
			initItems();
			
			if(autpLayOut && index>0){
				var preItem:DisplayObject = _items[index-1] as DisplayObject;
				if(_direction == Direction.HORIZONTAL){
					display.x = preItem.x + preItem.width + _space;
				}else{
					display.y = preItem.y + preItem.height + _space;
				}
			}
			return index;
		}
		
		/**删除项
		 * @param autoLayOut 是否自动布局，如果为true，会根据direction和space属性计算item的位置*/
		public function removeItem(item:ISelect,autpLayOut:Boolean = true):void{
			var index:int = _items.indexOf(item);
			if(index != -1){
				var display:DisplayObject = item as DisplayObject;
				removeChild(display);
				for(var i:int=index+1,n:int=_items.length; i<n; i++){
					var child:DisplayObject = _items[i] as DisplayObject;
					child.name = "item" + (i-1);
					if(autpLayOut){
						if(_direction == Direction.HORIZONTAL){
							child.x -= display.width + _space;
						}else{
							child.y -= display.height + _space;
						}
					}
				}
				initItems();
				if(_selectIndex>-1){
					selectIndex = _selectIndex < _items.length ? _selectIndex : (_selectIndex - 1);
				}
			}
		}
		
		protected function itemClick(index:int):void{
			selectIndex = index;
		}
		
		/**子项集合*/
		public function get items():Vector.<ISelect>{
			return _items;
		}
		
		/**选择项*/
		public function get selection():ISelect{
			return _selectIndex > -1 && _selectIndex<_items.length ? _items[_selectIndex] : null;
		}
		
		public function set selection(value:ISelect):void{
			selectIndex = _items.indexOf(value);
		}

		/**所选按钮的索引，默认为-1*/
		public function get selectIndex():int
		{
			return _selectIndex;
		}

		public function set selectIndex(value:int):void
		{
			if(_selectIndex != value){
				setSelect(_selectIndex,false);
				_selectIndex = value;	
				setSelect(_selectIndex,true);
				sendEvent(Event.CHANGE);
				if(_selectHandler != null){
					_selectHandler.executeWith([_selectIndex]);
				}
			}
		}
		
		protected function setSelect(index:int,_selected:Boolean):void{
			if(_items && index>-1 && index<_items.length){
				_items[index].selected = _selected;
			}
		}

		/**间隔*/
		public function get space():Number
		{
			return _space;
		}

		public function set space(value:Number):void
		{
			_space = value;
		}

		/**选择被改变时执行的处理器(默认返回参数index:int)*/
		public function get selectHandler():Handler
		{
			return _selectHandler;
		}

		public function set selectHandler(value:Handler):void
		{
			_selectHandler = value;
		}

		/**布局方向*/
		public function get direction():String
		{
			return _direction;
		}

		public function set direction(value:String):void
		{
			_direction = value;
		}
		
		override public function destory():void
		{
			super.destory();
			if(_items){
				_items.length = 0;
			}
			_items = null;
			_selectHandler = null;
		}

	}
}