package controls.rtf
{
	public class RtfUtils
	{
		public function RtfUtils()
		{
		}

		public static function uintToString(hex:uint):String
		{ 
			var hexString:* = hex.toString(16).toUpperCase(); 
			var cnt:int = 6 - hexString.length; 
			var zeros:String = ""; 
			for(var i:int = 0; i<cnt; i++)
				zeros += "0";
			return "#" + zeros + hexString; 
		}
	}
}