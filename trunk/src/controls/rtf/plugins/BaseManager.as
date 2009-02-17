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
			//setStyle("backgroundAlpha",1);
			addEventListener(CloseEvent.CLOSE, onClose);
			addEventListener(FlexEvent.CREATION_COMPLETE, function(event:FlexEvent):void{
				opener.editor.hideIframes();
			});
		}
		
		private function onClose(event:CloseEvent):void
		{
			PopUpManager.removePopUp(this);
			opener.editor.restoreIframes();
		}
	}
}