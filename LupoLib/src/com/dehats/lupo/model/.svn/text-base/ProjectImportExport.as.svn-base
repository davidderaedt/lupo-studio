package com.dehats.lupo.model
{
	import com.dehats.air.file.FileUtils;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipOutput;
	
	public class ProjectImportExport
	{
		
		private var project:Project
		
		public function ProjectImportExport(pProject:Project)
		{
			project = pProject;
		}
		
	
		public function exportForTranslation(pDestinationDir:File, includedLanguages:Array, targetLanguages:Array, pZip:Boolean):void
		{
			
			// warning : ties the language to the directory name !
			var masterLanguageDir:File = project.locale_directory.resolvePath(project.masterLanguage);			
						
			var manifestFile:File ;
			
			
			// Include the content of the locale directory
			var includedDirs:Array=[];
			if(includedLanguages!=null)
			{
				for (var i:int=0; i < includedLanguages.length ; i++)
				{				
					var includedLg:String= includedLanguages[i];
					includedDirs.push( project.locale_directory.resolvePath(includedLg));
				}
			}
			else includedDirs = project.locale_directory.getDirectoryListing();
			
			
			// Create the manifest file content
			if(targetLanguages!=null)
			{
				var manifest:XML = <translation_project><targets></targets></translation_project>;
				manifest.@name = project.name;
				manifest.@master_language = project.masterLanguage;
				manifest.@locale_dir = "locale";
				for (var a:int=0; a < targetLanguages.length ; a++)
				{
					var targetLg:String= targetLanguages[a];
					manifest.targets.appendChild(new XML('<target language="'+targetLg+'" />'));
				}
				
				
				manifestFile = File.createTempFile();
	
				FileUtils.writeTextInFile(manifestFile, '<?xml version="1.0" encoding="utf-8"?>'+File.lineEnding+manifest.toXMLString());				
			}
			
			// Zip or just copy the content
			if( pZip==false)
			{
				exportToDirectory(pDestinationDir, includedDirs, manifestFile, masterLanguageDir);
			}
			
			else 
			{
				exportToZip(pDestinationDir, includedDirs, manifestFile, masterLanguageDir);				
			}
						
		}
		
		// Creates a folder in the destination dir
		private function exportToDirectory(pDestinationDir:File, includedLanguageDirs:Array, manifestFile:File, masterLanguageDir:File):void
		{
			// the actual destination is a folder named after the project
			var finalDestinationDir:File = pDestinationDir.resolvePath(project.name);
			
			if(manifestFile!=null) manifestFile.copyTo(finalDestinationDir.resolvePath("manifest.lpt"));
			
			masterLanguageDir.copyTo( finalDestinationDir.resolvePath("locale/"+project.masterLanguage));

			for (var a:int=0; a < includedLanguageDirs.length ; a++)
			{
				var includedLgDir:File= includedLanguageDirs[a];
				// Avoid coping the master twice
				if( includedLgDir.name == masterLanguageDir.name) continue;
				
				includedLgDir.copyTo( finalDestinationDir.resolvePath("locale/"+includedLgDir.name));		
			}
						
		}
		
		// CReates a ZIP file in the destination dir
		private function exportToZip(pDestinationDir:File, includedLanguageDirs:Array, manifestFile:File, masterLanguageDir:File):void
		{
			var zipOut:ZipOutput = new ZipOutput();
			
			var destZipFile:File = pDestinationDir.resolvePath(project.name+".zip");
			
			// add manifest
			if(manifestFile!=null) addToZip(zipOut, manifestFile, project.name+"/manifest.lpt");
			
			var masterAlreadyAdded:Boolean = false;
						
			// Add all the content of each included language
			for (var a:int=0; a < includedLanguageDirs.length ; a++)
			{				
				var includedLanguageDir:File= includedLanguageDirs[a];
				if( ! includedLanguageDir.isDirectory) continue;
				// Avoid coping the master twice
				if( includedLanguageDir.name == masterLanguageDir.name) 
				{
					if(masterAlreadyAdded) continue;
					masterAlreadyAdded = true;
				}
								
				var includedContent:Array = includedLanguageDir.getDirectoryListing();
				
				var n:int = includedContent.length;
				for ( var j:int=0 ; j < n ; j++)
				{
					var f:File = includedContent[j] as File;
					if(f.extension!="properties") continue;
					addToZip(zipOut, f, project.name+"/locale/"+includedLanguageDir.name+"/"+f.name);
				}	
			}

			zipOut.finish();
			
			var zipStream:FileStream = new FileStream();
			zipStream.open(destZipFile, FileMode.WRITE);
			zipStream.writeBytes(zipOut.byteArray);				
		}
		
		private function addToZip(zipOut:ZipOutput, pFile:File, destination:String):void
		{
			var stream:FileStream = new FileStream();
			stream.open(pFile, FileMode.READ);
			var fileData:ByteArray = new ByteArray();
			stream.readBytes(fileData);
			var ze:ZipEntry = new ZipEntry(destination);
			zipOut.putNextEntry(ze);
			zipOut.write(fileData);
			zipOut.closeEntry();			
		}
		
		
		// returns the list of imported target languages
		public function importTranslation(manifestFile:File):Array
		{
			
			// If there's a manifest file, for each target language, make the import
			//var manifestFile:File = translationProjectDir.resolvePath("manifest.lpt");
			
			
			var importedLgs:Array=[];
			
			if( manifestFile.exists)
			{
				var manifest:XML = new XML( FileUtils.getFileString(manifestFile) );	
				var translationProjectDir:File = manifestFile.parent.resolvePath(manifest.@locale_dir);
				
				var targetNodes:XMLList = manifest.targets.target ;		
				for ( var i:int=0 ; i < targetNodes.length() ; i++) 
				{
					var node:XML = targetNodes[i];
					var targetLanguage:String = node.@language;
					var targetDir:File = translationProjectDir.resolvePath(targetLanguage);
					if(targetDir.exists==false)
					{
						Alert.show("Could not find directory "+targetLanguage, "Warning");
						continue;
					} 
					importTargetLanguage(targetDir);	
					importedLgs.push(targetDir.name);				
				}
				
			}

			//if there is no manifest file, just import the whole list of languages			
			else
			{
				var languages:Array=translationProjectDir.getDirectoryListing();
				for ( var j:int=0; j< languages.length ; j++)
				{
					var file:File = languages[j];
					// for now we prevent importing the master language
					if(file.isDirectory && file.name!=project.masterLanguage) 
					{
						importTargetLanguage(file);
						importedLgs.push(file.name);
					}
				}
				
			}		
			
			return importedLgs;	
		
		}
		
		private function importTargetLanguage(targetDir:File):void
		{
			var content:Array = targetDir.getDirectoryListing();

			var n:int =  content.length;

			// Open all translated properties files and copy its content to the project propFile objects
			// Note that we don't copy anything into the real files yet 
			//(the user has to save for the import to take effect)

			for ( var i:int=0 ; i < n ; i++)
			{
				var newFile:File = content[i];
				
				var propFile:PropFile = project.getBundle(newFile.name).getPropFile(targetDir.name);
								
				if( propFile==null) trace("Import Error : unable to find property file "+newFile.name+" in project");
				else 
				{
					propFile.parseFile(newFile);
				}
			}				
		}

	}
}