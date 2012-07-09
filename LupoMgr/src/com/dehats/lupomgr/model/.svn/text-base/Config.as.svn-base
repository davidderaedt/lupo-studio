package com.dehats.lupomgr.model
{
	import com.dehats.lupo.model.PropFileParser;
	import com.dehats.lupomgr.presentation.SourceExtractionPM;
	
	import flash.data.EncryptedLocalStore;
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author davidderaedt
	 * 
	 * 	Not used for now
	 * 
	 * TODO see if a config is necessary
	 * 
	 */
	 
	[Bindable]
	public class Config
	{

		public static const ELS_SEARCH_PATTERNS:String="searchPatterns";// 0:MXML, 1 : AS3		
		public static const ELS_BLANK_LINE:String="addBlankLine";
		public static const ELS_REPLACEMENTS:String="codereplacement";//0:MXML, 1:AS3, 2:AS3INMXML
		public static const ELS_KEY_PREFIX:String="useKeyPrefix";
		
//		public static const ELS_REPL_MXML:String="mxmlreplacement";
//		public static const ELS_REPL_AS3:String="as3replacement";
//		public static const ELS_REPL_AS3_MXML:String="as3mxmlreplacement";
		
		public var mxmlSearchPattern:String;
		public var as3SearchPattern:String;
		public var addBlankLine:Boolean;
		public var replaceMxml:String;
		public var replaceAS3:String;
		public var replaceAS3inMXML:String;
		public var useKeyPrefix:Boolean;
		
		
		public function Config()
		{
			loadConfig();
		}

		private function loadConfig():void
		{
			var searchPatternsBytes:ByteArray = EncryptedLocalStore.getItem(ELS_SEARCH_PATTERNS);			
			var blankLineValue:ByteArray = EncryptedLocalStore.getItem(ELS_BLANK_LINE);
			var codeReplacementsBytes:ByteArray = EncryptedLocalStore.getItem(ELS_REPLACEMENTS);
			var keyPrefixBytes:ByteArray = EncryptedLocalStore.getItem(ELS_KEY_PREFIX);
/*
			var replaceMxmlValue:ByteArray = EncryptedLocalStore.getItem(ELS_REPL_MXML);
			var replaceAS3Value:ByteArray = EncryptedLocalStore.getItem(ELS_REPL_AS3);
			var replaceAS3InMXMLValue:ByteArray = EncryptedLocalStore.getItem(ELS_REPL_AS3_MXML);
*/
			
			if(searchPatternsBytes==null) defaultPatterns();
			else
			{
				var searchPatternTab:Array = searchPatternsBytes.readObject() as Array;
				mxmlSearchPattern = searchPatternTab[0];
				as3SearchPattern = searchPatternTab[1];
			} 			
			
			if(blankLineValue==null) addBlankLine=false;
			else addBlankLine = blankLineValue.readBoolean();


			if(codeReplacementsBytes==null) defaultReplacements();
			else
			{
				var replacements:Array = codeReplacementsBytes.readObject() as Array;
				replaceMxml = replacements[0];//replaceMxmlValue.readMultiByte( replaceMxmlValue.bytesAvailable, "UTF-8");
				replaceAS3 = replacements[1];//replaceAS3Value.readMultiByte( replaceAS3Value.bytesAvailable, "UTF-8");
				replaceAS3inMXML = replacements[2];//replaceAS3InMXMLValue.readMultiByte( replaceAS3InMXMLValue.bytesAvailable, "UTF-8");				
			}
			
			if(keyPrefixBytes==null) useKeyPrefix=false;
			else useKeyPrefix = keyPrefixBytes.readBoolean();
			
			apply();
		}
		
		public function apply():void
		{
			ExtractableSource.MXML_SEARCH = new RegExp(mxmlSearchPattern, "gi");
			ExtractableSource.CODE_SEARCH = new RegExp(as3SearchPattern, "gi");		
			
			PropFileParser.useLineEndingSeparator = addBlankLine;	
			
			SourceExtractionPM.defaultReplacements[0].data = replaceMxml;
			SourceExtractionPM.defaultReplacements[1].data = replaceAS3inMXML;
			SourceExtractionPM.defaultReplacements[2].data = replaceAS3;
			
			SourceExtractionPM.prefixKeyWithFilename = useKeyPrefix;
		}

		public function defaultPatterns():void
		{			
			mxmlSearchPattern = ExtractableSource.DEFAULT_MXML_SEARCH.source;				
			as3SearchPattern = ExtractableSource.DEFAULT_CODE_SEARCH.source;
		}

		public function defaultReplacements():void
		{
			replaceMxml = SourceExtractionPM.defaultDefaultReplacements[0].data;
			replaceAS3inMXML = SourceExtractionPM.defaultDefaultReplacements[1].data;
			replaceAS3 = SourceExtractionPM.defaultDefaultReplacements[2].data;
		}
		
		
		public function saveConfig():void
		{
			// patterns
			var searchPatternBytes:ByteArray = new ByteArray();
			searchPatternBytes.writeObject([mxmlSearchPattern, as3SearchPattern]);
			EncryptedLocalStore.setItem(ELS_SEARCH_PATTERNS, searchPatternBytes);
						
			// blank line
			var blankLineBytes:ByteArray = new ByteArray();
			blankLineBytes.writeBoolean(addBlankLine);
			EncryptedLocalStore.setItem(ELS_BLANK_LINE, blankLineBytes);
			
			//replacements
			var replacementsBytes:ByteArray = new ByteArray();
			replacementsBytes.writeObject([replaceMxml, replaceAS3, replaceAS3inMXML]);
			EncryptedLocalStore.setItem(ELS_REPLACEMENTS, replacementsBytes);
			
			// key prefix
			var keyPrefixBytes:ByteArray = new ByteArray();
			keyPrefixBytes.writeBoolean(useKeyPrefix);
			EncryptedLocalStore.setItem(ELS_KEY_PREFIX, keyPrefixBytes);
			
			
/*			
			var replacemxmlBytes:ByteArray = new ByteArray();
			replacemxmlBytes.writeMultiByte( replaceMxml, "UTF-8");
			EncryptedLocalStore.setItem(ELS_REPL_MXML, replacemxmlBytes);						

			var replaceas3Bytes:ByteArray = new ByteArray();
			replaceas3Bytes.writeMultiByte( replaceAS3, "UTF-8");
			EncryptedLocalStore.setItem(ELS_REPL_AS3, replaceas3Bytes);						

			var replaceas3inmxmlBytes:ByteArray = new ByteArray();
			replaceas3inmxmlBytes.writeMultiByte( replaceAS3inMXML, "UTF-8");
			EncryptedLocalStore.setItem(ELS_REPL_AS3_MXML, replaceas3inmxmlBytes);						
*/			
		}
		
	}
}