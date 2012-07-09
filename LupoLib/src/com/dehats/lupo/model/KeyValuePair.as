package com.dehats.lupo.model
{
	[Bindable]
	public class KeyValuePair
	{
		public var comments:String;
		public var key:String;
		public var translation:String;
		public var value:String;
		
		public function get valueIsFile():Boolean
		{
			if(value==null) return false;
			
			return value.indexOf("Embed(")==0;
		}
		
		public function get valueIsClass():Boolean
		{
			if(value==null) return false;
			
			return value.indexOf("ClassReference(")==0;
		}
		
		public function get ignoreTranslation():Boolean
		{
			if(comments==null) return false;
			
			var tab:Array = comments.match(/@ignore/)
			
			if(tab && tab.length>0) return true;
			
			return false;
		}
		
		
	}
}