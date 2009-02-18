package org.w3.dom.html
{
	/**
	 * @url http://www.w3.org/TR/2000/CR-DOM-Level-2-20000510/html.html#ID-82915075
	 */
	public class HTMLTableCellElement extends HTMLElement
	{
		public var align:String       = "";
		public var bgColor:String     = "";
		public var vAlign:String      = "";
		public var width:String       = "";
		public var height:String      = "";
		
		public var colSpan:int        = 0;
		public var rowSpan:int        = 0;
		
		public var cellIndex:int      = 0;
		
		public function HTMLTableCellElement(obj:*=null)
		{
			super(obj);
		}
	}
}