package controls.rtf.plugins.table
{
	import flash.external.ExternalInterface;
	
	import org.w3.dom.html.HTMLTableElement;
	import org.w3.dom.html.HTMLTableRowElement;
	
	public class TableHelper
	{
		static public function init(id:String):void
		{
			ExternalInterface.call("function(id){" +
				"if(window[id]){" +
					"function extractElement(tagName){" +
						"var node=window[id].getActiveElement();"+
						"while(node.tagName!=tagName && node.tagName!='BODY'){" +
							"node=node.offsetParent;"+ 
						"}"+
						"return (node && node.tagName==tagName)?node:null;"+
					"}"+
					"if(!window[id].getActiveTable)window[id].getActiveTable=function(){" + 
						"return extractElement('TABLE')"+
					"};"+
					"if(!window[id].getActiveRow)window[id].getActiveRow=function(){" +
						"var td=extractElement('TD');"+
						"return td && td.parentNode"+
					"};"+
					"if(!window[id].getActiveCell)window[id].getActiveCell=function(){" +
						"return extractElement('TD')"+
					"};"+
					"if(!window[id].removeActiveRow)window[id].removeActiveRow=function(){" +
						"var tbl=window[id].getActiveTable();"+
						"var tr=window[id].getActiveRow();"+
						"if(tr  && tr.tagName=='TR')tr.parentNode.removeChild(tr);"+
						"if(tbl && tbl.rows.length==0){" + 
							"if(tbl.parentNode.childNodes.length==1&&tbl.parentNode.tagName!='BODY')"+
								"tbl.parentNode.parentNode.removeChild(tbl.parentNode);"+
							"else tbl.parentNode.removeChild(tbl);"+
						"}"+
					"};"+
				"}"+
			"}", id);
		}
		
		static public function removeActiveRow(id:String):void
		{
			ExternalInterface.call("window['"+id+"'].removeActiveRow");
		}
		
		static public function getActiveRow(id:String):HTMLTableRowElement
		{
			return new HTMLTableRowElement(ExternalInterface.call("function(id){" +
				"var tr,obj=null;" + 
				"if(window[id]){" +
					"tr=window[id].getActiveRow();" +
					"if(tr && tr.tagName=='TR')" +
						"obj={" +
							"rowIndex:tr.rowIndex,"+
							"nodeName:'TR'," +
							"nodeType:1"+
						"}"+
				"}"+
				"return obj;" + 
			"}", id));
		}
		
		static public function getActiveTable(id:String):HTMLTableElement
		{
			return new HTMLTableElement(ExternalInterface.call("function(id){" +
				"var tbl,obj=null;" + 
				"if(window[id]){" +
					"tbl=window[id].getActiveTable();" +
					"if(tbl&&tbl.tagName=='TABLE')" +
						"obj={" +
							"border:tbl.getAttribute('border')," +
							"align:tbl.getAttribute('align')," + 
							"width:tbl.getAttribute('width')," + 
							"height:tbl.getAttribute('height')," +
							"cellPadding:tbl.cellPadding,"+
							"cellSpacing:tbl.cellSpacing,"+
							"rows:(function(){" + 
								"var r,i,a=[];" + 
								"for(i=0;i<tbl.rows.length;i++){" +
									"r=tbl.rows[i];"+
									"a[i]={" +
										"nodeName:'TR',"+ 
										"nodeType:1,"+
										"align:(r.getAttribute('align')||''),"+
										"bgColor:(r.getAttribute('bgColor')||''),"+
										"vAlign:(r.getAttribute('vAlign')||''),"+
										"cells:(function(){" +
											"var c,j,cells=[];"+
											"for(j=0;j<r.cells.length;j++){" +
												"c=r.cells[j];"+
												"cells[j]={" +
													"nodeName:'TD',"+ 
													"nodeType:1,"+
													"align:(c.getAttribute('align')||''),"+
													"bgColor:(c.getAttribute('bgColor')||''),"+
													"vAlign:(c.getAttribute('vAlign')||''),"+
													"width:(c.getAttribute('width')||''),"+
													"height:(c.getAttribute('height')||''),"+
													"colSpan:(c.getAttribute('colSpan')||0),"+
													"rowSpan:(c.getAttribute('height')||0)"+
												"}"+ 
											"}"+
											"return cells"+ 
										"})()"+
									"}"+ 
								"}" + 
								"return a" + 
							"})()," + 
							"id:tbl.getAttribute('id')," + 
							"nodeName:'TABLE'," +
							"nodeType:1"+
						"}"+ 
				"}" + 
				"return obj;" + 
			"}", id));
		}
	}
}