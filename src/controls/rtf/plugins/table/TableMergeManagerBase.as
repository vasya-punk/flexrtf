package controls.rtf.plugins.table
{
	import controls.rtf.plugins.BaseManager;
	
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import mx.controls.Button;
	import mx.controls.RadioButtonGroup;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;

	public class TableMergeManagerBase extends BaseManager
	{
		public var btnMerge:Button;
		public var btnCancel:Button;
		
		[Bindable] protected var merge:RadioButtonGroup = new RadioButtonGroup();
		
		public function TableMergeManagerBase()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			if(btnMerge)
				btnMerge.addEventListener(MouseEvent.CLICK, onMergeClick);
				
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
		
		private function onMergeClick(event:MouseEvent):void
		{
			dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
			if(opener)
			{
				opener.editor.iframe.setFocus();

				opener.editor.restoreSelection();
				opener.editor.execCommand("mergeTableCells", false, merge.selectedValue);
			}
		}
		
		private function init():void
		{
			if(opener)
			{
				TableHelper.init(opener.editor.iframe.uid);
				
				ExternalInterface.call("function(id){" +
					"if(window[id]){" +
						"window[id].mergeTableCells=function(pos){" +
							"var target,td=window[id].getActiveCell();"+
							"if(td){"+
								"if(pos==1){" + //Merge right
									"target=td.parentNode.cells[td.cellIndex+1];"+
									"if(target){" +
										"td.colSpan = td.colSpan ? td.colSpan+1 : 2;"+
										"td.innerHTML+=target.innerHTML;"+
										"target.parentNode.removeChild(target);"+ 
									"}"+ 
								"}else if(pos==2){" + //Merge left
									"target=td.parentNode.cells[td.cellIndex-1];"+
									"if(target){" +
										"target.colSpan = target.colSpan ? target.colSpan+1 : 2;"+
										"target.innerHTML+=td.innerHTML;"+
										"td.parentNode.removeChild(td);"+ 
									"}"+ 
								"}else if(pos==3){" + //Merge down
									"var tbl=window[id].getActiveTable();"+
									"if(tbl){" +
										"var row=tbl.rows[td.parentNode.rowIndex+1];"+
										"if(row){" + 
											"target=row.cells[td.cellIndex];" + 
											"if(target){" +
												"td.rowSpan = td.rowSpan ? td.rowSpan+1 : 2;"+
												"td.innerHTML+='<br>'+target.innerHTML;"+
												"target.parentNode.removeChild(target);"+ 
											"}"+
										"}"+ 
									"}"+ 
								"}"+
							"}"+
						"};"+
					"}"+
				"}", opener.editor.iframe.uid);
			}
		}
	}
}