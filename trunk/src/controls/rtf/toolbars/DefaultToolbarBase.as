package controls.rtf.toolbars
{
	import controls.rtf.RtfEditor;
	
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import flash.utils.Timer;
	
	import mx.controls.richTextEditorClasses.ToolBar;
	import mx.events.FlexEvent;
	
	import org.w3.dom.html.HTMLElement;

	public class DefaultToolbarBase extends ToolBar
	{
		
		[Bindable] public var icons:DefaultToolbarIcons = new DefaultToolbarIcons();
			
		public var editor:RtfEditor;
		public const UPDATE_INTERVAL:int = 500;
		
		public function DefaultToolbarBase()
		{
			super();

			setStyle("borderThickness",0);
			setStyle("borderStyle","none");
			
			horizontalScrollPolicy="off";
			verticalScrollPolicy="off";
			
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			var timer:Timer = new Timer(UPDATE_INTERVAL);
			timer.addEventListener(TimerEvent.TIMER, function():void
			{
				update();
				try
				{
					new LocalConnection().connect('foo');
					new LocalConnection().connect('foo');
				}
				catch(error:Error)
				{
					//trace(System.totalMemory);
				}
			});
			timer.start();
		}
		
		protected function update():void
		{
			var element:HTMLElement = new HTMLElement(ExternalInterface.call("function(id){" +
				"if(window[id]){" +
					"var obj,elm=window[id].getActiveElement();" +
					"if(elm){" + 
						"obj={" +
							"nodeName:elm.tagName,"+ 
							"nodeType:1"+
						"}"+
					"}"+
					"return obj || null"+
				"}"+
			"}", editor.iframe.uid));
			
			if(element && element.nodeType > 0)
				for each(var button:ToolbarButton in buttons)
					button.update(element);
		}
		
		private var _buttons:Array = [];
		protected function get buttons():Array
		{
			if(_buttons.length == 0)
			{
				var children:Array = getChildren();
				for each(var button:Object in children)
					if(button is ToolbarButton)
						_buttons.push(button);
			}
			return _buttons;
		}
	}
}