package org.w3.dom.html
{
	import mx.events.IndexChangedEvent;
	
	/**
	 * @url http://www.w3.org/TR/2000/CR-DOM-Level-2-20000510/html.html#ID-64060425
	 */
	public class HTMLTableElement extends HTMLElement
	{
		public var align:String       = "";
		public var bgColor:String     = "";
		public var border:String      = "";
		public var cellPadding:String = "";
		public var cellSpacing:String = "";
		public var frame:String       = "";
		public var rules:String       = "";
		public var summary:String     = "";
		public var width:String       = "";
		
		public var height:String      = "";
           
		public function HTMLTableElement(obj:*=null)
		{
			super(obj);
		}
		
		private var _rows:HTMLCollection = new HTMLCollection();
		public function get rows():HTMLCollection
		{
			return _rows;
		}
		
		public function set rows(value:*):void
		{
			if(value is Array)
			{
				for(var i:int=0; i<value.length; i++)
					value[i] = new HTMLTableRowElement(value[i]);
				
				_rows = new HTMLCollection(value);
			}
		}
	}
}