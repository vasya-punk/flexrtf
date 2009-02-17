package controls.rtf.toolbars
{
	import controls.rtf.RtfEditor;
	
	import flash.events.MouseEvent;
	
	import mx.controls.ComboBox;
	import mx.events.DropdownEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;

	public class ToolbarComboBox extends ComboBox
	{
		[Bindable] public var command:String = "";
		 
		public function ToolbarComboBox()
		{
			super();
			setStyle("cornerRadius",0);
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, onOpen);
			//addEventListener(DropdownEvent.OPEN, onOpen);
			addEventListener(DropdownEvent.CLOSE, onClose);
			addEventListener(ListEvent.CHANGE, onChange);
		}
		
		private function onChange(event:ListEvent):void
		{
			if(editor)
				editor.execCommand(command, false, selectedLabel);
		}
		
		private function onOpen(event:Event):void
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