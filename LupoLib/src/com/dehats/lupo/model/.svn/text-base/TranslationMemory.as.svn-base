package com.dehats.lupo.model
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	
	import mx.controls.Alert;
	
	public class TranslationMemory extends EventDispatcher
	{

		private var cnx:SQLConnection;
		
		public function TranslationMemory()
		{
		}
		
		
		public function init():void
		{
			
			var pFile:File = getOrCreateDBFile();
			
			cnx = new SQLConnection();
			cnx.open(pFile);			
		}
		
		private function getOrCreateDBFile():File
		{
			var f:File = File.applicationStorageDirectory.resolvePath("tm.db");
			
			if(f.exists) return f;
			
			var originalFile:File = File.applicationDirectory.resolvePath("assets/tm.db");
			if(originalFile.exists==false)
			{
				throw new Error("Translation memory DB could not be found in at "+originalFile.nativePath);
			}
			
			originalFile.copyTo(f);
			
			return f;
		}
		
		public function setTranslation(pSourceLg:String, pTargetLg:String, pSourceValue:String, pTargetValue:String):void
		{
			var trans:String  = getTranslations(pSourceLg, pTargetLg, pSourceValue);
			
			if(trans!=null)
			{
				updateTranslation(pSourceLg, pTargetLg, pSourceValue, pTargetValue);
				return;
			}
			
			
			var params:Object={};
			params["@source"] = pSourceLg.toLowerCase();
			params["@target"] = pTargetLg.toLowerCase();
			params["@source_value"] = pSourceValue.toLowerCase();
			params["@target_value"] = pTargetValue;
						
			var query:String="INSERT INTO translation (source, target, source_value, target_value) VALUES" + 
					"(@source, @target, @source_value, @target_value)";
						
			var result:SQLResult = executeStatement(query, params);			
		}
		
		private function updateTranslation(pSourceLg:String, pTargetLg:String, pSourceValue:String, pTargetValue:String):void
		{
			var params:Object={};
			params["@source"] = pSourceLg.toLowerCase();
			params["@target"] = pTargetLg.toLowerCase();
			params["@source_value"] = pSourceValue.toLowerCase();
			params["@target_value"] = pTargetValue;
						
			var query:String="UPDATE translation SET target_value=@target_value " + 
					"WHERE " + 
					"source=@source AND " + 
					"target=@target AND " + 
					"source_value=@source_value";
						
			var result:SQLResult = executeStatement(query, params);			
			
		}

		public function getTranslations(pSourceLg:String, pTargetLg:String, pSourceValue:String):String
		{
			
			var params:Object={};
			params["@source"] = pSourceLg.toLowerCase();
			params["@target"] = pTargetLg.toLowerCase();
			params["@source_value"] = pSourceValue.toLowerCase();
						
			var query:String="SELECT * FROM translation WHERE " + 
					"source=@source AND" + 
					" target=@target AND" + 
					" source_value=@source_value";
						
			var result:SQLResult = executeStatement(query, params);
			
			if(result==null) return null;
			
			if(result.data==null) return null;
			
			var firstResult:Object = result.data[0];
			
			return firstResult.target_value;
		}


		
		public function executeStatement(pStatement:String, pParams:Object=null):SQLResult
		{

			var stmt:SQLStatement = new SQLStatement();
			
			stmt.sqlConnection = cnx;
			stmt.text = pStatement;

			if( pParams)
			{
				// copy params
				for ( var z:String in pParams)  stmt.parameters[z] = pParams[z];
			}
			
			try
			{
			    stmt.execute();
			}
			catch (error:SQLError)
			{
				Alert.show(error.message+"\n"+error.details+"\nStatement:\n"+pStatement, "Error");
			}						
			
			return stmt.getResult();
		}
	}
}