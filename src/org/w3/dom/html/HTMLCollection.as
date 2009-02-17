package org.w3.dom.html
{
	import mx.collections.ArrayCollection;
	
	import org.w3.dom.core.Node;
	
	/**
	 * @url http://www.w3.org/TR/2000/CR-DOM-Level-2-20000510/html.html#ID-75708506
	 */
	public class HTMLCollection extends ArrayCollection
	{
  		private var _items:Array = new Array();
  		
		public function HTMLCollection(source:Array = null)
		{
			super();

        	this.source = source;
		}
		
		public function item(index:int):Node
		{
			var node:Object = getItemAt(index);
			return (node) ? (node as Node) : null;
		}
		
		public function namedItem(name:String):Node
		{
			for each(var node:Node in source)
			{
				if(node.hasOwnProperty("name") && node["name"]==name)
					return node;
				if(node.hasOwnProperty("id") && node["id"]==name)
					return node;
			}
			return null;
		}
	}
}