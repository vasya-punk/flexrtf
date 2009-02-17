package org.w3.dom.html
{
	/**
	 * @url http://www.w3.org/TR/2000/CR-DOM-Level-2-20000510/html.html#ID-17701901
	 */
	public class HTMLImageElement extends HTMLElement
	{
		public var lowSrc:String   = "";
		public var name:String     = "";
		public var align:String    = "";
		public var alt:String      = "";
		public var border:String   = "";
		public var height:String   = "";
		public var hspace:String   = "";
		public var longDesc:String = "";
		public var src:String      = "";
		public var useMap:String   = "";
		public var vspace:String   = "";
		public var width:String    = "";
		public var isMap:Boolean;
           
		public function HTMLImageElement(obj:*=null)
		{
			super(obj);
		}
	}
}