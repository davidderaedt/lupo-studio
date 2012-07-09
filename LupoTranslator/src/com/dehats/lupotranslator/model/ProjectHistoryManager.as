package com.dehats.lupotranslator.model
{
	import flash.data.EncryptedLocalStore;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	public class ProjectHistoryManager extends EventDispatcher
	{
		
		private static const ELSITEM_LASTPROJECT:String="lastProject";
		
		
		public function ProjectHistoryManager(target:IEventDispatcher=null)
		{
			super(target);
		}

		public function getPreviousProject():File
		{
			var storedValue:ByteArray = EncryptedLocalStore.getItem(ELSITEM_LASTPROJECT);
			
			if(storedValue!=null)
			{
				var path:String = storedValue.readMultiByte( storedValue.bytesAvailable, "UTF-8");
				var file:File = new File(path);
				if(file.exists) return file;
			}			
			
			return null;
		}
		
		
		public function addProject(pFile:File):void
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeMultiByte( pFile.nativePath, "UTF-8");
			EncryptedLocalStore.setItem( ELSITEM_LASTPROJECT, bytes );			
		}
		
	}
}