package org.w3.dom.html
{
	/**
	 * @url http://www.w3.org/TR/2000/CR-DOM-Level-2-20000510/html.html#ID-48250443
	 */
	public class HTMLAnchorElement extends HTMLElement
	{	
		public var accessKey:String = "";
		public var charset:String   = "";
		public var coords:String    = "";
		public var href:String      = "";
		public var hreflang:String  = "";
		public var name:String      = "";
		public var rel:String       = "";
		public var rev:String       = "";
		public var shape:String     = "";
		public var tabIndex:String  = "";
		public var target:String    = "";
		public var type:String      = "";
		
		public function blur():void{}
		public function focus():void{}
		
		public function HTMLAnchorElement(obj:*=null)
		{
			super(obj)
		}
	}
}