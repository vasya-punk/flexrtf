package org.w3.dom.core
{
	/**
	 * @url http://www.w3.org/TR/2000/CR-DOM-Level-2-20000510/core.html#ID-745549614
	 */
	public class Element extends Node
	{
		public function Element(obj:*=null)
		{
			super(obj)
		}
		
		public function getAttribute(name:String):String
		{
			return (this.hasOwnProperty(name)) ? this[name] : "";
		}
		
		public function setAttribute(name:String, value:String):void
		{
			if(this.hasOwnProperty(name))
				this[name] = value;
		}
	}
}