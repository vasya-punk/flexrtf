package controls.rtf.plugins.table
{
	import controls.rtf.plugins.BaseManager;
	
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import mx.controls.Button;
	import mx.controls.RadioButtonGroup;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;

	public class TableManagerAddRowBase extends BaseManager
	{
		public var btnInsert:Button;
		public var btnCancel:Button;
		
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
							"if(tbl){" + 
								"if(pos==1){" +
									""+ 
								"}else if(pos==2){" +
									""+ 
								"}else if(pos==3){" +
									""+ 
								"}else if(pos==4){" +
									""+ 
								"}" + 
							"}"+
						"}"+
					"}"+
				"}", opener.editor.iframe.uid);
			}
		}
	}
}