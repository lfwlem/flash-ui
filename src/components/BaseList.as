package components
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import components.scrollBar.HScrollBar;
	import components.scrollBar.VScrollBar;
	
	import configs.Direction;
	
	import events.DragEvent;
	import events.UIEvent;
	
	import handlers.Handler;
	
	import uiInterface.IItem;
	import uiInterface.IRender;
	
	/**
	 *  列表基类
	 *  @author JiaWei
	 */	
	public class BaseList extends BaseSprite implements IRender, IItem
	{
		protected var _content:BaseSprite;
		protected var _scrollBar:BaseScrollBar;
		protected var _itemRender:*;
		
		protected var _repeatX:int = 0;
		protected var _repeatY:int = 0;
		protected var _repeatX2:int = 0;
		protected var _repeatY2:int = 0;
		protected var _startIndex:int = 0;
		protected var _cells:Vector.<BaseSprite>;
		protected var _spaceX:int = 0;
		protected var _spaceY:int = 0;
		protected var _selectedIndex:int = -1;
		protected var _selectHandler:Handler;
		protected var _mouseHandler:Handler;
		protected var _renderHandler:Handler;
		protected var _isVerticalLayout:Boolean;
		protected var _selectEnable:Boolean;
		protected var _cellSize:Number;
		protected var _array:Array;
		protected var _page:int = 0;
		protected var _totalPage:int = 0;
		
		public function BaseList(item:*=null)
		{
			itemRender = item;
			super();
		}
		
		override protected function init():void
		{
			super.init();
			mouseChildren = true;
			_content = new BaseSprite();
			addChild(_content);
			
			_cells = new Vector.<BaseSprite>;
			_selectEnable = true;
			_isVerticalLayout = true;
			_cellSize = 20;
		}
		
		/**单元格渲染器，可以设置为类对象*/
		public function get itemRender():*{
			return _itemRender;
		}
		
		public function set itemRender(value:*):void
		{
			_itemRender = value? value : new BaseItem();
			changeCells();
		}
		
		public function initItems():void
		{
			if(!_itemRender){
				for (var i:int=0; i<int.MAX_VALUE; i++){
					var cell:BaseSprite = getChildByName("tem"+i) as BaseSprite;
					if(cell){
						addCell(cell);
						continue;
					}
					break;
				}
			}
		}

		/**内容容器*/
		public function get content():BaseSprite
		{
			return _content;
		}

		/**滚动条*/
		public function get scrollBar():BaseScrollBar
		{
			return _scrollBar;
		}

		public function set scrollBar(value:BaseScrollBar):void
		{
			if(_scrollBar != value){
				_scrollBar = value;
				if(!this.contains(_scrollBar)){
					addChild(_scrollBar);
				}
				if(value as VScrollBar){
					_scrollBar.x = width-_scrollBar.width;
				}else if(value as HScrollBar){
					_scrollBar.y = height - scrollBar.height;
				}
				_scrollBar.target = this;
				_scrollBar.addEventListener(Event.CHANGE,onScrollBarChange);
				_isVerticalLayout = _scrollBar.direction == Direction.VERTICAL;
			}
		}
		
		protected function onScrollBarChange(e:Event):void
		{
			changeCells();
			var rect:Rectangle = _content.scrollRect;
			var scrollValue:Number = _scrollBar.value;
			
			if(isNaN(scrollValue)){
				_scrollBar.value = 0;
				return;
			}
			
			var index:int = int(scrollValue / _cellSize) * (_isVerticalLayout ? repeatX : repeatY);
			if(index != _startIndex){
				startIndex = index;
			}
			if(_isVerticalLayout){
				rect.y = scrollValue % _cellSize;
			}else{
				rect.x = scrollValue % _cellSize;
			}
			_content.scrollRect = rect;
		}		
		
		protected function changeCells():void{
			if(_itemRender){
				//销毁老单元格
				for each(var cell:BaseSprite in _cells){
					cell.removeEventListener(MouseEvent.CLICK,onCellMouse);
					cell.removeEventListener(MouseEvent.ROLL_OVER,onCellMouse);
					cell.removeEventListener(MouseEvent.ROLL_OUT,onCellMouse);
					cell.removeEventListener(MouseEvent.MOUSE_DOWN,onCellMouse);
					cell.removeEventListener(MouseEvent.MOUSE_UP,onCellMouse);
					cell.remove();
				}
				
				_cells.length = 0;
				//获取滚动条
				scrollBar = _scrollBar;//getChildByName("scrollBar") as BaseScrollBar;
				
				//自适应宽高
				cell = createItem();
				
				var cellWidth:Number = cell.width + _spaceX;
				if(_repeatX < 1 && !isNaN(_width)){
					_repeatX2 = Math.round(_width / cellWidth);
				}
				var cellHeight:Number = cell.height + _spaceY;
				if(_repeatY < 1 && !isNaN(_height)){
					_repeatY2 = Math.round(_height / cellHeight);
				}
				
				var listWight:Number = isNaN(_width) ? (cellWidth * repeatX - _spaceX) : _width;
				var listHeight:Number = isNaN(_height) ? (cellHeight * repeatY - _spaceY) : _height;
				_cellSize = _isVerticalLayout ? cellHeight : cellWidth;
				
				if(_scrollBar){
					if(_isVerticalLayout){
						_scrollBar.height = listHeight;
					}else{
						_scrollBar.width = listWight;
					}
				}
				setContentSize(listWight,listHeight);
				
				//创建新单元格	
				var numX:int = _isVerticalLayout ? repeatX : repeatY;
				var numY:int = (_isVerticalLayout ? repeatY : repeatX) + (_scrollBar ? 1 : 0);
				for(var i:int=0; i<numY; i++){
					for(var j:int=0; j<numX; j++){
						cell = createItem();
						cell.x = (_isVerticalLayout ? j : i) * (_spaceX + cell.width);
						cell.y = (_isVerticalLayout ? i : j) * (_spaceY + cell.height);
						cell.name = "item" + (i * numX + j);
						_content.addChild(cell);
						addCell(cell);
					}
				}
				
				if(_array){
					array = _array;
					renderItems();
				}
				
			}
		}
		
		protected function createItem():BaseSprite
		{
			return new _itemRender();
		}
		
		/**设置可视区域大小*/
		protected function setContentSize(width:Number,height:Number):void{
			var g:Graphics = graphics;
			g.clear();
			g.beginFill(0xff0000,0);
			g.drawRect(0,0,width,height);
			g.endFill();
			_content.width = width;
			_content.height = height;
			if(_scrollBar)
				_content.scrollRect = new Rectangle(0,0,width,height);
		}
		
		protected function addCell(cell:BaseSprite):void{
			cell.addEventListener(MouseEvent.CLICK,onCellMouse);
			cell.addEventListener(MouseEvent.ROLL_OVER,onCellMouse);
			cell.addEventListener(MouseEvent.ROLL_OUT,onCellMouse);
			cell.addEventListener(MouseEvent.MOUSE_DOWN,onCellMouse);
			cell.addEventListener(MouseEvent.MOUSE_UP,onCellMouse);
			_cells.push(cell);
		}
		
		protected function onCellMouse(e:MouseEvent):void
		{
			var cell:BaseSprite = e.currentTarget as BaseSprite;
			var index:int = _startIndex + _cells.indexOf(cell);
			if(e.type == MouseEvent.CLICK || e.type == MouseEvent.ROLL_OUT || e.type == MouseEvent.ROLL_OVER){
				if(e.type == MouseEvent.CLICK){
					if(_selectEnable){
						selectEnable = index;
					}else{
						changeCellState(cell, true, 0);
					}
				}else if(_selectedIndex != index){
					changeCellState(cell,e.type==MouseEvent.ROLL_OVER, 0);
				}
			}
			
			if(_mouseHandler != null){
				_mouseHandler.executeWith([e,index]);
			}
		}
		
		//item选择的动画，例如多个边框
		protected function changeCellState(cell:BaseSprite,visable:Boolean,frame:int):void{
//						var selectBox:Clip = cell.getChildByName("selectBox") as Clip;
//			if (selectBox) {
//				selectBox.visible = visable;
//				selectBox.frame = frame;
//			}
		}
		
		/**X方向单元格数量*/
		public function get repeatX():int
		{
			return _repeatX > 0?_repeatX : _repeatX2 >0 ? _repeatX2 : 1;;
		}

		public function set repeatX(value:int):void
		{
			_repeatX = value;
			changeCells();
		}

		/**Y方向单元格数量*/
		public function get repeatY():int
		{
			return _repeatY > 0? _repeatY : _repeatY2 > 0?_repeatY2 : 1;;
		}

		public function set repeatY(value:int):void
		{
			_repeatY = value;
			changeCells();
		}

		/**开始索引*/
		public function get startIndex():int
		{
			return _startIndex;
		}

		public function set startIndex(value:int):void
		{
			_startIndex = value >0? value : 0;
			renderItems();
		}
		
		private function renderItems():void
		{
			for(var i:int=0,n:int=cells.length; i<n; i++){
				renderItem(_cells[i],_startIndex + i);
			}
			changeSelectStatus();
		}
		
		private function renderItem(cell:BaseSprite, index:int):void
		{
			if(index < array.length){
				cell.visible = true;
			}else{
				cell.visible = false;
			}
			sendEvent(UIEvent.ITEM_RENDER,[cell,index]);
			if(_renderHandler){
				_renderHandler.executeWith([cell,index]);
			}
		}
		
		/**单元格集合*/
		public function get cells():Vector.<BaseSprite>
		{
			return _cells;
		}

		/**是否可以选中，默认为true*/
		public function get selectEnable():Boolean
		{
			return _selectEnable;
		}

		public function set selectEnable(value:Boolean):void
		{
			_selectEnable = value;
		}

		/**单元格鼠标事件处理器(默认返回参数e:MouseEvent,index:int)*/
		public function get mouseHandler():Handler
		{
			return _mouseHandler;
		}

		public function set mouseHandler(value:Handler):void
		{
			_mouseHandler = value;
		}

		/**X方向单元格间隔*/
		public function get spaceX():int
		{
			return _spaceX;
		}

		public function set spaceX(value:int):void
		{
			_spaceX = value;
			changeCells();
		}

		/**Y方向单元格间隔*/
		public function get spaceY():int
		{
			return _spaceY;
		}

		public function set spaceY(value:int):void
		{
			_spaceY = value;
			changeCells();
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

		/**选择索引*/
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:int):void
		{
			if(_selectedIndex != value){
				_selectedIndex = value;	
				changeSelectStatus();
				sendEvent(Event.CHANGE);
				if(_selectHandler != null){
					_selectHandler.executeWith([value]);
				}
			}
		}
		
		private function changeSelectStatus():void
		{
			for(var i:int=0,n:int=cells.length; i<n; i++){
				changeCellState(cells[i],_selectedIndex == _startIndex + i,1);
			}
		}
		
		/**选中单元格数据源*/
		public function get selectedItem():Object{
			return _selectedIndex != -1? _array[_selectedIndex] : null;	
		}
		
		public function set selectedItem(value:Object):void{
			selectedIndex = _array.indexOf(value);
		}
		
		/**选择单元格组件*/
		public function get selection():BaseSprite{
			return getCell(_selectedIndex);
		}
		
		public function set selection(value:BaseSprite):void{
			selectedIndex = _startIndex + _cells.indexOf(value)
		}
		
		/**单元格渲染处理器(默认返回参数cell:Box,index:int)*/
		public function get renderHandler():Handler
		{
			return _renderHandler;
		}

		public function set renderHandler(value:Handler):void
		{
			_renderHandler = value;
		}

		/**列表数据源*/
		public function get array():Array
		{
			return _array;
		}

		public function set array(value:Array):void
		{
			changeCells();
			_array = value || [];
			var length:int = _array.length;
			_totalPage = Math.ceil(length / (repeatX * repeatY));
			//重设selectedIndex
			_selectedIndex = _selectedIndex < length ? _selectedIndex : length-1;
			//重设startIndex
			startIndex = _startIndex;
			//重设滚动条
			if(_scrollBar){
				var numX:int = _isVerticalLayout ? repeatX : repeatY;
				var numY:int = _isVerticalLayout ? repeatY : repeatX;
				var lineCount:int = Math.ceil(length / numX);
				_scrollBar.visible = _totalPage > 1;
				if(_scrollBar.visible){
					_scrollBar.scrollSize = _cellSize;
					_scrollBar.thumbPercent = numY / lineCount;
					_scrollBar.setScroll(0,(lineCount - numY) * _cellSize + (_isVerticalLayout? height : width)%_cellSize,_startIndex / numX*_cellSize);
				}else{
					_scrollBar.setScroll(0,0,0);
				}
			}
		}
		
		/**列表数据总数*/
		public function get length():int{
				return _array.length;
		}
		
		/**刷新列表*/
		public function refresh():void{
			array = _array;
		}

		/**当前页码*/
		public function get page():int
		{
			return _page;
		}

		public function set page(value:int):void
		{
			_page = value;
			if(_array){
				_page = value >0?value : 0;
				_page = _page < totalPage? _page : _totalPage-1;
				startIndex = _page * repeatX * repeatY;
			}
		}

		/**最大分页数*/
		public function get totalPage():int
		{
			return _totalPage;
		}

		public function set totalPage(value:int):void
		{
			_totalPage = value;
		}

		/**获取单元格数据源*/
		public function getItem(index:int):Object{
			if(index>-1 && index<_array.length){
				return _array[index];
			}
			return null;
		}
		
		/**修改单元格数据源*/
		public function changeItem(index:int,source:Object):void{
			if(index>-1 && index<_array.length){
				_array[index] = source;
				//如果是可视范围，则重新渲染
				if(index>=_startIndex && index < _startIndex + _cells.length){
					renderItem(getCell(index),index);
				}
			}
		}
		
		/**添加单元格数据源*/
		public function addItem(source:Object):void{
			_array.push(source);
			array = _array;
		}
		
		/**添加单元格数据源*/
		public function addItemAt(source:Object,index:int):void{
			_array.splice(index,0,source);
			array = _array;
		}
		
		/**删除单元格数据源*/
		public function deleteItem(index:int):void{
			_array.splice(index,1);
			array = _array;
		}
		
		/**获取单元格*/
		public function getCell(index:int):BaseSprite{
			changeCells();
			if(index>-1 && _cells){
				return _cells[(index-_startIndex) % _cells.length];
			}
			return null;
		}
		
		/**滚动到某个索引位置*/
		public function scrollTo(index:int):void{
			startIndex = index;
			if(_scrollBar){
				var numX:int = _isVerticalLayout ? repeatX : repeatY;
				_scrollBar.value = (index / numX) * _cellSize;
			}
		}
		
		/**获取list内拖动结束位置的索引*/
		public function getDropIndex(e:DragEvent):int{
			var target:DisplayObject = e.data.dropTarget;
			for(var i:int=0,n:int=_cells.length;i<n;i++){
				if(_cells[i].contains(target)){
					return _startIndex + i;
				}
			}
			return -1;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			return child != _content ? super.removeChild(child) : null;
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			return getChildAt(index) !=  _content?  super.removeChildAt(index) : null;
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			changeCells();
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			changeCells();
		}
		
		override public function setSize(width:Number, height:Number):void
		{
			super.setSize(width, height);
			changeCells();
		}
		
		override public function destory():void
		{
			super.destory();
			if(_content){
				removeChild(_content);
				_content.destory();
				_content = null;
			}
			if(_scrollBar){
				removeChild(_scrollBar);
				_scrollBar.destory();
				_scrollBar = null;
			}
			_itemRender = null;
			_cells = null;
			_array = null;
			_selectHandler = null;
			_mouseHandler = null;
			_renderHandler = null;
			
		}
		
	}
}