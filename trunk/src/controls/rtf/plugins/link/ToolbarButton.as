package controls.rtf.plugins.link
{
	import controls.rtf.plugins.PopupButton;

	public class ToolbarButton extends controls.rtf.plugins.PopupButton
	{
		public function ToolbarButton()
		{
			super();
			popupClass = LinkManager;
		}
	}
}