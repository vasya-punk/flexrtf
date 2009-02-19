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
			addEventListener(FlexEvent.CREATION_COMPLETE, function(event:FlexEvent):void
			{
				removeEventListener(FlexEvent.CREATION_COMPLETE, arguments.callee);
				
				if(btnMerge)
					btnMerge.addEventListener(MouseEvent.CLICK, onMergeClick);
				
				if(btnCancel)
					btnCancel.addEventListener(MouseEvent.CLICK, onCancelClick);
					
				init();
			});
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
						"window[id].mergeTableCells=function(i){" +
							//i = direction
							//t = target
							//s = source(TD)
							"var t,s=window[id].getActiveCell();"+
							"if(s){"+
								"if(i==1){" + //Merge right
									"t=s.parentNode.cells[s.cellIndex+1];"+
									"if(t){" +
										"s.colSpan=s.colSpan?s.colSpan+1:2;"+
										"s.innerHTML+=t.innerHTML;"+
										"t.parentNode.removeChild(t)"+ 
									"}"+ 
								"}else if(i==2){" + //Merge left
									"t=s.parentNode.cells[s.cellIndex-1];"+
									"if(t){" +
										"t.colSpan=t.colSpan?t.colSpan+1:2;"+
										"t.innerHTML+=s.innerHTML;"+
										"s.parentNode.removeChild(s)"+ 
									"}"+ 
								"}else if(i==3){" + //Merge down
									"var tbl=window[id].getActiveTable();"+
									"if(tbl){" +
										"var r=tbl.rows[s.parentNode.rowIndex+1];"+
										"if(r){" + 
											"t=r.cells[s.cellIndex];" + 
											"if(t){" +
												"s.rowSpan=s.rowSpan?s.rowSpan+1:2;"+
												"s.innerHTML+='<br>'+t.innerHTML;"+
												"t.parentNode.removeChild(t)"+ 
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