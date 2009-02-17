package controls.rtf.plugins.table
{
	import controls.rtf.plugins.BaseManager;
	
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import mx.controls.Button;
	import mx.controls.RadioButton;
	import mx.controls.RadioButtonGroup;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	
	import org.w3.dom.html.HTMLTableRowElement;

	public class TableManagerAddRowBase extends BaseManager
	{
		public var btnInsert:Button;
		public var btnCancel:Button;
		
		public var rdoAbove:RadioButton;
		public var rdoBelow:RadioButton;
		
		[Bindable] protected var position:RadioButtonGroup = new RadioButtonGroup();
		
		public function TableManagerAddRowBase()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			if(btnInsert)
				btnInsert.addEventListener(MouseEvent.CLICK, onInsertClick);
				
			if(btnCancel)
				btnCancel.addEventListener(MouseEvent.CLICK, onCancelClick);
				
			init();
		}
		
		private function onCancelClick(event:MouseEvent):void
		{
			dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
			if(opener)
				opener.editor.iframe.setFocus();
		}
		
		private function onInsertClick(event:MouseEvent):void
		{
			dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
			if(opener)
			{
				opener.editor.iframe.setFocus();

				opener.editor.restoreSelection();
				opener.editor.execCommand("insertTableRow", false, position.selectedValue);
			}
		}
		
		private function init():void
		{
			if(opener)
			{
				TableHelper.init(opener.editor.iframe.uid);
				
				ExternalInterface.call("function(id){" +
					"if(window[id]){" +
						"window[id].insertTableRow=function(pos){" + 
							"var tbl=window[id].getActiveTable();"+
							"var j,last=tbl.rows[tbl.rows.length-1];"+
							"var cols=(last&&last.cells)?last.cells.length:1;"+
							"if(tbl){" + 
								"var row=tbl.insertRow(pos);"+
								"for(j=0;j<cols;j++)row.insertCell(j).innerHTML='&nbsp;';"+
							"}"+
						"};"+
					"}"+
				"}", opener.editor.iframe.uid);
				
				var tr:HTMLTableRowElement = TableHelper.getActiveRow(opener.editor.iframe.uid);
				if(tr && tr.nodeName=="TR")
				{
					rdoAbove.value = tr.rowIndex;
					rdoBelow.value = tr.rowIndex + 1;
				}
			}
		}
	}
}