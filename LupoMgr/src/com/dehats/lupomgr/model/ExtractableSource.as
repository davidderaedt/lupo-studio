package com.dehats.lupomgr.model
{
	import com.dehats.air.file.FileUtils;
	
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class ExtractableSource extends EventDispatcher
	{
		public static var flexPrefix:String="fx"; // could be mx if flex3
		public var file:File;
		public var name:String;
		public var relativePath:String;		
		public var fileContent:String;
		public var searchResult:ArrayCollection;		
		public var searchIndex:int=-1;
		public var originalContent:String;
		public var previousContent:String;		
		public var isMXML:Boolean;

		// get attributes value for text, label, (...) if it's not databinding or already localized with @Resource
		public static const DEFAULT_MXML_SEARCH:RegExp=/(?<=text=|label=|toolTip=|title=|icon=|String=|Error=|Separator=|Symbol=)"(?!@Resource)[^"{]*"/gi;
		// get strings with quotes and allow escaping chars
		public static const DEFAULT_CODE_SEARCH:RegExp=/"(?:[^"\\]|\\.)*"/gi;

		public static var MXML_SEARCH:RegExp;
		public static var CODE_SEARCH:RegExp;
		
		public static var useSmartSearch:Boolean=true;
		
		private static  var searchExclusionList:Array=["[Event(name=", "[Bindable(", "[Style(name=", "[Inspectable(category=", "[Exclude(name=", "[Inspectable(environment=", "[Embed(source=",
														"[AccessibilityClass(implementation=", "[DataBindingInfo(", "[IconFile(", "[DefaultProperty(", "[DefaultTriggerEvent(", "[DefaultBindingProperty(source=",
														"addEventListener(", "setStyle(", "getStyle(", "new Event(", "getChildByName(", "trace(", "SharedObject.getLocal(", "RegExp(",
														", type=", ", kind=", ", inherit=", "include ", ", format=", "arrayType=", ", enumeration=", "(defaultValue=", ", defaultValue="];
		private var fileLineEnding:String;
		
		
		public function ExtractableSource(pFile:File, pRelativeDir:File)
		{
			searchResult = new ArrayCollection();

			file = pFile;
			name = pFile.name;
			relativePath = pRelativeDir.getRelativePath(file, true);

			isMXML=(file.extension.toLowerCase()=="mxml");
			
		}
		
		public function init():void
		{
			searchIndex=-1;
			originalContent = FileUtils.getFileString(file);
			guessFileLineEnding();
			setContent(originalContent);			
		}
		
		private function guessFileLineEnding():void
		{
			if(originalContent.indexOf("\r\n")>-1) fileLineEnding = "\r\n";
			else if(originalContent.indexOf("\r")>-1) fileLineEnding = "\r";
			else
			{
				fileLineEnding = "\n";
			} 
			
		}
		
		public function setContent(pContent:String):void
		{
			previousContent = fileContent;
			fileContent =pContent;
			search();
		}
		
		
		public function save(pAS3Import:String, pMXMLImport:String):void
		{
			if(fileContent != originalContent)
			{
				if(file.extension=="as" && pAS3Import.length>0) addImportStatementAS3(pAS3Import);
				if(file.extension=="mxml" && pMXMLImport.length>0) addImportStatementAS3(pMXMLImport);				
			}
			
			FileUtils.writeTextInFile(file, fileContent);
			originalContent = fileContent;
		}
		
		public function hasChanged():Boolean
		{
			return originalContent!=fileContent;
		}
		
		public function undoChanges():void
		{
			setContent(originalContent);
		}
		
		public function undoLast():void
		{
			setContent(previousContent);
		}


		private function search():void
		{
			searchResult.removeAll();
			
			var pattern:RegExp = getSearchRegExp();
			var result:Array = pattern.exec(fileContent);
			
			while (result != null)
			{
			    //trace("RESULT:"+result.index, "-", pattern.lastIndex, "\t", result);		
//			    if(result.toString()!='""') searchResult.addItem(result);
			    if(! shouldBeIgnored(result, false) ) searchResult.addItem(result);
			    result = pattern.exec(fileContent);
			}
			
			// add AS3 in MXML results
			if( isMXML) searchAS3InMXML();
			
		}
		
		private function searchAS3InMXML():void
		{
			
			var pattern:RegExp = CODE_SEARCH;
			var result:Array = pattern.exec(fileContent);
			
			if( result==null) return ;
						
			while (result != null)
			{
			    //trace("RESULT:"+result.index, "\t", pattern.lastIndex, "\t", result);			    
			    if(shouldBeIgnored(result, true)==false) searchResult.addItem(result);
			    result = pattern.exec(fileContent);
			}
			
		}
		
		private function getSearchRegExp():RegExp
		{
			if( file.extension=="mxml") return MXML_SEARCH;
			else return CODE_SEARCH;
		}
		
		public function next():Array
		{
			
			if( searchResult==null || searchResult.length==0) return null;
			
			if( searchIndex>=searchResult.length-1)  searchIndex=-1;// end of search => loop
			
			searchIndex++;
			
			var result:Array = searchResult.getItemAt(searchIndex) as Array;
						
			return result;

		}

		public function previous():Array
		{
			
			if( searchResult==null || searchResult.length==0) return null;
			
			if( searchIndex<=0)  searchIndex=searchResult.length;// end of search => loop
			
			searchIndex--;
			
			var result:Array = searchResult.getItemAt(searchIndex) as Array;
						
			return result;

		}	
		
		private function shouldBeIgnored(result:Array, pAS3:Boolean):Boolean
		{
			if(pAS3 && (isAS3InMXML(result.index) ==false) ) return true;
			
			if(useSmartSearch==false) return false;
			
			if(result.toString()=='""') return true;
						
			if(isStringBefore(result.index, searchExclusionList)) return true;
			
			if(isInComments(result.index)) return true;
			if(isInComments2(result.index)) return true;
			
			return false;
		}		
				
		private function isStringBefore(pIndex:int, pStrList:Array):Boolean
		{
			var n:int = pStrList.length;
			for ( var i:int = 0 ; i < n ; i++)
			{
				var pStr:String = pStrList[i];
				if(fileContent.substr(pIndex-pStr.length, pStr.length)==pStr) return true
			}
			return false;
		}
		
		private function addImportStatementAS3(pClass:String):void
		{
			if(fileContent.indexOf("import "+pClass)>0) return ;
			fileContent = fileContent.replace(/import .*/i, "import "+pClass+";"+File.lineEnding+"\t$&");
		}

		private function addImportStatementMXML(pClass:String):void
		{
			if(fileContent.indexOf("import "+pClass)>0) return ;
			fileContent = fileContent.replace(/import .*/i, "import "+pClass+";"+File.lineEnding+"\t$&");
		}

		
		// tells if an index is between <mx:Script> tags
		public function isAS3InMXML(pIndex:int):Boolean
		{
			var i1:int = fileContent.indexOf("<"+flexPrefix+":Script>");
			if(i1==-1) return false;
			
			var i2:int = fileContent.indexOf("</"+flexPrefix+":Script>");
			
			return pIndex>i1 && pIndex<i2;
			
		}
		
		private function isInComments(pIndex:int):Boolean
		{
			var comOpenIndex:int = fileContent.indexOf("/*");
			if(comOpenIndex==-1) return false;
			if(pIndex<comOpenIndex) return false;
			
			while(comOpenIndex>-1)
			{
				var nextComEndIndex:int = fileContent.indexOf("*/", comOpenIndex);
				if(pIndex < nextComEndIndex) return true ;
				
				comOpenIndex = fileContent.indexOf("/*", nextComEndIndex);
				if(pIndex<comOpenIndex) return false;
			}
			
			return false
		}


		private function isInComments2(pIndex:int):Boolean
		{
			var comOpenIndex:int = fileContent.indexOf("//");
			if(comOpenIndex==-1) return false;
			if(pIndex<comOpenIndex) return false;
			
			while(comOpenIndex>-1)
			{
				var nextComEndIndex:int = fileContent.indexOf(fileLineEnding, comOpenIndex);
				
				if(nextComEndIndex==-1) return false;
				
				if(pIndex < nextComEndIndex) return true ;
				
				comOpenIndex = fileContent.indexOf("//", nextComEndIndex);
				if(pIndex<comOpenIndex) return false;
			}
			
			return false
		}
		
	}
}