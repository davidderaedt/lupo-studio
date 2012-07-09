package com.dehats.lupo.model
{
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	public class PropFileParser
	{
		[Bindable]
		public static var useLineEndingSeparator:Boolean=false;

		public static var ignoreDoubleCharComments:Boolean=true;
		

		public function parseFile(fileString:String):ArrayCollection
		{
						
			var keyValuePairCollec:ArrayCollection = new ArrayCollection();


			// Kept for reference : I chose not to remove bank lines since if the blank line is after a "\", it has a meaning
			//fileString = fileString.replace(/^\s*(\r\n|\r|\n)/gm, "");
			//fileString = fileString.replace(/^\s*\n/gm, "");
			
			// Split into logical lines (ie natural lines without line continuation chars
			var logicalLines:Array = fileString.split(/(?<!\\)(\r|\n|\r\n)/);//
			
			var commentStack:String="";
			
			for ( var i:int = 0 ; i < logicalLines.length ; i++)
			{
				var logicalLine:String = logicalLines[i];				
				output("x x x xx xx xx xx xx xx xx xx xx x")
				
				output("-------------")
				output("logical line "+(i+1))
				output( logicalLine)
				output( (logicalLine=="\n").toString())
				output("-------------")
				
				// Discard blank lines
				var blankLineTest:String = logicalLine.replace(/^\s*/, "");
				if(blankLineTest.length==0)
				{
					output("logical line "+(i+1)+" is blank");
					continue;
				}
				
				if( lineIsComment( logicalLine)) 
				{
					output("comment found:"+logicalLine)
					if( commentStack.length>0) commentStack+="\n";
					
					if(ignoreDoubleCharComments && lineIsDoubledComment(logicalLine) ) continue;
					else commentStack+=logicalLine;
				}
				
				else
				{
					var p:KeyValuePair = createPairFromString( logicalLine, commentStack );
					keyValuePairCollec.addItem(p);	
					commentStack="";
				}
				output("x x x xx xx xx xx xx xx xx xx xx x")
				
			}
			
			return keyValuePairCollec;
		}
		
		
		private function lineIsComment(pLine:String):Boolean
		{
			return pLine.match(/^\s*(#|!)/)!=null ;
		}
		private function lineIsDoubledComment(pLine:String):Boolean
		{
			return pLine.match(/^\s*(##|!!)/)!=null ;
		}

		
		private function createPairFromString(rawPair:String, pComments:String):KeyValuePair
		{
			var pair:KeyValuePair = new KeyValuePair();
			
			// We remove # characters
			pair.comments = pComments.replace(/^\s*#\s*/gm, "");
			
			var index:int = getSeparatorIndex(rawPair);
			
			if(index==-1)
			{
				output("Warning : No separator found:\n"+ rawPair);
				pair.key = rawPair ;
				pair.value = "";
			}
			else if(index==0)
			{
				output("Warning : Separator found as first char:\n"+rawPair);
				// TODO see if its valid anyway (probably not)
				pair.key = rawPair ;
				pair.value = "";
			}
			else if(index==rawPair.length-1)
			{
				output("Warning : Separator found as last char:\n"+rawPair);
				// TODO see if its valid anyway (probably)
				pair.key = rawPair.substring(0, index); ;
				pair.value = "";				
			}
			
			else if(index>0) 
			{
				// Normal situation
				pair.key = rawPair.substring(0, index);
				pair.value = rawPair.substring(index+1);
			}
						
			
			// Unescape spaces in the key
			pair.key = pair.key.replace(/\\s*/g, " ");
			
			// remove the spaces at the end of the key
			pair.key = pair.key.replace(/\s*$/, "");
			// remove the spaces at the beginning of the key
			pair.key = pair.key.replace(/^\s*/, "");

						
			var val:String = pair.value;
			

			// unescape line endings
			val = val.replace(/(\\\r|\\\n|\\\r\n)/gm, "\n");

			// get rid of line continuation characters
			//val = val.replace(/\\(\r|\n|\r\n)\s*/gm, "");			
			
			// unescape = and : chars
			val = val.replace(/\\:/gm, ":");
			val = val.replace(/\\=/gm, "=");
			
			pair.value = val;
			
			return pair;
		}
		
		
		private function getSeparatorIndex(rawPair:String):int
		{
			// we look for the first unescaped space, = or :

			var index1:int = rawPair.search(/(?<!\\)=\s*/);
			
			var index2:int = rawPair.search(/(?<!\\):\s*/);
			 
			var index3:int = rawPair.search(/(?<!\\)\s+/);
			
			if(index1 > -1) return index1;
			else if(index2 > -1) return index2;
			else if(index3 > -1) return index3;
			
			return -1;
		}
	
	
		public function createFileStringFromCollec(keyValuePairCollec:ArrayCollection):String
		{
			var content:String="";
			
			var n:int = keyValuePairCollec.length;
			for ( var i:int=0 ; i < n ; i++)
			{
				var pair:KeyValuePair = keyValuePairCollec.getItemAt(i) as KeyValuePair;
				output("pair "+i+ ":"+pair.key)
				
				if( pair.comments)
				{
					output("comments found")
					// Put a # char at the beginning of each line
					content+= pair.comments.replace(/^.*(?!$)/gm, "#$&");
					// Make sure there's a \n at the end
					var lastChar:String = content.charAt(content.length-1);
					if( lastChar !="\n" && lastChar!="\r" && lastChar!="\r\n")
					{
						content+=File.lineEnding;
					} 
					output("Is here a line ending at the end? "+content.charAt(content.length-1))
				} 
				
				content+=pair.key+"=";
				
				// Add a backslash as multiline ending char
				if(pair.value) content+=pair.value.replace(/(\r\n|\r|\n)/gm, "\\"+File.lineEnding);
				
				// end the line
				content+=File.lineEnding;
				
				// optionally add a second line ending
				if(useLineEndingSeparator) content+=File.lineEnding;
			}
			
			return content;
		}		
		
		private function output(pStr:String):void
		{
			trace(pStr);
		}
			
	}
}