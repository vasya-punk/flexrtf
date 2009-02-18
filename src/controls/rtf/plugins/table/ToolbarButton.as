package controls.rtf.plugins.table
{
	import controls.rtf.plugins.PopupButton;
	import controls.rtf.toolbars.DefaultToolbar;
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import org.w3.dom.html.HTMLElement;

	public class ToolbarButton extends controls.rtf.plugins.PopupButton
	{
		public function ToolbarButton()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			var toolbar:DefaultToolbar = owner as DefaultToolbar;
			var _icon:Class = getStyle("icon");
			
			if(_icon == toolbar.icons.TABLE_ADD_ROW)
				popupClass = TableManagerAddRow;
			else if(_icon == toolbar.icons.TABLE_REMOVE_ROW)
				popupClass = null;
			else if(_icon == toolbar.icons.TABLE_MERGE_CELLS)
				popupClass = TableMergeManager;
			else
				popupClass = TableManager;
		}
		
		override protected function onClick(event:MouseEvent):void
		{
			var toolbar:DefaultToolbar = owner as DefaultToolbar;
			var _icon:Class = getStyle("icon");
			
			if(popupClass)
				super.onClick(event);
				
			else if(_icon == toolbar.icons.TABLE_REMOVE_ROW)
				TableHelper.removeActiveRow(toolbar.editor.iframe.uid);
		}
		
		override public function update(node:HTMLElement):void
		{
			var toolbar:DefaultToolbar = owner as DefaultToolbar;
			var _icon:Class = getStyle("icon");
			
			if(_icon == toolbar.icons.TABLE_ADD_ROW || _icon == toolbar.icons.TABLE_REMOVE_ROW || _icon == toolbar.icons.TABLE_MERGE_CELLS)
			{
				enabled = (node.nodeName == "TABLE" || node.nodeName == "TBODY" || node.nodeName == "TR" || node.nodeName == "TD");
			}
		}
	}
}