package controls.rtf
{
	import controls.html.HTMLIFrameElement;
	import controls.rtf.toolbars.DefaultToolbar;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import mx.containers.Accordion;
	import mx.containers.Panel;
	import mx.containers.ViewStack;
	import mx.core.Application;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.rpc.xml.SimpleXMLEncoder;

	[ResourceBundle("messages")]

	public class RtfEditor extends Panel
	{
		public var iframe:HTMLIFrameElement = new HTMLIFrameElement();
		
		private var _toolbar:DefaultToolbar = new DefaultToolbar();
		private var _toolbarChanged:Boolean;
		
		private var _htmlText:String = "";
		private var _htmlTextChanged:Boolean = false;
		
		private var _jsInstance:String;
		
		public function RtfEditor()
		{
			super();
			layout="vertical";
			setStyle("headerHeight", 10);
			initEditor();

			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		private function onCreationComplete(event:Event):void
		{
			var _parent:DisplayObject = this;
			while(_parent != parentApplication)
			{
				UIComponent(_parent).setStyle("backgroundAlpha", 0);
				_parent.addEventListener(FlexEvent.UPDATE_COMPLETE, onUpdateComplete);
				if(_parent.parent) _parent = _parent.parent;
				else break;
			}
		}
		
		private function onUpdateComplete(event:FlexEvent):void
		{
			var container:Container = event.target as Container;
			var selectedChild:Container = null;
			if(container.numChildren > 0)
			{
				if(container is Accordion)
					selectedChild = (container as Accordion).selectedChild;
				else if(container is ViewStack) //or TabNavigator
					selectedChild = (container as ViewStack).selectedChild;
			
				if(selectedChild)
					visible = (selectedChild.contains(this)) ? selectedChild.visible : false;
			}
		}
		
		override public function setFocus():void
		{
			super.setFocus();
			iframe.setFocus();
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			iframe.visible = value;
		}
		
		public function execCommand(command:String, userInterface:Boolean=false, value:Object=null):void
		{
			ExternalInterface.call(_jsInstance + ".execCommand", command, userInterface, value);
		}
		
		public function storeSelection():void
		{
			ExternalInterface.call(_jsInstance + ".selection.store");
		}
		
		public function restoreSelection():void
		{
			ExternalInterface.call(_jsInstance + ".selection.restore");
		}
		
		public function getActiveElement():Object
		{
			return ExternalInterface.call(_jsInstance + ".getActiveElement");
		}
		
		[Bindable]
		public function set htmlText(value:String):void
		{
			_htmlText = value;
			_htmlTextChanged = true;
			invalidateProperties();
		}
		
		public function get htmlText():String
		{
			var html:String = String(ExternalInterface.call(_jsInstance + ".getContent"));
			return html || _htmlText;
		}
		
		public function set toolbar(value:DefaultToolbar):void
		{
			if(_toolbar)
				removeChild(_toolbar);
				
			_toolbar = value;
			_toolbarChanged = true;
			invalidateProperties();
		}
		
		public function get toolbar():DefaultToolbar
		{
			return _toolbar;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			addChildAt(toolbar, 0);
			addChildAt(iframe, 1);

			setStyle("verticalGap",0);
			iframe.source = "javascript:document.open();document.write('<html><body bgcolor=white><div>&nbsp;</div></body></html>');document.close();";
			toolbar.editor = this;
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(_toolbarChanged)
			{
				addChildAt(toolbar, 0);
				toolbar.editor = this;
				_toolbarChanged = false;
			}
			
			if(_htmlTextChanged)
			{
				ExternalInterface.call(_jsInstance + ".setContent", _htmlText);
				_htmlTextChanged = false;
			}
		}
		
		public function hideIframes():void
		{
			ExternalInterface.call("function(app){" +
				"var i,f=document.getElementsByTagName('IFRAME');"+
				"app=document.getElementById(app);"+
				"if(app){" + 
					"app.style.zIndex=100;"+
					//"if(window.VBArray)app.style.position='relative';"+
				"}"+
				"for(i=0;i<f.length;i++){" +
					"if(f[i].getAttribute('type')=='rtf'){"+
						"if(window.XULElement){"+
							"f[i].__display=f[i].style.display||'block';"+
							"f[i].style.display='none';"+
						"}" + 
						"f[i].__zIndex=f[i].style.zIndex||100;"+
						"f[i].style.zIndex=1;"+ 
					"}"+
				"}"+ 
				"if(window.VBArray)window.focus();"+
			"}", Application.application.id);
		}
		
		public function restoreIframes():void
		{
			ExternalInterface.call("function(app){" +
				"var i,f=document.getElementsByTagName('IFRAME');" +
				"app=document.getElementById(app);" +
				"if(app)app.style.zIndex=1;" +
				"for(i=0;i<f.length;i++){" + 
					"if(f[i].getAttribute('type')=='rtf'){" +
						"if(window.XULElement&&f[i].__display)f[i].style.display=f[i].__display;" +
						"if(f[i].__zIndex)f[i].style.zIndex=f[i].__zIndex;" +
					"}" +
				"}" +
			"}", Application.application.id);
		}
		
		private function initEditor():void
		{
			if(ExternalInterface.available)
			{
				ExternalInterface.call("function(id){" +
					"if(window[id]){" +
						"window[id].iframe.setAttribute('type','rtf');"+
						"window[id].getContent=function(){" +
							"var doc=window[id].getDocument();"+
							"return (doc&&doc.body)?doc.body.innerHTML:''"+
						"};"+
						"window[id].setContent=function(str){" +
							"(function(){"+
								"var doc=window[id].getDocument();"+
								"if(doc&&doc.body&&doc.designMode.toLowerCase()=='on')doc.body.innerHTML=str;"+
								"else setTimeout(arguments.callee,100)"+
							"})();" + 
						"};" +
						"window[id].selection={" +
							"getSelection:function(){" +
								"var sel,doc=window[id].getDocument();" + 
								"if(doc){" +
							 	 	"try{" + 
							 	 		"sel=doc.selection?doc.selection:(doc.defaultView?doc.defaultView.getSelection():doc.getSelection())" + 
							 	 	"}catch(ex){" +
							 	 		"alert(ex.message||ex);"+ 
							 	 	"}"+
							 	 "}"+
							 	 "return sel"+
							"},"+
							"store:function(){" +
								"var rng,sel=this.getSelection();"+
								"if(sel){" + 
									"if(sel.rangeCount&&sel.rangeCount>0){"+
										"rng=sel.getRangeAt(0);"+
										"rng=rng.cloneRange()"+
									"}else if(sel.type&&sel.type.toLowerCase()=='text')"+
										"rng=sel.createRange().getBookmark()"+
								"}"+
								"this.range=rng"+ 
							"},"+
							"restore:function(){" +
								"if(this.range){" +
									"var rng,doc,sel=this.getSelection();"+
									"if(sel){" +
										"doc=window[id].getDocument();" + 
										"if(sel.removeAllRanges&&sel.addRange){"+
											"sel.removeAllRanges();"+
											"sel.addRange(this.range)"+
										"}else if(doc&&doc.body&&doc.body.createTextRange){" +
											"rng=doc.body.createTextRange();"+
											"rng.moveToBookmark(this.range);"+
											"rng.select()"+ 
										"}"+
									"}"+ 
								"}"+ 
							"}"+ 
						"};"+
						"window[id].execCommand=function(cmd,ui,val){" +
							"var doc=window[id].getDocument();" +
							"try{" + 
								"doc.execCommand(cmd,ui,val);" + 
								"if(window[id][cmd])window[id][cmd](val)"+
							"}catch(ex){" +
								"if(window[id][cmd])window[id][cmd](val)"+
							"}" +
						"};"+
						"window[id].getActiveElement=function(tag){" +
						 	"var elm,rng,sel,doc=window[id].getDocument();" +
						 	"if(doc){" +
						 		"/*if(doc.activeElement)elm=doc.activeElement;"+
						 		"else */if(window[id].activeElement)elm=window[id].activeElement;"+
						 		"else{"+
							 	 	"sel=window[id].selection.getSelection();" +
							 	 	"if(sel){"+
								 	 	"if(sel.createRange) {"+
											"rng=sel.createRange();" +
											"elm=sel.type=='Control'?rng(0):rng.parentElement();"+
											//"if(!elm){" +
											//	 "elm=rng.commonParentElement();"+
											//	 "alert(elm);"+
											//"}"+
										"}else if(sel.getRangeAt){" +
											"rng=sel.getRangeAt(0);"+
										 	"var cnt=rng.startContainer;"+
										 	"if(sel.anchorNode&&sel.anchorNode==sel.focusNode){" + 
										 		"if(rng.collapsed||cnt.nodeType==3)elm=sel.anchorNode.parentNode;"+
										 	 	"else elm=sel.anchorNode"+
										 	"}"+
										"}"+
									"}"+
								"}"+
								"return elm"+
						 	"}"+
						"};"+
						"(function(){" + 
							"var doc=window[id].getDocument();" +
							"if(doc)setTimeout(function(){" + 
								"doc.designMode='on';" +
								"window[id].iframe.style.borderTop='solid 1px #A2ADB3';"+
								"(function(){"+
									"if(doc.body){"+
										"function _oncontextmenu(e){" +
											"if(e&&e.stopPropagation)e.stopPropagation();"+ 
											"if(e&&e.preventDefault)e.preventDefault();"+
											"return false" + 
										"}"+
										"if(doc.body.addEventListener){" + 
											"doc.body.addEventListener('contextmenu',_oncontextmenu,true);"+
											"doc.body.addEventListener('mousedown',function(e){" +
												"window[id].activeElement=e.target;"+
											"},false)"+
										"}"+
										"else{" + 
											"doc.body.oncontextmenu=_oncontextmenu;"+
											"doc.body.attachEvent('onmousedown',function(e){" +
												"var win,doc=window[id].getDocument();"+
												"win=doc.parentWindow;"+
												"window[id].activeElement=win.event&&win.event.srcElement;"+
											"})"+
										"}"+
									"}else setTimeout(arguments.callee,100)"+
								"})()"+ 
							"},100);" +
							"else setTimeout(arguments.callee,100)" +
						"})();" + 
					"}" +
				"}", iframe.uid);
				
				_jsInstance = "window['" + iframe.uid + "']";
			}
		}
	}
}