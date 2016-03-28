package components.group
{
	import flash.display.DisplayObject;
	
	import components.BaseButton;
	import components.BaseGroup;
	
	import configs.Direction;
	
	/**
	 *  按钮组，默认selectedIndex=-1
	 *  @author JiaWei
	 */	
	public class ButtonGroup extends BaseGroup
	{
		protected var _labels:String;
		protected var _btnList:Array;
		protected var _labelColors:String;
		protected var _labelStroke:String;
		protected var _labelSize:int;
		protected var _labelBold:Boolean;
		protected var _labelMargin:String;
		
		/**
		 * @param _list
		 * @param _label  文本，用","隔开
		 */
		public function ButtonGroup(_list:Array,_label:String = "")
		{
			super();
			direction = Direction.HORIZONTAL;
			_btnList = _list;
			labels = _label;
		}		
		
		public function get labels():String
		{
			return _labels;
		}
		
		public function set labels(value:String):void
		{
			if(_labels != value){
				_labels = value;
				removeAllChild();
				if(Boolean(_labels)){
					var labList:Array = _labels.split(",");
					for(var i:int=0,n:int=labList.length; i<n; i++){
						var item:DisplayObject = createItem(_btnList,labList[i]);
						item.name = "item" + i;
						addChild(item);
					}
				}
				initItems();
			}
		}
		
		public function createItem(_list:Array,_label:String):DisplayObject{
			return new BaseButton(_list,_label,1);
		}

		public function get labelColors():String
		{
			return _labelColors;
		}

		public function set labelColors(value:String):void
		{
			if(_labelColors != value){
				_labelColors = value;	
				changeLabel();
			}
		}

		public function get labelStroke():String
		{
			return _labelStroke;
		}

		public function set labelStroke(value:String):void
		{
			if(_labelStroke != value){
				_labelStroke = value;	
				changeLabel();
			}
		}

		public function get labelSize():int
		{
			return _labelSize;
		}

		public function set labelSize(value:int):void
		{
			if(_labelSize != value){
				_labelSize = value;	
				changeLabel();
			}
		}

		public function get labelBold():Boolean
		{
			return _labelBold;
		}

		public function set labelBold(value:Boolean):void
		{
			if(_labelBold != value){
				_labelBold = value;	
				changeLabel();
			}
		}

		public function get labelMargin():String
		{
			return _labelMargin;
		}

		public function set labelMargin(value:String):void
		{
			if(_labelMargin != value){
				_labelMargin = value;	
				changeLabel();
			}
		}
		
		public function get btnList():Array
		{
			return _btnList;
		}
		
		public function set btnList(value:Array):void
		{
			if(_btnList != value){
				_btnList = value;	
				changeLabel();
			}
		}

		protected function changeLabel():void{
			if(_items){
				var left:Number = 0;
				for(var i:int=0,n:int=_items.length; i< n; i++){
					var item:BaseButton = _items[i] as BaseButton;
					if(_btnList)
						item.bitmapList = _btnList;
					if(_labelColors)
						item.labelColors = _labelColors;
					if(_labelMargin)
						item.labelMargin = _labelMargin;
					if(_labelStroke)
						item.labelStroke = _labelStroke;
					if(_labelSize)
						item.labelSize = _labelSize;
					if(_labelBold)
						item.labelBold = _labelBold;
					if(_direction == Direction.HORIZONTAL){
						item.y = 0;
						item.x = left;
						left += item.width + _space;
					}else{
						item.x = 0;
						item.y = left;
						left += item.height + _space;
					}
				}
			}
		}
		
		override public function destory():void
		{
			super.destory();
			if(_btnList){
				_btnList.length = 0;
			}
			_btnList = null;
			_labelColors = null;
			_labelMargin = null;
			_labels = null;
			_labelStroke = null;
		}
		
		
	}
}