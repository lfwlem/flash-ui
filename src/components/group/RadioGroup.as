package components.group
{
	import flash.display.DisplayObject;
	
	import components.button.RadioButton;
	
	import configs.Direction;

	/**
	 *
	 *  @author JiaWei
	 */	
	public class RadioGroup extends ButtonGroup
	{
		public function RadioGroup(_list:Array, _label:String="")
		{
			super(_list, _label);
		}
		
		override protected function changeLabel():void
		{
			if(_items){
				var left:Number = 0;
				for(var i:int=0,n:int=_items.length; i< n; i++){
					var item:RadioButton = _items[i] as RadioButton;
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
		
		override public function createItem(_list:Array, _label:String):DisplayObject
		{
			return new RadioButton(_list,_label);
		}
		
		/**被选择单选按钮的值*/
		public function get selectedValue():Object{
			return _selectIndex>-1 && _selectIndex<_items.length ? RadioButton(_items[_selectIndex]).value : null;
		}

		public function set selectedValue(value:Object):void{
			if(_items){
				for(var i:int=0,n:int=_items.length; i<n; i++){
					var item:RadioButton = _items[i] as RadioButton;
					if(item.value == value){
						selectIndex = i;
						break;
					}
				}
			}
		}
	}
}