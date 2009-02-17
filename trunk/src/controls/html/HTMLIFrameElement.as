package controls.html
{
	import controls.rtf.RtfUtils;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.events.MoveEvent;
	import mx.events.ResizeEvent;
	import mx.events.ScrollEvent;

	public class HTMLIFrameElement extends Canvas
	{
		private var _source: String;
		private var _jsInstance:String;
        
		public function HTMLIFrameElement()
		{
			super();
			
			percentWidth = 100;
			percentHeight = 100;
			
			createHTMLIFrameElement();
    		addEventListener(MoveEvent.MOVE, onResizeHandler);
    		addEventListener(ResizeEvent.RESIZE, onResizeHandler);
    		addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompleteHandler);
		}
		
		public function set source(value: String): void
        {
            if(value)
            {
                _source = value;
                if(_jsInstance)
                	ExternalInterface.call(_jsInstance + ".load", value);
            }
        }

        public function get source(): String
        {
            return _source;
        }

		override public function setFocus():void
		{
			super.setFocus();
			if(_jsInstance)
				ExternalInterface.call(_jsInstance +  ".focus");
		}

		override public function set visible(value: Boolean): void
		{
			super.visible = value;
			if(_jsInstance)
				ExternalInterface.call(_jsInstance + (value ? ".show" : ".hide"));
			invalidateDisplayList();
		}
		
		private function createHTMLIFrameElement():void
		{
			if(ExternalInterface.available)
			{
				ExternalInterface.call("function(id){" +
					"window[id]={" + 
						"init:function(){" + 
							"this.iframe=document.createElement('IFRAME');this.iframe.frameBorder=0;" +
							"this.iframe.setAttribute('id',id);"+
							"this.iframe.setAttribute('allowTransparency',true);"+
							"with(this.iframe.style){position='absolute';background='transparent';top=0;left=0;border=0}" +
							"document.body.appendChild(this.iframe)" + 
						"}," +
						"getDocument:function(){" + 
							"if(this.iframe.contentDocument)return this.iframe.contentDocument;" +
							"else if(this.iframe.contentWindow)return this.iframe.contentWindow.document;"+ 
							"else if(this.iframe.document)return this.iframe.document;"+
							"return null" +
						"},"+
						"focus:function(){" +
							"var doc=this.getDocument();"+
							"if(doc){" +
								"if(doc.parentWindow)doc.parentWindow.focus();"+
								"if(doc.defaultView)setTimeout(function(){doc.defaultView.focus()},100)"+
							"}"+ 
						"},"+
						"resize:function(x,y,w,h){with(this.iframe.style){left=x+'px';top=y+'px';width=w+'px';height=h+'px'}}," +
						"load:function(src){this.iframe.src=src}," +
						"hide:function(){this.iframe.style.display='none';window.focus()}," +
						"show:function(){this.iframe.style.display='block'}" +
					"};" +
					"window[id].init();" +
				"}", uid);
				
				_jsInstance = "window['" + uid + "']";
			}
		}
		
		private function onCreationCompleteHandler(event:Event) :void
        {
			Application.application.addEventListener(ResizeEvent.RESIZE, onResizeHandler);
			Application.application.addEventListener(ScrollEvent.SCROLL, onResizeHandler);
			
			var color:uint = Application.application.getStyle("backgroundColor");
			if(color)
			{
				ExternalInterface.call("function(color){" +
					"var d=document;if(d&&d.body)d.body.style.backgroundColor=color" + 
				"}", RtfUtils.uintToString(color));
				Application.application.setStyle("backgroundAlpha", 0);
			}
        }
        
		private function onResizeHandler(e:*=null): void
		{
			if(_jsInstance)
				callLater(function():void {
					var globalPt:Point = localToGlobal(new Point(0, 0));
					ExternalInterface.call(_jsInstance + ".resize", globalPt.x, globalPt.y, width, height);
				});
		}
	}
}