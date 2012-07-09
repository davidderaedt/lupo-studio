package com.dehats.lupo.presentation
{
	public class Country
	{
		
		public var name:String;
		public var code:String;
		
		public function Country(pName:String, pCode:String)
		{
			name = pName.toLowerCase();
			code = pCode.toLowerCase();
		}
		
		

	}
}