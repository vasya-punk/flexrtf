package controls.rtf.plugins.image
{
	import controls.rtf.plugins.PopupButton;

	public class ToolbarButton extends controls.rtf.plugins.PopupButton
	{
		public function ToolbarButton()
		{
			super();
			popupClass = ImageManager;
		}
	}
}