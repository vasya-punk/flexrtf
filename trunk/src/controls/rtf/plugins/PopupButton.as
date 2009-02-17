package controls.rtf.plugins
{
	import controls.rtf.toolbars.DefaultToolbar;
	import controls.rtf.toolbars.ToolbarButton;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.managers.PopUpManager;
	
	public class PopupButton extends controls.rtf.toolbars.ToolbarButton
	{
		protected var popupClass:Class;
		
		public function PopupButton()
		{
			super();
		}
		
		override protected function onClick(event:MouseEvent):void
		{
			var toolbar:DefaultToolbar = null;
			
			if(owner is DefaultToolbar)
				toolbar = owner as DefaultToolbar;
			else if(parent is DefaultToolbar)
				toolbar = parent as DefaultToolbar;
				
			var win:BaseManager = PopUpManager.createPopUp(parentApplication as DisplayObject, popupClass, true) as BaseManager;
			win.opener = toolbar;
			PopUpManager.centerPopUp(win);
		}
	}
}