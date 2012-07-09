package com.dehats.lupo.model
{
	import flash.filesystem.File;
	
	import mx.events.IndexChangedEvent;
	
	public class CSVExportImport
	{
		public function CSVExportImport()
		{
		}
		
		public static function exportToCSV(pMasterPropFile:PropFile):String
		{
			var separator:String = ",";
			
			
			var csvFileString:String = '"key"'+separator+'"comment"'+separator+'"source"'+separator+'"translation"'+File.lineEnding;
			
			
			var n:int = pMasterPropFile.keyValuePairCollec.length;
			for ( var i:int=0 ; i < n ; i++)
			{
				var pair:KeyValuePair = pMasterPropFile.keyValuePairCollec.getItemAt(i) as KeyValuePair;
				
				
				var translation:String = pair.translation;
				if( translation==null) translation="";
				
				csvFileString+='"'+pair.key+'"'+separator+'"'+pair.comments+'"'+separator+'"'+pair.value+'"'+separator+'"'+translation+'"'+separator+File.lineEnding;
			}			
			
			return (csvFileString);
			
		}


		public static function importFromCSV(pBundle:Bundle, pDestPropFile:PropFile, pCSVString:String, separator:String = ","):Boolean
		{

			// replace the original separator by a custom one to avoid cutting into text values
			//warning : this will match cases when several you have severl consecutive separators like ",,"
			var customSeparatorPattern:RegExp = new RegExp("(?<=\"|"+ separator+")"+separator, "gi");
			var customSeparator:String="---XxXxX---";
			pCSVString = pCSVString.replace(customSeparatorPattern, customSeparator);
			//trace(pCSVString)

	
			// Warning: this won't work if file was created on another OS
			var lineEnding:String = File.lineEnding;
			var lines:Array =pCSVString.split(lineEnding);
			
			var firstLine:String = lines[0];			
			
			
			if(firstLine.indexOf('"key"'+customSeparator+'"comment"'+customSeparator+'"source"'+customSeparator+'"translation"') !=0)
			{
				// there was a problem parsing the csv file
				trace("unable to parse csv file, first line:"+firstLine);
				return false;
			}
			
			var n:int = lines.length;
			
			for ( var i:int = 1 ; i < n ; i++)
			{
				var line:String = lines[i];
				
				if(line=="") continue;
				
				var values:Array = line.split(customSeparator);
				
				if(values==null || values.length==0) continue;
				
				if(values.length<4)
				{
					trace("unable to parse:"+line);
					continue;
				}
				
				var key:String = values[0];
				var translation:String = values[3];
				trace("got:"+values)
				trace("Translation:"+translation)				
				var pattern:RegExp = new RegExp("\"", "g");
				key = key.replace( pattern, "");
				translation = translation.replace(pattern, "");
				if(translation=="") translation=null;
				
				
				if(key=="")
				{
					trace("empty key found at:"+line);
					continue;
				}
				
				var pPair:KeyValuePair = pBundle.masterPropFile.getPair(key);
				
				if(pPair==null)
				{
					trace("Did not find key "+key+" at:"+line);
					continue;					
				}
				
				trace("setting translation:"+translation)
				pBundle.setTranslation(pDestPropFile, pPair, translation);
				
				
			}
			
			
			return true;		
			
		}

		
/* 
		public static function importFromCSV(pBundle:Bundle, pDestPropFile:PropFile, pCSVString:String, separator:String = ","):Boolean
		{

			// replace the original separator by a custom one to avoid cutting into text values
			//warning : this will match cases when several you have severl consecutive separators like ",,"
			var customSeparatorPattern:RegExp = new RegExp("(?<=\"|"+ separator+")"+separator, "gi");			
			var customSeparator:String="---XxXxX---";
			pCSVString = pCSVString.replace(customSeparatorPattern, customSeparator);

			
			// Warning: this won't work if file was created on another OS
			var lineEnding:String = File.lineEnding;
			var lines:Array =pCSVString.split(lineEnding);
			
			var firstLine:String = lines[0];			
			
			if(firstLine.indexOf('"key"'+customSeparator+'"comment"'+customSeparator+'"source"'+customSeparator+'"translation"') !=0)
			{
				// there was a problem parsing the csv file
				trace("unable to parse csv file, first line:"+firstLine);
				return false;
			}
			
			var n:int = lines.length;
			
			for ( var i:int = 1 ; i < n ; i++)
			{
				var line:String = lines[i];
				
				if(line=="") continue;
				
				var values:Array = line.split(customSeparator);
				
				if(values==null || values.length==0) continue;
				
				if(values.length<4)
				{
					trace("unable to parse:"+line);
					continue;
				}
				
				var key:String = values[0];
				var translation:String = values[3];
				
				var pattern:RegExp = new RegExp("\"", "g");
				key = key.replace( pattern, "");
				translation = translation.replace(pattern, "");
				if(translation=="") translation=null;
				
				
				if(key=="")
				{
					trace("empty key found at:"+line);
					continue;
				}
				
				var pPair:KeyValuePair = pBundle.masterPropFile.getPair(key);
				
				if(pPair==null)
				{
					trace("Did not find key "+key+" at:"+line);
					continue;					
				}
								
				pBundle.setTranslation(pDestPropFile, pPair, translation);
				
				
			}
			
			
			return true;		
		}
 */

	}
}