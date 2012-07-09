package com.dehats.lupo.presentation
{
	import mx.collections.ArrayCollection;
	
	public class CountryReference
	{
		
		private static var coList:ArrayCollection;
		
		public function CountryReference()
		{
		}

		
		private static function addCo(pName:String, pCode:String):void
		{
			var co:Country = new Country(pName, pCode);
			coList.addItem(co);
		}
		
		public static function getCoNameByCode(pCode:String):String
		{
			if(coList==null) init();
			
			var code:String = pCode.toLowerCase();
			
			var n:int = coList.length;
			
			for ( var i:int=0 ; i < n ; i++)
			{
				var co:Country = coList.getItemAt(i) as Country;
				if(co.code==code) return co.name;
			}
			
			return null;
		}

		public static function getCOCodeByName(pName:String):String
		{
			if(coList==null) init();
			
			var name:String = pName.toLowerCase();
			
			var n:int = coList.length;
			
			for ( var i:int=0 ; i < n ; i++)
			{
				var co:Country = coList.getItemAt(i) as Country;
				if(co.name==name) return co.code;
			}
			
			return null;
		}		
		
		public static function init():void
		{
			coList = new ArrayCollection();
			
			addCo("AFGHANISTAN", "AF");
			addCo("LAND ISLANDS", "AX");
			addCo("ALBANIA", "AL");
			addCo("ALGERIA", "DZ");
			addCo("AMERICAN SAMOA", "AS");
			addCo("ANDORRA", "AD");
			addCo("ANGOLA", "AO");
			addCo("ANGUILLA", "AI");
			addCo("ANTARCTICA", "AQ");
			addCo("ANTIGUA AND BARBUDA", "AG");
			addCo("ARGENTINA", "AR");
			addCo("ARMENIA", "AM");
			addCo("ARUBA", "AW");
			addCo("AUSTRALIA", "AU");
			addCo("AUSTRIA", "AT");
			addCo("AZERBAIJAN", "AZ");
			addCo("BAHAMAS", "BS");
			addCo("BAHRAIN", "BH");
			addCo("BANGLADESH", "BD");
			addCo("BARBADOS", "BB");
			addCo("BELARUS", "BY");
			addCo("BELGIUM", "BE");
			addCo("BELIZE", "BZ");
			addCo("BENIN", "BJ");
			addCo("BERMUDA", "BM");
			addCo("BHUTAN", "BT");
			addCo("BOLIVIA", "BO");
			addCo("BOSNIA AND HERZEGOVINA", "BA");
			addCo("BOTSWANA", "BW");
			addCo("BOUVET ISLAND", "BV");
			addCo("BRAZIL", "BR");
			addCo("BRITISH INDIAN OCEAN TERRITORY", "IO");
			addCo("BRUNEI DARUSSALAM", "BN");
			addCo("BULGARIA", "BG");
			addCo("BURKINA FASO", "BF");
			addCo("BURUNDI", "BI");
			addCo("CAMBODIA", "KH");
			addCo("CAMEROON", "CM");
			addCo("CANADA", "CA");
			addCo("CAPE VERDE", "CV");
			addCo("CAYMAN ISLANDS", "KY");
			addCo("CENTRAL AFRICAN REPUBLIC", "CF");
			addCo("CHAD", "TD");
			addCo("CHILE", "CL");
			addCo("CHINA", "CN");
			addCo("CHRISTMAS ISLAND", "CX");
			addCo("COCOS (KEELING) ISLANDS", "CC");
			addCo("COLOMBIA", "CO");
			addCo("COMOROS", "KM");
			addCo("CONGO", "CG");
			addCo("CONGO, THE DEMOCRATIC REPUBLIC OF THE", "CD");
			addCo("COOK ISLANDS", "CK");
			addCo("COSTA RICA", "CR");
			addCo("C‘TE D'IVOIRE", "CI");
			addCo("CROATIA", "HR");
			addCo("CUBA", "CU");
			addCo("CYPRUS", "CY");
			addCo("CZECH REPUBLIC", "CZ");
			addCo("DENMARK", "DK");
			addCo("DJIBOUTI", "DJ");
			addCo("DOMINICA", "DM");
			addCo("DOMINICAN REPUBLIC", "DO");
			addCo("ECUADOR", "EC");
			addCo("EGYPT", "EG");
			addCo("EL SALVADOR", "SV");
			addCo("EQUATORIAL GUINEA", "GQ");
			addCo("ERITREA", "ER");
			addCo("ESTONIA", "EE");
			addCo("ETHIOPIA", "ET");
			addCo("FALKLAND ISLANDS (MALVINAS)", "FK");
			addCo("FAROE ISLANDS", "FO");
			addCo("FIJI", "FJ");
			addCo("FINLAND", "FI");
			addCo("FRANCE", "FR");
			addCo("FRENCH GUIANA", "GF");
			addCo("FRENCH POLYNESIA", "PF");
			addCo("FRENCH SOUTHERN TERRITORIES", "TF");
			addCo("GABON", "GA");
			addCo("GAMBIA", "GM");
			addCo("GEORGIA", "GE");
			addCo("GERMANY", "DE");
			addCo("GHANA", "GH");
			addCo("GIBRALTAR", "GI");
			addCo("GREECE", "GR");
			addCo("GREENLAND", "GL");
			addCo("GRENADA", "GD");
			addCo("GUADELOUPE", "GP");
			addCo("GUAM", "GU");
			addCo("GUATEMALA", "GT");
			addCo("GUERNSEY", "GG");
			addCo("GUINEA", "GN");
			addCo("GUINEA-BISSAU", "GW");
			addCo("GUYANA", "GY");
			addCo("HAITI", "HT");
			addCo("HEARD ISLAND AND MCDONALD ISLANDS", "HM");
			addCo("HOLY SEE (VATICAN CITY STATE)", "VA");
			addCo("HONDURAS", "HN");
			addCo("HONG KONG", "HK");
			addCo("HUNGARY", "HU");
			addCo("ICELAND", "IS");
			addCo("INDIA", "IN");
			addCo("INDONESIA", "ID");
			addCo("IRAN, ISLAMIC REPUBLIC OF", "IR");
			addCo("IRAQ", "IQ");
			addCo("IRELAND", "IE");
			addCo("ISLE OF MAN", "IM");
			addCo("ISRAEL", "IL");
			addCo("ITALY", "IT");
			addCo("JAMAICA", "JM");
			addCo("JAPAN", "JP");
			addCo("JERSEY", "JE");
			addCo("JORDAN", "JO");
			addCo("KAZAKHSTAN", "KZ");
			addCo("KENYA", "KE");
			addCo("KIRIBATI", "KI");
			addCo("KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF", "KP");
			addCo("KOREA, REPUBLIC OF", "KR");
			addCo("KUWAIT", "KW");
			addCo("KYRGYZSTAN", "KG");
			addCo("LAO PEOPLE'S DEMOCRATIC REPUBLIC", "LA");
			addCo("LATVIA", "LV");
			addCo("LEBANON", "LB");
			addCo("LESOTHO", "LS");
			addCo("LIBERIA", "LR");
			addCo("LIBYAN ARAB JAMAHIRIYA", "LY");
			addCo("LIECHTENSTEIN", "LI");
			addCo("LITHUANIA", "LT");
			addCo("LUXEMBOURG", "LU");
			addCo("MACAO", "MO");
			addCo("MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF", "MK");
			addCo("MADAGASCAR", "MG");
			addCo("MALAWI", "MW");
			addCo("MALAYSIA", "MY");
			addCo("MALDIVES", "MV");
			addCo("MALI", "ML");
			addCo("MALTA", "MT");
			addCo("MARSHALL ISLANDS", "MH");
			addCo("MARTINIQUE", "MQ");
			addCo("MAURITANIA", "MR");
			addCo("MAURITIUS", "MU");
			addCo("MAYOTTE", "YT");
			addCo("MEXICO", "MX");
			addCo("MICRONESIA, FEDERATED STATES OF", "FM");
			addCo("MOLDOVA, REPUBLIC OF", "MD");
			addCo("MONACO", "MC");
			addCo("MONGOLIA", "MN");
			addCo("MONTENEGRO", "ME");
			addCo("MONTSERRAT", "MS");
			addCo("MOROCCO", "MA");
			addCo("MOZAMBIQUE", "MZ");
			addCo("MYANMAR", "MM");
			addCo("NAMIBIA", "NA");
			addCo("NAURU", "NR");
			addCo("NEPAL", "NP");
			addCo("NETHERLANDS", "NL");
			addCo("NETHERLANDS ANTILLES", "AN");
			addCo("NEW CALEDONIA", "NC");
			addCo("NEW ZEALAND", "NZ");
			addCo("NICARAGUA", "NI");
			addCo("NIGER", "NE");
			addCo("NIGERIA", "NG");
			addCo("NIUE", "NU");
			addCo("NORFOLK ISLAND", "NF");
			addCo("NORTHERN MARIANA ISLANDS", "MP");
			addCo("NORWAY", "NO");
			addCo("OMAN", "OM");
			addCo("PAKISTAN", "PK");
			addCo("PALAU", "PW");
			addCo("PALESTINIAN TERRITORY, OCCUPIED", "PS");
			addCo("PANAMA", "PA");
			addCo("PAPUA NEW GUINEA", "PG");
			addCo("PARAGUAY", "PY");
			addCo("PERU", "PE");
			addCo("PHILIPPINES", "PH");
			addCo("PITCAIRN", "PN");
			addCo("POLAND", "PL");
			addCo("PORTUGAL", "PT");
			addCo("PUERTO RICO", "PR");
			addCo("QATAR", "QA");
			addCo("R…UNION", "RE");
			addCo("ROMANIA", "RO");
			addCo("RUSSIAN FEDERATION", "RU");
			addCo("RWANDA", "RW");
			addCo("SAINT BARTH…LEMY", "BL");
			addCo("SAINT HELENA", "SH");
			addCo("SAINT KITTS AND NEVIS", "KN");
			addCo("SAINT LUCIA", "LC");
			addCo("SAINT MARTIN", "MF");
			addCo("SAINT PIERRE AND MIQUELON", "PM");
			addCo("SAINT VINCENT AND THE GRENADINES", "VC");
			addCo("SAMOA", "WS");
			addCo("SAN MARINO", "SM");
			addCo("SAO TOME AND PRINCIPE", "ST");
			addCo("SAUDI ARABIA", "SA");
			addCo("SENEGAL", "SN");
			addCo("SERBIA", "RS");
			addCo("SEYCHELLES", "SC");
			addCo("SIERRA LEONE", "SL");
			addCo("SINGAPORE", "SG");
			addCo("SLOVAKIA", "SK");
			addCo("SLOVENIA", "SI");
			addCo("SOLOMON ISLANDS", "SB");
			addCo("SOMALIA", "SO");
			addCo("SOUTH AFRICA", "ZA");
			addCo("SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS", "GS");
			addCo("SPAIN", "ES");
			addCo("SRI LANKA", "LK");
			addCo("SUDAN", "SD");
			addCo("SURINAME", "SR");
			addCo("SVALBARD AND JAN MAYEN", "SJ");
			addCo("SWAZILAND", "SZ");
			addCo("SWEDEN", "SE");
			addCo("SWITZERLAND", "CH");
			addCo("SYRIAN ARAB REPUBLIC", "SY");
			addCo("TAIWAN, PROVINCE OF CHINA", "TW");
			addCo("TAJIKISTAN", "TJ");
			addCo("TANZANIA, UNITED REPUBLIC OF", "TZ");
			addCo("THAILAND", "TH");
			addCo("TIMOR-LESTE", "TL");
			addCo("TOGO", "TG");
			addCo("TOKELAU", "TK");
			addCo("TONGA", "TO");
			addCo("TRINIDAD AND TOBAGO", "TT");
			addCo("TUNISIA", "TN");
			addCo("TURKEY", "TR");
			addCo("TURKMENISTAN", "TM");
			addCo("TURKS AND CAICOS ISLANDS", "TC");
			addCo("TUVALU", "TV");
			addCo("UGANDA", "UG");
			addCo("UKRAINE", "UA");
			addCo("UNITED ARAB EMIRATES", "AE");
			addCo("UNITED KINGDOM", "GB");
			addCo("UNITED STATES", "US");
			addCo("UNITED STATES MINOR OUTLYING ISLANDS", "UM");
			addCo("URUGUAY", "UY");
			addCo("UZBEKISTAN", "UZ");
			addCo("VANUATU", "VU");
			addCo("VENEZUELA", "VE");
			addCo("VIET NAM", "VN");
			addCo("VIRGIN ISLANDS, BRITISH", "VG");
			addCo("VIRGIN ISLANDS, U.S.", "VI");
			addCo("WALLIS AND FUTUNA", "WF");
			addCo("WESTERN SAHARA", "EH");
			addCo("YEMEN", "YE");
			addCo("ZAMBIA", "ZM");
			addCo("ZIMBABWE", "ZW");
			
										
			
		}


	}
}