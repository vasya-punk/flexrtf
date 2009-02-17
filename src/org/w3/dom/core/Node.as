package org.w3.dom.core
{
	/**
	 * @url http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core.html#ID-1950641247
	 */
	public class Node
	{
		public static const ELEMENT_NODE:int                   = 1;
		public static const ATTRIBUTE_NODE:int                 = 2;
		public static const TEXT_NODE:int                      = 3;
		public static const CDATA_SECTION_NODE:int             = 4;
		public static const ENTITY_REFERENCE_NODE:int          = 5;
		public static const ENTITY_NODE:int                    = 6;
		public static const PROCESSING_INSTRUCTION_NODE:int    = 7;
		public static const COMMENT_NODE:int                   = 8;
		public static const DOCUMENT_NODE:int                  = 9;
		public static const DOCUMENT_TYPE_NODE:int             = 10;
		public static const DOCUMENT_FRAGMENT_NODE:int         = 11;
		public static const NOTATION_NODE:int                  = 12;
  
		private var _nodeName:String  = "";
		public var nodeValue:String = "";
		public var nodeType:int     = 0;
		
		public var textContent:String = "";
		
		public function Node(obj:*=null)
		{
			if(obj)
				for(var prop:String in obj)
					if(this.hasOwnProperty(prop))
						this[prop] = obj[prop];
		}
		
		public function get nodeName():String
		{
			return _nodeName
		}
		
		public function set nodeName(value:String):void
		{
			if(value)
				value = value.toUpperCase();
			
			_nodeName = value;
		}
	}
}