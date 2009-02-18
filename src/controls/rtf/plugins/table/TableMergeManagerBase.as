package controls.rtf.plugins.table
{
	import controls.rtf.plugins.BaseManager;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	import mx.controls.RadioButtonGroup;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;

	public class TableMergeManagerBase extends BaseManager
	{
		public var btnMerge:Button;
		public var btnCancel:Button;
		
		[Bindable] protected var merge:RadioButtonGroup = new RadioButtonGroup();
		
		public function TableMergeManagerBase()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			//if(btnMerge)
			//	btnMerge.addEventListener(MouseEvent.CLICK, onInsertClick);
				
			if(btnCancel)
				btnCancel.addEventListener(MouseEvent.CLICK, onCancelClick);
				
			//init();
		}
		
		private function onCancelClick(event:MouseEvent):void
		{
			dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
			if(opener)
				opener.editor.iframe.setFocus();
		}
	}
}