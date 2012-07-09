package com.dehats.lupomgr.presentation
{
	import com.dehats.lupo.model.Bundle;
	import com.dehats.lupo.model.KeyValuePair;
	import com.dehats.lupo.presentation.AbsPMPM;
	import com.dehats.lupo.presentation.AssetManager;
	
	import flash.filesystem.File;
	
	import mx.collections.ListCollectionView;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	
	[Bindable]
	public class MasterFilePanelPM extends AbsPMPM
	{
		
		public var keyValuePairCollec:ListCollectionView;		
		public var selectedPairIndex:int;
		public var icon_delete:Class = AssetManager.icon_delete;		
		public var projectSrc:File; 

		private var tmpPair:KeyValuePair;
		private var _bundle:Bundle;
		private var _searchFilterString:String="";
		
		public function MasterFilePanelPM()
		{
			super();
		}
		
		public function set bundle(pBundle:Bundle):void
		{
			_bundle = pBundle;
			keyValuePairCollec = new ListCollectionView(bundle.masterPropFile.keyValuePairCollec);
			keyValuePairCollec.filterFunction = complexFilter;
			keyValuePairCollec.refresh();
		}
		public function get bundle():Bundle
		{
			return _bundle;
		}

		public function updatePairKey(pPair:KeyValuePair, pNewVal:String):void
		{						
			if(pPair.key== pNewVal) return ;
			
			// Key refactoring 
			bundle.refactorKey(pPair.key, pNewVal);
		}
		
		public function touch():void
		{
			bundle.masterPropFile.hasChanged = true; 
		}

		public function addPair():void
		{
			var pair:KeyValuePair = bundle.masterPropFile.addPair();
			selectedPairIndex = bundle.masterPropFile.keyValuePairCollec.getItemIndex(pair);
		}	
		
		public function save():void
		{
			// save master file
			bundle.masterPropFile.saveFile();
			// save all other languages (to propagate modifications done in keys)
			bundle.saveAll();
		}

		public function askRemovePair(pPair:Object):void
		{
			tmpPair = pPair as KeyValuePair;
			
			Alert.show("Do you really want to delete this item in every language ("+tmpPair.key+") ?", 
						"Warning",
						Alert.YES|Alert.NO,
						null,
						onRemovePairAnswer);				
		}
		
		private function onRemovePairAnswer(pEvt:CloseEvent):void
		{
			if( pEvt.detail == Alert.YES) removePair(tmpPair);
			else tmpPair = null;
		}		

		private function removePair(pPair:KeyValuePair):void
		{
			bundle.removeKey(pPair.key);
		}	


//		Filters

		private function complexFilter(pItem:Object):Boolean
		{
			var pair:KeyValuePair = pItem as KeyValuePair;	
						
			if(searchFilterString.length>0)
			{
				if( pair.key.toLowerCase().indexOf( _searchFilterString) == -1 && pair.value.toLowerCase().indexOf( _searchFilterString) == -1 )
				{
					return false;
				}
			}
			
			return true;
		}
		
				
		// search filter
		public function set searchFilterString(pStr:String):void
		{
			_searchFilterString = pStr;			
			keyValuePairCollec.refresh();			
		}
		public function get searchFilterString():String{return _searchFilterString;}
		

	}
}