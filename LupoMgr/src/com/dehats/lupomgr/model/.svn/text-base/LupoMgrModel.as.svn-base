package com.dehats.lupomgr.model
{
	import com.dehats.air.file.FileUtils;
	import com.dehats.lupo.model.Project;
	
	import flash.events.Event;
	import flash.filesystem.File;
	
	[Bindable]
	public class LupoMgrModel
	{

		public var currentProjectFile:File;
		private var project:Project;

		
		public function LupoMgrModel()
		{
		}
		
		
		public function openProjectFile(pFile:File):Project
		{
			currentProjectFile =pFile;
			var projectString:String = FileUtils.getFileString(currentProjectFile);
			var projectNode:XML =  new XML( projectString);
			
			if(projectNode.@src_dir.toString().length==0 || 
			projectNode.@master_language.toString().length==0 ||
			projectNode.@name.toString().length==0 )
			{
				return null;
			}
			
			var src:File = new File(projectNode.@src_dir);
			
			project = new Project(	projectNode.@name, 
									projectNode.@master_language,
									currentProjectFile.parent, 
									src);		
			return project;
		}


		public function createProject(pName:String, pMasterLanguage:String, pLocaleDirectory:File, pSrcDirectory:File, pDefaultBundleName:String):Project
		{
			
			project = new Project(	pName, pMasterLanguage, pLocaleDirectory, pSrcDirectory);		
			
			currentProjectFile = pLocaleDirectory.resolvePath(pName+".lpm");
			
			// if the master language directory can't be found, create it
			var masterLgDir:File = pLocaleDirectory.resolvePath(pMasterLanguage);
			if(masterLgDir.exists==false) masterLgDir.createDirectory();
			
			// create the default bundle/properties file
			if(pDefaultBundleName!=null)
			{
				var defaultBundleFile:File = masterLgDir.resolvePath(pDefaultBundleName+".properties");
				FileUtils.writeTextInFile(defaultBundleFile, "# "+new Date().toString()+File.lineEnding+File.lineEnding);				
			}

			
			saveProjectToFile();
			
			return project;

		}
		
		
		public function promptSaveProjectDescription():void
		{
			
			if(currentProjectFile==null)
			{
				currentProjectFile = new File(project.locale_directory.nativePath);
				currentProjectFile.addEventListener(Event.SELECT, onNewFileSelected);
				currentProjectFile.browseForSave("Save Project");
			}
			
			else saveProjectToFile();
			
		}
		
		private function onNewFileSelected(pEvt:Event):void
		{
			saveProjectToFile();
		}
		
		private function saveProjectToFile():void
		{
			
			var projectNode:XML = <project />;
			projectNode.@name = project.name;			
			projectNode.@master_language = project.masterLanguage;
//			projectNode.@locale_dir = project.locale_directory.nativePath;
			projectNode.@src_dir = project.src_directory.nativePath;
			
			var projectString:String = projectNode.toXMLString();
			
			FileUtils.writeTextInFile(currentProjectFile, projectString);
		}


	}
}