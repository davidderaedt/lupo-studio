package com.dehats.lupo.model
{
	import com.dehats.air.file.FileUtils;
	
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class PropFile
	{
		
		public var file:File;
		public var keyValuePairCollec:ArrayCollection;
		public var language:String;
		public var fileContent:String;
		public var hasChanged:Boolean=false;
/*		
		private var _searchFilterString:String="";		
		private var _filterTranslatedItems:Boolean = false;
		private var _filterEmbedItems:Boolean = false;
*/		
		public function PropFile(pFile:File, pLg:String)
		{
			language = pLg;
			file = pFile;
			parseFile( pFile); 
			
			hasChanged = false;// the first time we create it, we don't consider it as modified
		}

		public static function isPropertyFile(pFile:File):Boolean
		{
			return ( pFile.isDirectory==false && pFile.extension=="properties" ) ;
		}

		public function get name():String
		{
			return file.name;
		}
		
		public function get shortName():String
		{
			return file.name.split(".")[0];
		}
		
		public function get countryCode():String
		{
			return language.substring(3, 6);
		}


		public function parseFile(pFile:File):void
		{
			fileContent = FileUtils.getFileString(pFile);
			
			var parser:PropFileParser = new PropFileParser();
			
			keyValuePairCollec = parser.parseFile(fileContent);			
			
			hasChanged = true;
			
			//keyValuePairCollec.filterFunction = complexFilter;
			//keyValuePairCollec.refresh();
		}
		
		
		public function saveFile():void
		{			
			var newContent:String = getContent();
			
			FileUtils.writeTextInFile(file, newContent);
			
			fileContent = newContent;
			
			hasChanged = false;
		}
		
		
		public function getContent():String
		{
			var parser:PropFileParser = new PropFileParser();
			return parser.createFileStringFromCollec(keyValuePairCollec);
		}
		
		
		public function getPair(pKey:String):KeyValuePair
		{
			var n:int = keyValuePairCollec.length;
			for ( var i:int=0 ; i < n ; i++)
			{
				var pair:KeyValuePair = keyValuePairCollec.getItemAt(i) as KeyValuePair;
				//trace(pair.key+"<---->"+pKey);
				if(pair.key==pKey) return pair;
			}			
			
			return null;
		}
		
		public function addPair(pPair:KeyValuePair=null):KeyValuePair
		{
			
			if(pPair==null)
			{
				pPair = new KeyValuePair();
				pPair.key = "New";
				pPair.value = "Your value";
			}
			
			// TODO choose item placement
			
			keyValuePairCollec.addItem( pPair);
			
			hasChanged = true;
			
			return pPair;
		}
		
		
		public function removePair(pPair:KeyValuePair):void
		{
			var i:int = keyValuePairCollec.getItemIndex(pPair);
			keyValuePairCollec.removeItemAt(i);
			
			hasChanged = true;
		}
		

		public function renameKey(pOldPair:KeyValuePair, pNewKey:String):void
		{
			pOldPair.key = pNewKey;
			
			hasChanged = true;
		}


		public function setTranslations(pPropFile:PropFile):void
		{
			var n:int = keyValuePairCollec.length;
			for ( var i:int=0 ; i < n ; i++)
			{
				var myPair:KeyValuePair = keyValuePairCollec.getItemAt(i) as KeyValuePair;
				var translationPair:KeyValuePair = pPropFile.getPair(myPair.key);
				if( translationPair==null) myPair.translation = null;
				else myPair.translation = translationPair.value;
			}		
			
		}
		
		// Filters
/*		
		private function complexFilter(pItem:Object):Boolean
		{
			var pair:KeyValuePair = pItem as KeyValuePair;	
			
			if(filterTranslatedItems && pair.translation) return false;
			
			if(filterEmbedItems && pair.valueIsFile) return false;
			
			if(searchFilterString.length>0)
			{
				if( pair.key.toLowerCase().indexOf( _searchFilterString) == -1 && pair.value.toLowerCase().indexOf( _searchFilterString) == -1 )
				{
					if(pair.translation==null) return false;
					else if(pair.translation.toLowerCase().indexOf( _searchFilterString) == -1 ) return false;
				}
			}
			
			return true;
		}
		
		// translation filter		
		public function set filterTranslatedItems(pFilter:Boolean):void
		{
			_filterTranslatedItems = pFilter;			
			keyValuePairCollec.refresh();
		}
		public function get filterTranslatedItems():Boolean{return _filterTranslatedItems;}
		
		// embed filter		
		public function set filterEmbedItems(pFilter:Boolean):void
		{
			_filterEmbedItems = pFilter;
			keyValuePairCollec.refresh();
		}
		public function get filterEmbedItems():Boolean{return _filterEmbedItems;}
		
		// search filter
		public function set searchFilterString(pStr:String):void
		{
			_searchFilterString = pStr;			
			keyValuePairCollec.refresh();			
		}
		public function get searchFilterString():String{return _searchFilterString;}
*/		
	}
}