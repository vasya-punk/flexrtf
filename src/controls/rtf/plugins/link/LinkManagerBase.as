package controls.rtf.plugins.link
{
	import controls.rtf.RtfCommands;
	import controls.rtf.plugins.BaseManager;
	
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.utils.setTimeout;
	
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.controls.TextInput;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	
	import org.w3.dom.html.HTMLAnchorElement;

	public class LinkManagerBase extends BaseManager
	{
		public var btnInsert:Button;
		public var btnCancel:Button;
		public var cmdProtocol:ComboBox;
		public var txtUrl:TextInput;
		public var cmdTarget:ComboBox;
		public var txtName:TextInput;
		public var txtTitle:TextInput;
		
		private var _id:String = "";
		
		public function LinkManagerBase()
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
				var url:String = cmdProtocol.text + txtUrl.text;
				opener.editor.iframe.setFocus();
				setTimeout(function():void
				{
					opener.editor.restoreSelection();
					opener.editor.execCommand(RtfCommands.CREATE_LINK, false, url);
					opener.editor.execCommand("setLinkProperties", false, {
						target: cmdTarget.selectedLabel,
						href:   url,
						name:   txtName.text,
						title:  txtTitle.text,
						id:     _id || "link_" + new Date().getTime()
					});
				},200);
			}
		}
		
		private function init():void
		{
			if(opener)
			{
				ExternalInterface.call("function(id){" +
					"if(window[id]){" +
						"window[id].setLinkProperties=function(val){" +
							"var i,a,d,e=window[id].getActiveElement('A');" +
							"if(!e||e.tagName!='A'){" +
								"d=window[id].getDocument();" +
								"a=d.getElementsByTagName('A');" +
								"for(i=0;i<a.length;i++){" +
									"if(a[i].getAttribute('href')==val.href&&a[i].id!=val.id){e=a[i];break}" + 
								"}" + 
							"}" +
							"if(e)for(i in val)if(val[i]&&i!='href')e.setAttribute(i,val[i])" +
						"};" +
					"}"+ 
				"}", opener.editor.iframe.uid);
				
				var link:HTMLAnchorElement = new HTMLAnchorElement(ExternalInterface.call("function(id){" +
					"var a,obj=null;" + 
					"if(window[id]){" +
						"a=window[id].getActiveElement('A');" +
						"if(a&&a.tagName=='A')" +
							"obj={" +
								"href:a.getAttribute('href')," +
								"name:a.getAttribute('name')," + 
								"title:a.getAttribute('title')," + 
								"target:a.getAttribute('target')," +
								"id:a.getAttribute('id')," + 
								"nodeName:'A'," +
								"nodeType:1"+
							"}"+ 
					"}" + 
					"return obj;" + 
				"}", opener.editor.iframe.uid));
				
				if(link && link.nodeName=="A")
				{
					var obj:Object;

					if(link.href)
					{
						for each(obj in cmdProtocol.dataProvider)
						{
							if(link.href.indexOf(obj.label) == 0)
							{
								cmdProtocol.selectedItem = obj;
								txtUrl.text = link.href.substring(obj.label.length);
							}
						}
					}

					if(link.target)
						for each(obj in cmdTarget.dataProvider)
							if(link.target.indexOf(obj.label) == 0)
								cmdTarget.selectedItem = obj;
					

					txtName.text = link.name;
					txtTitle.text = link.title;
					_id = link.id;
				}

				opener.editor.storeSelection();
				//opener.editor.iframe.visible = false;
			}
		}
	}
}