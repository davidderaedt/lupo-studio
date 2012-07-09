package com.dehats.lupomgr.presentation
{
	import com.dehats.lupo.model.Bundle;
	import com.dehats.lupo.model.KeyValuePair;
	import com.dehats.lupo.model.Project;
	import com.dehats.lupo.presentation.AbsPMPM;
	import com.dehats.lupomgr.model.ExtractableSource;
	
	import flash.filesystem.File;
	import flash.xml.XMLDocument;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.TextArea;
	import mx.controls.textClasses.TextRange;
	import mx.events.CloseEvent;

	[Bindable]
	public class SourceExtractionPM extends AbsPMPM
	{

		public static const EVENT_END_OF_EXTRACTION:String="endOfExtraction";

		public static var prefixKeyWithFilename:Boolean=false;

		public static var defaultDefaultReplacements:Array=[
												{label:"AS3", data:"ResourceManager.getInstance().get[TYPE]('[BUNDLE]', '[KEY]')"},
												{label:"AS3 in MXML", data:"resourceManager.get[TYPE]('[BUNDLE]', '[KEY]')"},												
												{label:"MXML", data:"{resourceManager.get[TYPE]('[BUNDLE]','[KEY]')}"},
												];

		public static var defaultReplacements:Array=[
												{label:"AS3", data:""},
												{label:"AS3 in MXML", data:""},												
												{label:"MXML", data:""},
												];
														
		public var fileDescList:Array;
		public var sourceTa:TextArea;		
		public var destinationBundle:Bundle;
		public var keyValidRegExp:String = "^[a-zA-Z0-9_]+$";
		public var keyIsValid:Boolean;
		public var defaultKey:String;
		public var defaultType:String;
		// Note that since this AS code creates string, those would be cought by our search method
		// So we use simple quotes, because our search patterns only searches for double quotes	
		public var codeReplacementPattern:String;											
		public var selectedReplacementIndex:int;
		public var typeList:ArrayCollection = new ArrayCollection([TYPE_STRING, TYPE_CLASS, TYPE_BOOLEAN, TYPE_INT, TYPE_NUMBER]);
		public var as3Import:String="mx.resources.ResourceManager";
		public var mxmlImport:String="";
		
		private var _project:Project;
		private var _source:ExtractableSource;		
		private var previousSource:ExtractableSource;// used to save the last source once we've changed
		private var range:TextRange;
		private var defaultQuotesPolicyIsRemove:Boolean=true;
		private var lastExtractedPair:KeyValuePair;
		private var lastSelection:Object;
		
		private	const REP_AS3:int=0;
		private	const REP_MXML_AS3:int=1;
		private	const REP_MXML_DYN:int=2;
//		private	const REP_MXML_DYN_CLASS:int=3;

		private	const TYPE_STRING:String="String";
		private	const TYPE_CLASS:String="Class";
		private	const TYPE_BOOLEAN:String="Boolean";
		private	const TYPE_INT:String="Int";
		private	const TYPE_NUMBER:String="Number";


		
		public function SourceExtractionPM()
		{
		}
		
		public function set project(pProject:Project):void
		{
			_project = pProject;
			setSourceDirectory(pProject.src_directory);
		}
		public function get project():Project
		{
			return _project;
		}
		
		
		public function setSourceDirectory(pDir:File):void
		{
			var list:Array =[];			
			getFileListRecurs(pDir, list);
			
			if(list.length==0) Alert.show("No source file could be found in this directory", "Warning");
			
			else setFileList(list);			
		}
		
		private function getFileListRecurs(pDir:File, pBigList:Array):void
		{
			var list:Array = pDir.getDirectoryListing();
			
			var n:int = list.length;
			for ( var i:int=0 ; i < n ; i++)
			{
				var f:File = list[i];
				if(f.isDirectory) getFileListRecurs(f, pBigList);
				else if(f.extension=="mxml" || f.extension=="as") pBigList.push(f);
			}				
			
		}			

		public function setFileList(pList:Array):void
		{
			if( pList.length==0) return ;
			
			//	for performance sake, we show a list of objects instead of a list of files			
			fileDescList=[];
			var n:int = pList.length
			for ( var i:int=0 ; i < n ; i++)
			{
				fileDescList.push( new ExtractableSource(pList[i], project.src_directory) );
			}	
					
			setSourceFile( fileDescList[0] );
		}
				
	
		
		public function setSourceFile(pSource:ExtractableSource):void
		{
			if(range) range.color = 0x000000;// ugly : prevents hilighting issue: all the text gets hilighted
			
			// make sure we don't forget to save the previous file
			if( source!=null && source.hasChanged() )
			{
				previousSource = source;
				
				Alert.show("The file "+previousSource.file.name+" has changed. Do you want to save it?",
				 "Warning", Alert.YES|Alert.NO, null, onSavePreviousSourceAnswer);
			}
			
			source = pSource;//new ExtractableSource(pFileDesc.file);
			source.init();
			
			range = null;
			defaultKey="";
			
			if(sourceTa) findNext();
			
		}
		private function onSavePreviousSourceAnswer(pEvt:CloseEvent):void
		{
			if( pEvt.detail==Alert.YES) previousSource.save(as3Import, mxmlImport);
		}
		
		public function save():void
		{
			source.save(as3Import, mxmlImport);
		}

		public function saveAndNext():void
		{
			save();
			openNextFile();
		}
		public function openNextFile():void
		{
			
			var selectedFileIndex:int = fileDescList.indexOf(source);
			
			if(fileDescList.length>0 && selectedFileIndex == fileDescList.length-1)
			{
				Alert.show("Do you want to save the entries that were extracted to your bundles now?", "End of the file list", Alert.YES|Alert.NO, null, onSaveBundledAnswer);
			} 
			else setSourceFile( fileDescList[selectedFileIndex+1]);
			
		}
		
		private function onSaveBundledAnswer(pEvt:CloseEvent):void
		{
			if(pEvt.detail==Alert.YES)
			{
				project.saveAllBundles();
				dispatchEvent(new Event(EVENT_END_OF_EXTRACTION));
			}
		}
		

		public function set source(pValue:ExtractableSource):void
		{
			_source = pValue;
			
			// unselect the text
			if(sourceTa) sourceTa.selectionBeginIndex = sourceTa.selectionEndIndex=0;

		}
		public function get source():ExtractableSource{return _source;}
		

		public function findNext(pBackwards:Boolean=false):void
		{
			if(source.searchResult==null || source.searchResult.length==0 || (source.searchIndex==source.searchResult.length-1 && pBackwards==false))
			{
				if(source.hasChanged())
				{
					Alert.show("Do you want to save this file and proceed to the next?", "End of search", Alert.YES|Alert.NO, null, onSaveNextAnswer);
				} 
				
				else if(source.searchResult.length!=0)
				{
					Alert.show("Do you want to open the next file?", "End of search", Alert.YES|Alert.NO, null, onNextFileAnswer);
				}
				
				return ;
			}
			
			var result:Array;
			
			if(pBackwards) result = source.previous();
			else result = source.next();
			
			if(result==null)
			{
				// If the result is null, something went wrong
				promptErrorMessage("Null result found");
				return;
			}
			
			updateTa();
			sourceTa.setSelection(result.index, result.index+result.toString().length);
			sourceTa.callLater(updateSelection);
			
		}

		public function updateTa():void
		{
			sourceTa.horizontalScrollPosition=0;
			sourceTa.verticalScrollPosition+=5;

			// forces TextArea resizing
			sourceTa.invalidateDisplayList();
			// sets selection color to blue, more legible
			sourceTa.setFocus();				
		}
			
		
		private function onSaveNextAnswer(pEvt:CloseEvent):void
		{
			if(pEvt.detail==Alert.YES)saveAndNext();
		}
		
		private function onNextFileAnswer(pEvt:CloseEvent):void
		{
			if(pEvt.detail==Alert.YES) openNextFile();
		}

		
		public function updateSelection(pForceUnselect:Boolean=false):void
		{
			if( sourceTa==null) return;
			
			if(range==null ) range = new TextRange(sourceTa, true);

			// cancel selection change if nothing is selected
			if(pForceUnselect==false && range.beginIndex==range.endIndex)
			{
				if(sourceTa && lastSelection)
				{
					sourceTa.setSelection(lastSelection.beginIndex, lastSelection.endIndex);
					sourceTa.callLater(updateSelection);
					return;
				} 
			}
			else
			{
				// avoid updating (and erasing key name changes) if selection hasn't changed
				if(lastSelection!=null && lastSelection.beginIndex==range.beginIndex && lastSelection.endIndex==range.endIndex)	return;				
			}
			
			lastSelection={beginIndex:range.beginIndex, endIndex:range.endIndex};

			formatKey();
			
			updateDefaultReplacement();
			
			highlightStrings();
		}
		
		
		// not used
		private function isValidSelection():Boolean
		{
			if(range==null) return false;
			
			var selectedText:String = range.text;
			
			if(selectedText==null) return false;
			if( selectedText.length==0) return false;
			
			return true;
		}		

		private function isStringSelection():Boolean
		{
			if(isValidSelection()==false) return false;
			var selectedText:String = range.text;
			if(selectedText.charAt(0)!='"') return false;
			if(selectedText.charAt(selectedText.length-1)!='"') return false;
			
			return true;
		}		

		
		private function formatKey():void
		{
			 var selectedText:String = range.text;
			// remove quotes
			if(isStringSelection()) selectedText=selectedText.substring(1, selectedText.length-1);
			
			// for embedded assets, we have a special naming technique :
			if(selectedText.indexOf("@Embed")==0 )
			{				
				var fileName:String = selectedText.match(/\w+\.\w+/)[0];
				defaultKey = "file_"+fileName.replace(".", "_");				
			}
			else
			{
				// format the key by replacing all non word chars by underscore
				defaultKey = selectedText.replace(/[^\w]/gi,"_");
				if(prefixKeyWithFilename) defaultKey= source.name.split(".")[0]+"_"+defaultKey;
				// and limit to 40 chars
				defaultKey = defaultKey.substr(0, 40);					
			}
		
		}

		
		private function updateDefaultReplacement():void
		{
			if(_source==null) return;
			
			// first, reset default
			selectedReplacementIndex=-1;
			codeReplacementPattern="";			
			defaultType=TYPE_STRING;
			defaultQuotesPolicyIsRemove = true;
			
			// Determine the default type
			var selectedText:String = range.text;
			if(isStringSelection() ) selectedText= selectedText.substring(1, selectedText.length-1);			
			defaultType = getAppropriateType( selectedText);
			
			// determine the default context and quotes policy
			
			if(_source.isMXML)
			{				
				if(source.isAS3InMXML(range.beginIndex))
				{
					selectedReplacementIndex=REP_MXML_AS3;						
				}
				else
				{
					defaultQuotesPolicyIsRemove = false;
					selectedReplacementIndex=REP_MXML_DYN;
				}
			}	
			else selectedReplacementIndex=REP_AS3;
			
			codeReplacementPattern = defaultReplacements[selectedReplacementIndex].data;					
		}
		
		private function getAppropriateType(pStr:String):String
		{
			if(pStr.indexOf("@Embed")==0) return TYPE_CLASS;
			
			else if(pStr=="true" || pStr=="false") return TYPE_BOOLEAN;
			
			else if(isNaN(Number(pStr))==false)
			{
				var num:Number = Number(pStr);
				var integer:int = num;
				if(num.toString()==integer.toString()) return TYPE_INT;
				
				return TYPE_NUMBER;
			} 
			
			else return TYPE_STRING;
		}

		public function extract(pKey:String, pComment:String, pDestBundle:Bundle, replacement:String, pType:String, pReplaceIndex:int, pNoQuotes:Boolean, pNext:Boolean=true):void
		{	
			
			destinationBundle = pDestBundle;
			
			if( keyIsValid==false) return;
			
			addToBundle(pKey, pComment);
			
			
			if(replacement!=null)
			{
				editSourceCode(pKey, replacement, pType, pNoQuotes);
				
				// set the replacement as the new default for this case
				defaultReplacements[pReplaceIndex].data = replacement;
	
				// updating the source content will trigger a new search
				source.setContent(sourceTa.text);
				
				// since the number of matches of the new search differs from
				// the prededing, the index has to be changed 
				// we can guess that since a string was removed, index-1 will probably work
				source.searchIndex--;					
			}
									
			if( pNext) findNext();
			
			else 
			{
				sourceTa.setSelection(range.beginIndex, range.beginIndex);
				sourceTa.callLater(updateSelection, [true]);
			}
		}
		
		
		public function undoAll():void
		{
			source.undoChanges();
			setSourceFile(source);
		}

		public function undoLast():void
		{
			if(source.searchIndex>-1) source.searchIndex--;
			
			source.undoLast();
			if(lastExtractedPair)
			{
				destinationBundle.masterPropFile.removePair(lastExtractedPair);	
				lastExtractedPair = null;
			} 		
			findNext();
		}
	
		
		private function addToBundle(key:String, pComment:String):void
		{
			var selectedText:String = range.text;
			if(isStringSelection() ) selectedText= selectedText.substring(1, selectedText.length-1);
			
			// escape &, < and > if MXML
			if(source.isMXML)
			{
				selectedText = unescapeHTMLentities(selectedText);
				//selectedText =selectedText.replace(/&amp;/g, "&");
				//selectedText =selectedText.replace(/&lt;/g, "<");
				//selectedText =selectedText.replace(/&gt;/g, ">");
			}
			
			var pair:KeyValuePair = new KeyValuePair();
			pair.key = key;
			pair.value = selectedText;
						
			if(pComment.length>0) pair.comments = pComment;
			
			// for embeded assets, remove ../ and @
			if( pair.value.indexOf("@Embed")==0)
			{
				pair.value = pair.value.replace("@", "");
				pair.value = pair.value.replace(/\.\.\//g, "");	
			}
			
			// check if a pair with this key doesn't exist yet!
			var existingPair:KeyValuePair = destinationBundle.masterPropFile.getPair(key);
			
			if(existingPair!=null)
			{
				if(existingPair.value==pair.value)
				{
					// the values are the same, so we do nothing
				}
				else
				{
					// The new value is different, so we have to create a new, unique key
					// TODO find a better way to create a unique new key
					var uqid:int = Math.random()*10000;
					pair.key+=uqid;
					destinationBundle.masterPropFile.addPair(pair);
					lastExtractedPair = pair;
				}
			}
			else
			{
				// if the key doesn't exist, we simply add the pair
				destinationBundle.masterPropFile.addPair(pair);	
				lastExtractedPair = pair;			
			}						
		}
		
		private function editSourceCode(key:String, replacement:String, pType:String, noQuotes:Boolean):void
		{
		
			var newText:String ;
			newText = replacement.replace("[BUNDLE]", destinationBundle.shortName);
			newText = newText.replace("[KEY]", key);
			newText = newText.replace("[TYPE]", pType);
						
			if(noQuotes) range.text = newText;	
			else range.text = '"'+newText+'"';	
		}
		
		private function highlightStrings():void
		{
			if(source==null || source.searchResult==null) return ;			
			var n:int = source.searchResult.length;
			
			if(source.fileContent.length>5000) return;
			
			for ( var i:int=0 ; i < n ; i++)
			{
				//if(i>20) return;
				var result:Array = source.searchResult.getItemAt(i) as Array;
				var tr:TextRange = new TextRange(sourceTa, false, result.index, result.index+result.toString().length);
				tr.color = 0xBB0000;
			}
		}
		
		public function markAsTODO():void
		{
			var pIndex:int = range.beginIndex;
			var char:String="";
			var goalIndex:int=-1;
			var tx:String = sourceTa.text;
			var tabs:String="";
			
			while(goalIndex==-1)
			{
				if(pIndex==0) return;
				
				pIndex--;
				if(source.isMXML)
				{
					if(tx.charAt(pIndex)=="<") goalIndex = pIndex;
				}
				else
				{
					if(tx.charAt(pIndex)=="\t") tabs+="\t";				
					else if(tx.charAt(pIndex)=="\n" || tx.charAt(pIndex)=="\r"|| tx.charAt(pIndex)=="\r\n") goalIndex = pIndex;					
				}
			}
			
			var start:String = tx.substring(0, goalIndex);
			var end:String = tx.substr(goalIndex);
			
			if(source.isMXML) sourceTa.text = start+"<!-- TODO i18n -->"+ File.lineEnding+end;
			else sourceTa.text = start+ File.lineEnding+tabs+"// TODO i18n"+end;
			
			source.setContent(sourceTa.text);
			findNext();
		}
		
		public function goToStartIndex():void
		{
			source.searchIndex = -1;
			findNext();
		}

		public function goToEndIndex():void
		{
			source.searchIndex = source.searchResult.length -2;
			findNext();
		}
		
		
		private function unescapeHTMLentities(pStr:String):String
		{
			return new XMLDocument(pStr).firstChild.nodeValue;
		}
				
	}
	
}