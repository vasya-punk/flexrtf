package controls.rtf.plugins.tree
{
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.controls.Tree;
	import mx.events.FlexEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.rpc.http.mxml.HTTPService;

	[Event(name="complete", type="mx.events.Event")]

	public class FileTree extends Tree
	{
		protected var service:mx.rpc.http.mxml.HTTPService = new mx.rpc.http.mxml.HTTPService();
		private var _url:String = "";
		
		public function FileTree()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		
		[Bindable]
		public function get url():String
		{
			return _url;
		}
		
		public function set url(value:String):void
		{
			_url = value;
			reload();
		}
		
		public function reload():void
		{
			if(_url)
			{
				service.url = _url;
				service.showBusyCursor = true;
				service.send();
			}
		}
		
		private function creationCompleteHandler(event:FlexEvent):void
		{
			labelField = "@label";
			showRoot = false;
			
			service.useProxy = false;
			service.method = "GET";
			service.resultFormat = mx.rpc.http.HTTPService.RESULT_FORMAT_E4X;
			service.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void
			{
				dataProvider = service.lastResult;
				dispatchEvent(new Event(Event.COMPLETE));
			});
			
			service.addEventListener(FaultEvent.FAULT, function(event:FaultEvent):void
			{
				Alert.show(event.message.toString(), event.fault.name);
			});

			reload();
		}
	}
}