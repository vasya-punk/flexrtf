package org.w3.dom.html
{
	import org.w3.dom.core.Element;
	
	/**
	 * @url http://www.w3.org/TR/2000/CR-DOM-Level-2-20000510/html.html#ID-58190037
	 */
	public class HTMLElement extends Element
	{
		public var id:String = "";
		public var title:String = "";
		public var lang:String = "";
		public var dir:String = "";
		public var className:String = "";
		
		public function HTMLElement(obj:*=null)
		{
			super(obj)
		}
	}
}