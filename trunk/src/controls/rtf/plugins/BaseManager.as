package controls.rtf.plugins
{
	import controls.rtf.toolbars.DefaultToolbar;
	
	import mx.containers.TitleWindow;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;

	public class BaseManager extends TitleWindow
	{
		public var opener:DefaultToolbar;
		
		public function BaseManager()
		{
			super();

			addEventListener(CloseEvent.CLOSE, onClose);
			addEventListener(FlexEvent.CREATION_COMPLETE, function(event:FlexEvent):void
			{
				removeEventListener(FlexEvent.CREATION_COMPLETE, arguments.callee);
				if(opener) opener.editor.hideIframes();
			});
		}
		
		private function onClose(event:CloseEvent):void
		{
			PopUpManager.removePopUp(this);
			if(opener) opener.editor.restoreIframes();
		}
	}
}