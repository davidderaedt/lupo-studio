package com.dehats.lupo.presentation
{
	import flash.events.EventDispatcher;
	
	import mx.controls.Alert;
	
	public class AbsPMPM extends EventDispatcher
	{
		public function AbsPMPM()
		{
		}

		public function getFlag(pCountryCode:String):Class
		{
			return AssetManager["flag_"+pCountryCode.toLowerCase()];
		}
		
		protected function promptErrorMessage(pMsg:String):void
		{
			Alert.show(pMsg, "Error", 4, null, null, AssetManager.icon_warning);
		}
		
		public function getLanguageName(pCode:String):String
		{
			return  LanguagesReference.getLGNameByCode(pCode);
		}
		
		public function getLanguageCode(pName:String):String
		{
			return LanguagesReference.getLGCodeByName(pName);
		}

		public function getCountryName(pCode:String):String
		{
			return  CountryReference.getCoNameByCode(pCode);
		}
		
		public function getCountryCode(pName:String):String
		{
			return CountryReference.getCOCodeByName(pName);
		}
		
		
		public function getLabelByLGCOCode(pCode:String):String
		{
			if(pCode.indexOf("_")==-1) return getLanguageName(pCode);
			
			var arr:Array = pCode.split("_");
			var lgCode:String = arr[0];
			var coCode:String = arr[1];
			
			var lgName:String = getLanguageName(lgCode);
			var coName:String = getCountryName(coCode);
			
			return lgName+", "+coName;
			
		}
		

	}
}