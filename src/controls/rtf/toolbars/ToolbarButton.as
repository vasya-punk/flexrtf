package controls.rtf.toolbars
{
	import controls.rtf.RtfCommands;
	import controls.rtf.RtfEditor;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.controls.Button;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.events.ToolTipEvent;
	import mx.managers.ToolTipManager;
	
	import org.w3.dom.html.HTMLElement;

	use namespace mx_internal;
	
	public class ToolbarButton extends Button
	{
		[Bindable] public var command:String = "";
		
		public function ToolbarButton()
		{
			super();
			width = 24;
			setStyle("paddingLeft",0);
			setStyle("paddingRight",0);
			setStyle("cornerRadius",0);
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(ToolTipEvent.TOOL_TIP_SHOW, onToolTipShow);
		}
		
		public function update(node:HTMLElement):void
		{
			if(command == RtfCommands.UNLINK)
				enabled = node.nodeName == "A";
			else if(command == RtfCommands.BOLD)
				mx_internal::phase = (node.nodeName == "B" || node.nodeName == "STRONG") ? "down" : "up";
			else if(command == RtfCommands.ITALIC)
				mx_internal::phase = (node.nodeName == "I" || node.nodeName == "EM") ? "down" : "up";
			else if(command == RtfCommands.UNDERLINE)
				mx_internal::phase = (node.nodeName == "U") ? "down" : "up";
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			alpha = value ? 1 : 0.5;
		}
		
		private function onToolTipShow(event:ToolTipEvent):void
		{
			var globalPt:Point = localToGlobal(new Point(0, 0));
			ToolTipManager.currentToolTip.y = globalPt.y - 1;
			ToolTipManager.currentToolTip.x = globalPt.x + width;
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var editor:RtfEditor = null;
			if(owner is DefaultToolbar)
				editor = (owner as DefaultToolbar).editor;
			else if(parent is DefaultToolbar)
				editor = (parent as DefaultToolbar).editor;
				
			if(editor && command)
				editor.execCommand(command);
		}
	}
}