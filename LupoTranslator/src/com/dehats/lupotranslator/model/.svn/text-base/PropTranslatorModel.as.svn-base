package com.dehats.lupotranslator.model
{
	import com.dehats.air.file.FileUtils;
	import com.dehats.lupo.model.Project;
	
	import flash.filesystem.File;
	
	public class PropTranslatorModel
	{
		
		public var currentProjectFile:File;
		
		public function PropTranslatorModel()
		{
		}		

		public function openTranslationProjectManifest(pManifestFile:File):Project
		{
			currentProjectFile = pManifestFile;
			
			var targetLanguages:Array = [];
			var project:Project ;
			
			var projectString:String = FileUtils.getFileString(pManifestFile);
			var projectNode:XML =  new XML( projectString);

			var localeDir:File = pManifestFile.parent.resolvePath(projectNode.@locale_dir);
			
			project = new Project(	projectNode.@name, 
									projectNode.@master_language,
									localeDir,
									null);
									
			// get target languages 
			var targetNodes:XMLList = projectNode.targets.target;
			var n:int = targetNodes.length();
			for ( var i:int=0 ; i < n ; i++)
			{
				var node:XML = targetNodes[i];
				targetLanguages.push(node.@language);
			}
			
			
			project.targetLanguages = targetLanguages;
			
			project.analyze();
			
			return project;			
				
		}
		
		
		public function createNewTranslationProject(pLocaleDir:File, pProjectName:String, pMasterLg:String):Project
		{
			var manifestFile:File = pLocaleDir.parent.resolvePath("manifest.lpt");
			
			currentProjectFile = manifestFile;
			
			var manifest:XML = <translation_project><targets></targets></translation_project>;
			manifest.@name = pProjectName;
			manifest.@master_language = pMasterLg;
			manifest.@locale_dir = pLocaleDir.name;
			
			// we consider all languages are targets
			var lgDirs:Array = pLocaleDir.getDirectoryListing();
			for ( var j:int=0 ; j < lgDirs.length ; j++)
			{
				var dir:File = lgDirs[j];
				// Note that we prevent editing the master language here
				if(dir.isDirectory && dir.name!=pMasterLg) manifest.targets.appendChild( new XML('<target language="'+dir.name+'"/>'));
			}				
			

			FileUtils.writeTextInFile(manifestFile, '<?xml version="1.0" encoding="utf-8"?>'+File.lineEnding+manifest.toXMLString());					

			return openTranslationProjectManifest(manifestFile);
		}


	}
}