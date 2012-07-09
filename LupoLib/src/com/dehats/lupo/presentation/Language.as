package com.dehats.lupo.presentation
{
	public class Language
	{
		public function Language(pName:String, pCode:String)
		{
			name = pName.toLowerCase();
			code = pCode.toLowerCase();
		}
		
		public var name:String;
		public var code:String;

	}
}