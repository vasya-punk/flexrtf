package org.w3.dom.html
{
	/**
	 * @url http://www.w3.org/TR/2000/CR-DOM-Level-2-20000510/html.html#ID-6986576
	 */
	public class HTMLTableRowElement extends HTMLElement
	{
		public var align:String       = "";
		public var bgColor:String     = "";
		public var vAlign:String      = "";
		public var rowIndex:int       = 0;
		
		public function HTMLTableRowElement(obj:*=null)
		{
			super(obj);
		}
		
		private var _cells:HTMLCollection = new HTMLCollection();
		public function get cells():HTMLCollection
		{
			return _cells;
		}
		
		public function set cells(value:*):void
		{
			if(value is Array)
			{
				for(var i:int=0; i<value.length; i++)
					value[i] = new HTMLTableCellElement(value[i]);
					
				_cells = new HTMLCollection(value);
			}
		}
	}
}