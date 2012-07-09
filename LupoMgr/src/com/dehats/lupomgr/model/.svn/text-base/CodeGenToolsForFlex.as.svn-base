package com.dehats.lupomgr.model
{
	import com.dehats.air.file.FileUtils;
	import com.dehats.lupo.model.Bundle;
	import com.dehats.lupo.model.KeyValuePair;
	import com.dehats.lupo.model.Project;
	import com.dehats.lupo.model.PropFile;
	import com.dehats.lupo.presentation.LanguagesReference;
	
	import flash.filesystem.File;
	
	public class CodeGenToolsForFlex
	{
		[Bindable]
		public var project:Project
		
		public function CodeGenToolsForFlex(pProject:Project)
		{
			project = pProject;
		}

		public function getResourceModulesNamesCommandLineArgs():String
		{
			return "-locale= -resource-bundle-list=\""+ project.src_directory.nativePath+"/bundles.txt\"" ;
		}
		
		public function getResourceModuleCommandLines(pCommaDelimitedRMNames:String):String
		{
			//ex: "collections,containers,controls,core,effects,myResources,skins,styles"
			var allCmds:String = "";
			
			var n:int = project.languagesNames.length;
			
			for ( var i:int=0 ; i < n ; i++)
			{
				var lg:String = project.languagesNames[i];
				allCmds+="mxmlc -locale="+lg+" -source-path=locale/{locale} -output=\""+ project.src_directory.nativePath+"/Resources_"+lg+".swf\" -include-resource-bundles="+pCommaDelimitedRMNames+"\n\n";				
			}

			return allCmds;
			
		}
		
		public function getCommandLineArgs():String
		{
			
			var languages:String = "";
			
			var n:int = project.languagesNames.length;
			
			for ( var i:int=0 ; i < n ; i++)
			{
				languages+=project.languagesNames[i]+" ";
			}			

			return "-locale "+languages+"-allow-source-path-overlap=true -source-path=locale/{locale}";
		}

		public function getCopyLocaleCommandLine():String
		{
			var base:String = "{flexsdk}/bin/copylocale en_US "; 		
			
			var cmds:String = "";
			
			var n:int = project.languagesNames.length;
			
			for ( var i:int=0 ; i < n ; i++)
			{
				var language:String = project.languagesNames[i];
				if( language!= "en_US") cmds+=base+ language +"\n";			
			}			

			return cmds;
		}
		
		
		public function getBundlesMetadatas(pMXML:Boolean=false, pFlex3:Boolean=false):String
		{
			var metadatas:String = "";
			
			var nsPrefix:String="fx";
			if(pFlex3) nsPrefix="mx";
			
			if(pMXML) metadatas+="\t<"+nsPrefix+":Metadata>"+File.lineEnding;
			
			var n:int = project.bundleCollec.length;
			for ( var i:int=0 ; i < n ; i++)
			{
				var bundle:Bundle = project.bundleCollec.getItemAt(i) as Bundle;
				if(pMXML)metadatas+='\t';
				metadatas+='\t[ResourceBundle("'+bundle.shortName+'")]'+File.lineEnding;
			}			
			
			if(pMXML) metadatas+="\t</"+nsPrefix+":Metadata>"+File.lineEnding;
			
			return metadatas;
		}
		
	
/*
		public function getSampleCode():String
		{		
			
			var code:String ="";

			// languages list
			code += "[Bindable] private var languages:Array=[";
			var n:int = project.languagesNames.length
			for ( var i:int=0 ; i < n ; i++)
			{
				code+='"'+project.languagesNames[i]+'",';
			}			
			code+="];\n\n";
			
			// changeLanguage method
			
			code+="private function changeLanguage(pLg:String):void\n{\n";
			code+="\tresourceManager.localeChain=[pLg, "+'"'+project.masterLanguage+'"];\n';
			code+="}";
			return code;
		}
*/
		public function getSampleCode():String
		{		
			
			var code:String ="";

			// languages list
			code += "[Bindable] private var languages:Array="+getLgObjectList();
			// changeLanguage method			
			code+="private function setLocale(pLg:String):void\n{\n";
			code+="\tresourceManager.localeChain=[pLg, "+'"'+project.masterLanguage+'"];\n';
			code+="}";
			return code;
		}
		
		private function getLgObjectList():String
		{
			var code:String ="[";
			var n:int = project.languagesNames.length
			for ( var i:int=0 ; i < n ; i++)
			{
				var localeName:String = project.languagesNames[i];
				var lgCode:String = localeName.substr(0, 2);
				var lgName:String = LanguagesReference.getLGNameByCode(lgCode);	
				code+='{label:"'+lgName+'", data:"'+project.languagesNames[i]+'"},';
			}			
			code+="];\n\n";
			
			return code
		}

		

/*		
		public function getSampleComboBox():String
		{
			return '<mx:ComboBox id="lgCMB" selectedItem="{ resourceManager.localeChain[0]}" dataProvider="{languages}" change="changeLanguage( lgCMB.selectedItem.toString())"/>';
		}
*/
		public function getSampleComboBox():String
		{
			var lgList:String="";
			var n:int = project.languagesNames.length
			for ( var i:int=0 ; i < n ; i++)
			{
				lgList+="'"+project.languagesNames[i]+"', ";
			}	
			
			var str:String='<mx:ComboBox id="lgCMB"'+File.lineEnding;
			str+="dataProvider=\"{new ArrayCollection(["+lgList+"])}\""+ File.lineEnding;
			str+="selectedItem=\"{ resourceManager.getPreferredLocaleChain()[0]}\""+ File.lineEnding; 
			str+="change=\"resourceManager.localeChain=[lgCMB.selectedItem.toString(), 'en_US'];\"/>";
					
			return str;
		}
		
		
		public function putMetadatas(appFile:File):void
		{
			
			var appFileContent:String = FileUtils.getFileString(appFile);
			var index0:int =appFileContent.indexOf(">")+1;
			var index:int =appFileContent.indexOf(">", index0)+1;

			
			var start:String = appFileContent.substring(0, index);
			var end:String = appFileContent.substring(index);
			var metadatas:String = getBundlesMetadatas(true).replace(new RegExp("\t", "gi"), "");
			metadatas = metadatas.replace(new RegExp(File.lineEnding, "gi"), "");
			appFileContent = start+File.lineEnding+metadatas+File.lineEnding+end;
			
			FileUtils.writeTextInFile(appFile, appFileContent);
		}
		
		
		// weak TODO better way to find app file
		public function getAppFile():File
		{
			var srcContent:Array = project.src_directory.getDirectoryListing();
			for ( var i:int=0; i < srcContent.length ; i++)
			{
				var f:File = srcContent[i];
				if(f.extension=="mxml") return f;
			}
			
			return null;
		}


/*
	// Method 1 : outputs consts
	//output+="\t\tpublic static const "+myPair.key+':String="'+myPair.key+'";\n';

	// Method 2 : outputs getters

	output+='\t\t[Bindable("change")]\n';			
	output+="\t\tpublic function get "+myPair.key.toLowerCase()+"():"+dataType+"{\n";
	output+="\t\t\treturn resourceManager.get"+dataType+"('"+ propFile.shortName+"', '"+myPair.key+"');\n\t\t}\n\n";					


*/


		public function getAS3Code(propFile:PropFile, pTemplate:String):String
		{
			var output:String = "";
			
			var n:int = propFile.keyValuePairCollec.length;
			
			for ( var i:int=0 ; i < n ; i++)
			{
				var myPair:KeyValuePair = propFile.keyValuePairCollec.getItemAt(i) as KeyValuePair;
				
				var dataType:String = "String";
				
				if( myPair.valueIsFile) dataType = "Class";
				
				var temp:String = pTemplate.replace(/\[KEY\]/g, myPair.key);
				temp = temp.replace(/\[lcKEY\]/g, myPair.key.toLowerCase());
				temp = temp.replace(/\[ucKEY\]/g, myPair.key.toUpperCase());
				temp = temp.replace(/\[BUNDLE\]/g, propFile.shortName);
				temp = temp.replace(/\[TYPE\]/g, dataType);
				
				
				output += temp;				
				
			}			
			
			return output;	
		}

	}
}