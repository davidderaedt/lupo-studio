package com.dehats.lupo.presentation
{
	import mx.collections.ArrayCollection;
	
	public class LanguagesReference
	{
		
		private static var lgList:ArrayCollection;
		
		public function LanguagesReference()
		{
		}
		
		
		private static function addLg(pName:String, pCode:String):void
		{
			var lg:Language = new Language(pName, pCode);
			lgList.addItem(lg);
		}
		
		public static function getLGNameByCode(pCode:String):String
		{
			if(lgList==null) init();
			
			var code:String = pCode.toLowerCase();
			
			var n:int = lgList.length;
			
			for ( var i:int=0 ; i < n ; i++)
			{
				var lg:Language = lgList.getItemAt(i) as Language;
				if(lg.code==code) return lg.name;
			}
			
			return null;
		}

		public static function getLGCodeByName(pName:String):String
		{
			if(lgList==null) init();
			
			var name:String = pName.toLowerCase();
			
			var n:int = lgList.length;
			
			for ( var i:int=0 ; i < n ; i++)
			{
				var lg:Language = lgList.getItemAt(i) as Language;
				if(lg.name==name) return lg.code;
			}
			
			return null;
		}		
		
		public static function init():void
		{
			lgList = new ArrayCollection();
			
			addLg("ABKHAZIAN", "AB");
			addLg("AFAN (OROMO);", "OM");
			addLg("AFAR", "AA");
			addLg("AFRIKAANS", "AF");
			addLg("ALBANIAN", "SQ");
			addLg("AMHARIC", "AM");
			addLg("ARABIC", "AR");
			addLg("ARMENIAN", "HY");
			addLg("ASSAMESE", "AS");
			addLg("AYMARA", "AY");
			addLg("AZERBAIJANI", "AZ");
			addLg("BASHKIR", "BA");
			addLg("BASQUE", "EU");
			addLg("BENGALI;BANGLA", "BN");
			addLg("BHUTANI", "DZ");
			addLg("BIHARI", "BH");
			addLg("BISLAMA", "BI");
			addLg("BRETON", "BR");
			addLg("BULGARIAN", "BG");
			addLg("BURMESE", "MY");
			addLg("BYELORUSSIAN", "BE");
			addLg("CAMBODIAN", "KM");
			addLg("CATALAN", "CA");
			addLg("CHINESE", "ZH");
			addLg("CORSICAN", "CO");
			addLg("CROATIAN", "HR");
			addLg("CZECH", "CS");
			addLg("DANISH", "DA");
			addLg("DUTCH", "NL");
			addLg("ENGLISH", "EN");
			addLg("ESPERANTO", "EO");
			addLg("ESTONIAN", "ET");
			addLg("FAROESE", "FO");
			addLg("FIJI", "FJ");
			addLg("FINNISH", "FI");
			addLg("FRENCH", "FR");
			addLg("FRISIAN", "FY");
			addLg("GALICIAN", "GL");
			addLg("GEORGIAN", "KA");
			addLg("GERMAN", "DE");
			addLg("GREEK", "EL");
			addLg("GREENLANDIC", "KL");
			addLg("GUARANI", "GN");
			addLg("GUJARATI", "GU");
			addLg("HAUSA", "HA");
			addLg("HEBREW", "HE");
			addLg("HINDI", "HI");
			addLg("HUNGARIAN", "HU");
			addLg("ICELANDIC", "IS");
			addLg("INDONESIAN", "ID");
			addLg("INTERLINGUA", "IA");
			addLg("INTERLINGUE", "IE");
			addLg("INUKTITUT", "IU");
			addLg("INUPIAK", "IK");
			addLg("IRISH", "GA");
			addLg("ITALIAN", "IT");
			addLg("JAPANESE", "JA");
			addLg("JAVANESE", "JV");
			addLg("KANNADA", "KN");
			addLg("KASHMIRI", "KS");
			addLg("KAZAKH", "KK");
			addLg("KINYARWANDA", "RW");
			addLg("KIRGHIZ", "KY");
			addLg("KURUNDI", "RN");
			addLg("KOREAN", "KO");
			addLg("KURDISH", "KU");
			addLg("LAOTHIAN", "LO");
			addLg("LATIN", "LA");
			addLg("LATVIAN;LETTISH", "LV");
			addLg("LINGALA", "LN");
			addLg("LITHUANIAN", "LT");
			addLg("MACEDONIAN", "MK");
			addLg("MALAGASY", "MG");
			addLg("MALAY", "MS");
			addLg("MALAYALAM", "ML");
			addLg("MALTESE", "MT");
			addLg("MAORI", "MI");
			addLg("MARATHI", "MR");
			addLg("MOLDAVIAN", "MO");
			addLg("MONGOLIAN", "MN");
			addLg("NAURU", "NA");
			addLg("NEPALI", "NE");
			addLg("NORWEGIAN", "NO");
			addLg("OCCITAN", "OC");
			addLg("ORIYA", "OR");
			addLg("PASHTO;PUSHTO", "PS");
			addLg("PERSIAN(farsi);", "FA");
			addLg("POLISH", "PL");
			addLg("PORTUGUESE", "PT");
			addLg("PUNJABI", "PA");
			addLg("QUECHUA", "QU");
			addLg("RHAETO-ROMANCE", "RM");
			addLg("ROMANIAN", "RO");
			addLg("RUSSIAN", "RU");
			addLg("SAMOAN", "SM");
			addLg("SANGHO", "SG");
			addLg("SANSKRIT", "SA");
			addLg("SCOTS", "GA");
			addLg("ELIC", "GD");
			addLg("SERBIAN", "SR");
			addLg("SERBO-CROATIAN", "SH");
			addLg("SESOTHO", "ST");
			addLg("SETSWANA", "TN");
			addLg("SHONA", "SN");
			addLg("SINDHI", "SD");
			addLg("SINGHALESE", "SI");
			addLg("SISWATI", "SS");
			addLg("SLOVAK", "SK");
			addLg("SLOVENIAN", "SL");
			addLg("SOMALI", "SO");
			addLg("SPANISH", "ES");
			addLg("SUNDANESE", "SU");
			addLg("SWAHILI", "SW");
			addLg("SWEDISH", "SV");
			addLg("TAGALOG", "TL");
			addLg("TAJIK", "TG");
			addLg("TAMIL", "TA");
			addLg("TATAR", "TT");
			addLg("TELUGU", "TE");
			addLg("THAI", "TH");
			addLg("TIBETAN", "BO");
			addLg("TIGRINYA", "TI");
			addLg("TONGA", "TO");
			addLg("TSONGA", "TS");
			addLg("TURKISH", "TR");
			addLg("TURKMEN", "TK");
			addLg("TWI", "TW");
			addLg("UIGUR", "UG");
			addLg("UKRAINIAN", "UK");
			addLg("URDU", "UR");
			addLg("UZBEK", "UZ");
			addLg("VIETNAMESE", "VI");
			addLg("VOLAPUK", "VO");
			addLg("WELSH", "CY");
			addLg("WOLOF", "WO");
			addLg("XHOSA", "XH");
			addLg("YIDDISH", "YI");
			addLg("YORUBA", "YO");
			addLg("ZHUANG", "ZA");
			addLg("ZULU", "ZU");
								
			
		}

	}
}