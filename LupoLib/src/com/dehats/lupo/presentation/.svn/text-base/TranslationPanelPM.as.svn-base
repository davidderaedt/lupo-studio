package com.dehats.lupo.presentation
{
	import com.dehats.air.file.FileUtils;
	import com.dehats.lupo.model.Bundle;
	import com.dehats.lupo.model.CSVExportImport;
	import com.dehats.lupo.model.KeyValuePair;
	import com.dehats.lupo.model.PropFile;
	import com.dehats.lupo.model.TranslationMemory;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import mx.collections.ListCollectionView;
	import mx.controls.Alert;
	
	[Bindable]
	public class TranslationPanelPM extends AbsPMPM
	{
		public static const EVENT_TRANSLATION_COUNT_CHANGED:String="translationCountChanged";
		
		public var translationsPropFile:PropFile;
		public var sourcePropFile:PropFile;
		public var keyValuePairCollec:ListCollectionView;
		public var sourceLgFlag:Class;
		public var translationLgFlag:Class;
		public var warningMsg:String="";		
		public var translationIsPermitted:Boolean = true;		
		public var transCount:int=0;
		public var untransCount:int=0;		
		public var ignoredCount:int=0;
		public var progessPC:String;
		public var transWordCount:int=0;
		public var sourceWordCount:int=0;
		
		private var _bundle:Bundle;
		private var strictMode:Boolean;// tells if non target languages can be edited
		private var targetLanguages:Array;

		private var _searchFilterString:String="";		
		private var _filterTranslatedItems:Boolean = false;
		private var _filterEmbedItems:Boolean = false;
		private var translationMemory:TranslationMemory;

		
		public function TranslationPanelPM(pStrictMode:Boolean, pTM:TranslationMemory)
		{
			strictMode = pStrictMode;
			
			translationMemory = pTM;
			super();
		}
		
		public function setContext(pBundle:Bundle, targets:Array):void
		{
			_bundle = pBundle;

			dispatchEvent(new Event(Event.CHANGE));			

			targetLanguages = targets;
			
			if(bundle.propFileCollec.length==0) return ;
			
			var defaultPropFile:PropFile;
			for ( var i:int=0; i < bundle.propFileCollec.length ; i++)
			{
				var propFile:PropFile = bundle.propFileCollec.getItemAt(i) as PropFile;
				if(propFile == bundle.masterPropFile) defaultPropFile = propFile;
			}
			
			if( defaultPropFile==null) defaultPropFile = bundle.propFileCollec.getItemAt(0) as PropFile;
			
			selectSourcePropFile(defaultPropFile );
			
		}
		
		[Bindable("change")]
		public function get bundle():Bundle
		{
			return _bundle;
		}		
		
		
		public function selectSourcePropFile(pPropFile:PropFile):void
		{
			sourcePropFile = pPropFile;
			keyValuePairCollec = new ListCollectionView(sourcePropFile.keyValuePairCollec.list);
			keyValuePairCollec.filterFunction = complexFilter;
			keyValuePairCollec.refresh();

			sourceLgFlag = getFlag(sourcePropFile.countryCode.toLowerCase());

			if( sourcePropFile != bundle.masterPropFile) warningMsg = "Warning : The source language is not the master language.";
			else warningMsg="";
			
			// auto-select translations


			for ( var i:int=0; i < bundle.propFileCollec.length ; i++)
			{
				var propFile:PropFile = bundle.propFileCollec.getItemAt(i) as PropFile;
				// if there a transaltion language was already chosen, pick this language
				if(translationsPropFile!=null)
				{
					if(propFile.countryCode==translationsPropFile.countryCode)selectTranslationLanguage(propFile);
				}
				// else (ie on startup) pick the first that is not the master language
				else if(propFile != bundle.masterPropFile) selectTranslationLanguage( propFile );
			}
			
		}
				
		public function selectTranslationLanguage(pPropFile:PropFile):void
		{
			// prevents bugs
			//removeAllFilters();

			sourcePropFile.setTranslations(pPropFile);			
			translationsPropFile = pPropFile;
			translationLgFlag = getFlag(translationsPropFile.countryCode.toLowerCase());
			
			if( strictMode) translationIsPermitted = isTargetLanguage( pPropFile);
			else translationIsPermitted = true ;

			updateTranslationCount();
			
		}
/*		
		public function removeAllFilters():void
		{
			if(sourcePropFile==null) return ;
			
			searchFilterString="";
			filterEmbedItems=false;
			filterTranslatedItems=false;
		}
*/		
		// called after an import
		public function updateTranslations():void
		{
			sourcePropFile.setTranslations(translationsPropFile);
			updateTranslationCount();
			
		}
		
		private function isTargetLanguage(pPropFile:PropFile):Boolean
		{
			var n:int = targetLanguages.length ;
			for ( var i:int=0 ; i < n ; i++)
			{
				var target:String = targetLanguages[i];
				if( pPropFile.language==target) return true ;
			}			
			return false;
		}

 
 		public function setTranslation(pPair:KeyValuePair, pNewVal:String):void
		{	

			bundle.setTranslation(translationsPropFile, pPair, pNewVal);
			
			if(translationMemory) translationMemory.setTranslation(sourcePropFile.language, translationsPropFile.language, pPair.value, pNewVal);
			
			updateTranslationCount();
			
		}
		
		public function useTranslationMemory():void
		{
			
			var n:int = sourcePropFile.keyValuePairCollec.length;
			for (var i:int=0; i < n ; i++)
			{
				var pair:KeyValuePair = sourcePropFile.keyValuePairCollec.getItemAt(i) as KeyValuePair;
				if(pair.translation!=null) continue;
				var translation:String = translationMemory.getTranslations( sourcePropFile.language, translationsPropFile.language, pair.value);
				if(translation!=null) bundle.setTranslation(translationsPropFile, pair, translation);
			}
			
			updateTranslationCount();
		}

 		public function removeTranslationPair(pSourcePair:KeyValuePair):void
		{
			
			var translationPair:KeyValuePair = translationsPropFile.getPair(pSourcePair.key) ;
			
			if(translationPair== null )
			{
				promptErrorMessage("Cannot find key in translation file");
				return ;
			}
			
			translationsPropFile.removePair(translationPair);
			pSourcePair.translation=null;

			updateTranslationCount();
			
		}	
		
		public function save():void
		{
			translationsPropFile.saveFile();
		}		
		
		
		// very slow !! TODO : find a better way to count translations
		private function updateTranslationCount():void
		{
			sourceWordCount=0;
			transWordCount=0;
			ignoredCount=0;
			transCount=0;
			untransCount=0;
			
			var n:int = sourcePropFile.keyValuePairCollec.length;
			
			for ( var i:int=0 ; i < n ; i++)
			{
				var pair:KeyValuePair = sourcePropFile.keyValuePairCollec.getItemAt(i) as KeyValuePair;
				if(pair.ignoreTranslation)
				{
					ignoredCount++;
					continue;
				} 
				
				sourceWordCount += pair.value.match(/\w+/gi).length;
				
				if(pair.translation!=null) 
				{
					transCount++;
					transWordCount+= pair.translation.match(/\w+/gi).length; 
				}
			}				
			untransCount = n - transCount - ignoredCount;
			
			progessPC = int((transCount/(n-ignoredCount))*100).toString();
			
			dispatchEvent(new Event(EVENT_TRANSLATION_COUNT_CHANGED));	
		}
		
		public function removeUnusedEntries():void
		{
			var total:int = bundle.removedUnusedKeys(translationsPropFile);
			
			Alert.show(total+" pairs removed", "Info");
		}
		
		public function exportToCSV():void
		{			
			var csvFile:File = new File();
			csvFile.addEventListener(Event.SELECT, onCSVFileToExportSelected);
			csvFile.browseForSave("Save CSV file");			
		}
		
		private function onCSVFileToExportSelected(pEvt:Event):void
		{
			var csvFile:File = pEvt.target as File;			
			var csvExport:String = CSVExportImport.exportToCSV(sourcePropFile);		
			FileUtils.writeTextInFile(csvFile, csvExport);	

		}

		public function importFromCSV():void
		{
			var csvFile:File = new File();
			csvFile.addEventListener(Event.SELECT, onCSVFileToImportSelected);
			var filter:FileFilter = new FileFilter("csv file", "*.csv");
			csvFile.browseForOpen("Please select a CSV file", [filter]);
		}
		
		private function onCSVFileToImportSelected(pEvt:Event):void
		{
			var csvFile:File = pEvt.target as File;
			
			var fileString:String = FileUtils.getFileString(csvFile);
			
			var success:Boolean = CSVExportImport.importFromCSV(bundle, translationsPropFile, fileString);
			
			if(!success) promptErrorMessage("Unable to import this file");
			
		}

//		Filters

		private function complexFilter(pItem:Object):Boolean
		{
			var pair:KeyValuePair = pItem as KeyValuePair;	
			
			if(pair.ignoreTranslation) return false;
			
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


				
	}
}