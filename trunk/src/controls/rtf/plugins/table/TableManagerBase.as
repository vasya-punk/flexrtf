package controls.rtf.plugins.table
{
	import controls.rtf.plugins.BaseManager;
	
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.controls.TextInput;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	
	import org.w3.dom.html.HTMLTableElement;

	public class TableManagerBase extends BaseManager
	{
		public var txtRows:TextInput;
		public var txtColumns:TextInput;
		public var txtWidth:TextInput;
		public var txtHeight:TextInput;
		public var txtBorder:TextInput;
		public var txtSpacing:TextInput;
		public var txtPadding:TextInput;
		
		public var cmbWidth:ComboBox;
		public var cmbAlignment:ComboBox;
		
		public var btnInsert:Button;
		public var btnCancel:Button;
		
		public function TableManagerBase()
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
				opener.editor.execCommand("insertTable", false, {
					width:txtWidth.text + cmbWidth.selectedLabel,
					height:txtHeight.text,
					border:txtBorder.text,
					cellspacing:txtSpacing.text,
					cellpadding:txtPadding.text,
					align:cmbAlignment.selectedLabel,
					rows:txtRows.text,
					columns:txtColumns.text
				});
			}
		}
		
		private function init():void
		{
			if(opener)
			{
				TableHelper.init(opener.editor.iframe.uid);
				
				ExternalInterface.call("function(id){" +
					"if(window[id]){" +
						"window[id].insertTable=function(val){" +							
							"var tbl=window[id].getActiveTable();" +
							"if(tbl){" +
								"tbl.width=val.width.replace(/px$/,'');"+ 
								"tbl.height=val.height;"+
								"tbl.border=val.border;"+ 
								"tbl.cellSpacing=val.cellspacing;"+
								"tbl.cellPadding=val.cellpadding;"+ 
								"tbl.align=val.align;"+ 
								"if(!val.rows)val.rows=1;"+
								"if(val.rows>tbl.rows.length){" +
									"var j,i,last=tbl.rows[tbl.rows.length-1];"+
									"var cols=(last&&last.cells)?last.cells.length:1;"+
									"for(i=tbl.rows.length;i<val.rows;i++){" +
										"var row=tbl.insertRow(i);"+ 
										"for(j=0;j<cols;j++)row.insertCell(j).innerHTML='&nbsp;';"+
									"}"+ 
								"}"+
							"}else{"+
								"var html='<table';"+
								"if(val.width){" +
									"val.width=val.width.replace(/px$/,'');"+ 
									"html+=' width=\"'+val.width+'\"';"+
								"}"+
								"if(val.height)html+=' height=\"'+val.height+'\"';"+
								"if(val.border)html+=' border=\"'+val.border+'\"';"+
								"if(val.cellspacing)html+=' cellspacing=\"'+val.cellspacing+'\"';"+
								"if(val.cellpadding)html+=' cellpadding=\"'+val.cellpadding+'\"';"+
								"if(val.align)html+=' align=\"'+val.align+'\"';"+
								"html+='>';"+
								"for(var i=0;i<(val.rows||1);i++){" +
									"html+='<tr>';"+
									"for(var j=0;j<(val.columns||1);j++)html+='<td>&nbsp;</td>';"+ 
									"html+='</tr>';"+ 
								"}"+
								"html+='</tabel>';"+
								"var doc=window[id].getDocument();"+ 
								"if(window.VBArray){" +
									"var rng=doc.selection.createRange();"+
									"rng.pasteHTML(html);"+
									"rng.collapse(false);"+
									"rng.select();"+ 
								"}else doc.execCommand('insertHTML',false,html)"+ 
							"}"+
						"};" +
					"}"+ 
				"}", opener.editor.iframe.uid);
				
				var table:HTMLTableElement = TableHelper.getActiveTable(opener.editor.iframe.uid);
				
				if(table && table.nodeName=="TABLE")
				{
					if(table.align)
						for each(var obj:Object in cmbAlignment.dataProvider)
							if(table.align.toLowerCase().indexOf(String(obj.label).toLowerCase()) == 0)
								cmbAlignment.selectedItem = obj;

					if(table.width)
					{
						if(table.width.indexOf("%") == table.width.length - 1)
						{
							table.width = table.width.substring(0, table.width.length - 1);
							cmbWidth.selectedIndex = 0;
						}
						else
							cmbWidth.selectedIndex = 1;
							
						txtWidth.text = table.width;
					}
					
					if(table.border)txtBorder.text = table.border;
					if(table.height)txtHeight.text = table.height;
					if(table.cellPadding)txtPadding.text = table.cellPadding;
					if(table.cellSpacing)txtSpacing.text = table.cellSpacing;
					txtRows.text = String(table.rows.length);
					txtColumns.enabled = false;
				}
				
				opener.editor.storeSelection();
			}
		}
	}
}