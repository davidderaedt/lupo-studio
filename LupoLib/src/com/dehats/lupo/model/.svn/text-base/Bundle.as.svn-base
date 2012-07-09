package com.dehats.lupo.model
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class Bundle
	{
		public var name:String;
		public var propFileCollec:ArrayCollection=new ArrayCollection();
		public var masterPropFile:PropFile;
		
		public function Bundle(pName:String) 
		{
			name = pName;
		}
		
		public function get shortName():String
		{
			return name.split(".")[0];
		}		
		
		public function removeKey(pKey:String, pAutoSave:Boolean=false):void
		{
			var n:int = propFileCollec.length;
			for ( var i:int=0 ; i < n ; i++)
			{
				var pf:PropFile = propFileCollec.getItemAt(i) as PropFile;
				var pair:KeyValuePair = pf.getPair(pKey);
				if(pair!=null) pf.removePair(pair);
			}			
			
			if( pAutoSave) saveAll();			
		}
		
		public function refactorKey(pKey:String, pNewKey:String, pAutoSave:Boolean=false):void
		{

			var n:int = propFileCollec.length;
			for ( var i:int=0 ; i < n ; i++)
			{
				var pf:PropFile = propFileCollec.getItemAt(i) as PropFile;
				var pair:KeyValuePair = pf.getPair(pKey);
				if(pair!=null) pf.renameKey(pair, pNewKey);
			}
			
			if( pAutoSave) saveAll();
		}
		
		public function saveAll():void
		{
			var n:int = propFileCollec.length;
			for ( var i:int=0 ; i < n ; i++)
			{
				var pf:PropFile = propFileCollec.getItemAt(i) as PropFile;
				pf.saveFile();
			}				
		}
		
		public function getHasChanged():Boolean
		{
			var n:int = propFileCollec.length;
			for ( var i:int=0 ; i < n ; i++)
			{
				var pf:PropFile = propFileCollec.getItemAt(i) as PropFile;
				if(pf.hasChanged) return true;
			}	
			
			return false;
		}
		
		public function getPropFile(pLanguage:String):PropFile
		{
			var n:int = propFileCollec.length;
			for ( var i:int=0 ; i < n ; i++)
			{
				var propFile:PropFile = propFileCollec.getItemAt(i) as PropFile;
				if( propFile.language== pLanguage) return propFile;
			}			
			
			return null;
		}
		
		public function removedUnusedKeys(pPropFile:PropFile):int
		{
			
			if(pPropFile==masterPropFile) return 0;
			
			var n:int = pPropFile.keyValuePairCollec.length;
			
			var deletionList:Array = [];
			
			for ( var i:int=0 ; i < n ; i++)
			{
				var pair:KeyValuePair = pPropFile.keyValuePairCollec.getItemAt(i) as KeyValuePair;
				var masterPair:KeyValuePair = masterPropFile.getPair(pair.key);
				
				if(masterPair==null) 
				{
					deletionList.push(pair);
				}
			}			

			var m:int = deletionList.length;
			for ( var j:int=0 ; j < m ; j++)
			{
				var unusedpair:KeyValuePair = deletionList[j];
				pPropFile.removePair(unusedpair);				
			}
			
			return m;			
		}
		
		
		 		
		 		
		public function setTranslation(translationsPropFile:PropFile, pSourcePair:KeyValuePair, pNewVal:String):void
		{
			
			var translationPair:KeyValuePair = translationsPropFile.getPair(pSourcePair.key);
			
			if(pSourcePair==null) return ;
			
			// if the key entry already exists, update it
			if( translationPair!=null) 
			{
				masterPropFile.hasChanged = true;
				translationsPropFile.hasChanged = true;			
				pSourcePair.translation = pNewVal;
				translationPair.value = pNewVal;				
			}
			// if the entry wasn't translated and no translation has been given, keep it untranslated
			else if(pNewVal==null || pNewVal=="" || pNewVal==" ")
			{
				// ignore the change
			}
			// else, create the new translation
			else			
			{				
				var newPair:KeyValuePair = new KeyValuePair();
				newPair.key = pSourcePair.key;
				newPair.value = pNewVal;
				
				translationsPropFile.addPair( newPair);		
				pSourcePair.translation = pNewVal;		
				masterPropFile.hasChanged = true;				
			}
						
		}

	}
}