package controls.rtf.toolbars
{
	import controls.rtf.RtfEditor;
	import controls.rtf.RtfUtils;
	
	import flash.geom.Point;
	
	import mx.controls.ColorPicker;
	import mx.events.ColorPickerEvent;
	import mx.events.DropdownEvent;
	import mx.events.FlexEvent;
	import mx.events.ToolTipEvent;
	import mx.managers.ToolTipManager;

	public class ToolbarColorPicker extends ColorPicker
	{
		[Bindable] public var command:String = "";
		
		public function ToolbarColorPicker()
		{
			super();
			width = 24;
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(ToolTipEvent.TOOL_TIP_SHOW, onToolTipShow);
		}
		
		private function onToolTipShow(event:ToolTipEvent):void
		{
			var globalPt:Point = localToGlobal(new Point(0, 0));
			ToolTipManager.currentToolTip.y = globalPt.y - 1;
			ToolTipManager.currentToolTip.x = globalPt.x + width;
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			addEventListener(DropdownEvent.OPEN, onOpen);
			addEventListener(DropdownEvent.CLOSE, onClose);
			addEventListener(ColorPickerEvent.CHANGE, onChange);
		}
		
		private function onChange(event:ColorPickerEvent):void
		{
			if(editor)
			{
				var color:String = RtfUtils.uintToString(uint(value));
				editor.execCommand(command, false, color);
			}
		}
		
		private function onOpen(event:DropdownEvent):void
		{
			if(editor)
				editor.hideIframes();
		}
		
		private function onClose(event:DropdownEvent):void
		{
			if(editor)
				editor.restoreIframes();
		}
		
		private var _editor:RtfEditor = null;
		
		private function get editor():RtfEditor
		{
			if(!_editor)
			{
				if(owner is DefaultToolbar)
					_editor = (owner as DefaultToolbar).editor;
				else if(parent is DefaultToolbar)
					_editor = (parent as DefaultToolbar).editor;
			}
			return _editor;
		}
	}
}