package com.dehats.lupomgr.presentation
{
	import com.dehats.lupo.model.Bundle;
	import com.dehats.lupo.model.Project;
	import com.dehats.lupo.model.ProjectImportExport;
	import com.dehats.lupo.model.TranslationMemory;
	import com.dehats.lupo.presentation.AbsPMPM;
	import com.dehats.lupo.presentation.TranslationPanelPM;
	import com.dehats.lupomgr.model.CodeGenToolsForFlex;
	
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	[Bindable]
	public class ProjectPM extends AbsPMPM
	{
		
		public var selectedBundle:Bundle;		
		public var flexProjectTools:CodeGenToolsForFlex;
		public var translationPanelPM:TranslationPanelPM;
		public var masterFilePanelPM:MasterFilePanelPM;
		public var contentDirectory:File;// created to update views like filesystemtree
		
		private var _currentProject:Project;				
		private var createdBundleName:String="";// needed to store the new bundle name
		
		public function ProjectPM(pTM:TranslationMemory)
		{			
			translationPanelPM = new TranslationPanelPM(false, pTM);
			masterFilePanelPM = new MasterFilePanelPM();			
			
		}

		public function set currentProject(pProject:Project):void
		{
			_currentProject = pProject;
			_currentProject.addEventListener(Project.ANALYSIS_DONE, onAnalysisDone);
			_currentProject.analyze();
			
			flexProjectTools = new CodeGenToolsForFlex(_currentProject);
		}
		public function get currentProject():Project
		{
			return _currentProject;
		}
		

		public function selectBundle(pBundle:Bundle):void
		{
			selectedBundle = pBundle;
			masterFilePanelPM.bundle = selectedBundle;
			if(pBundle) translationPanelPM.setContext(selectedBundle, null);
		}			


		public function addLanguageToProject(pLg:String):Boolean
		{
			
			if(selectedBundle.getHasChanged())
			{
				Alert.show("The current bundle has changed. It is highly recommended to save it before adding a new language. Do you want to save it?",
							"Warning", Alert.YES|Alert.NO, null, onSaveBundleAnswer);
				return false;
			}
			
			var creationOK:Boolean = currentProject.createNewLanguage(pLg);			
			
			if(creationOK==false)
			{
				promptErrorMessage("This language ("+ pLg+") cannot be added to the project, probably because it already exists.");
			}
			
			return creationOK;
		}
		
		private function onSaveBundleAnswer(pEvt:CloseEvent):void
		{
			if(pEvt.detail==Alert.YES)
			{
				selectedBundle.saveAll();
			}
		}
		
		public function createNewBundle(pBundleName:String):void
		{
			if(currentProject.getBundle(pBundleName+".properties")!=null)
			{
				promptErrorMessage("A bundle with this name already exists");
				return;
			}
			
			// We want to select it after creation but we can't get the bundle object directly
			// since we need to wait for the analysis (asynchronous).
			createdBundleName = pBundleName;
			
			currentProject.createNewBundle(pBundleName);
			
		}
		
		private function onAnalysisDone(pEvt:Event):void
		{
			masterFilePanelPM.projectSrc = currentProject.src_directory;
			
			// If we have a bundle name to select, we select it
			if(createdBundleName.length>0) 
			{
				selectBundle(currentProject.getBundle(createdBundleName+".properties"));
				createdBundleName="";
			}

			// else we auto select the first bundle
			else if(currentProject.bundleCollec.length>0)
			{
				selectBundle(currentProject.bundleCollec.getItemAt(0) as Bundle);
			}
			else
			{
				selectBundle(null);
			}
			
			updateContents();
		}
		
		public function promptImportFile():void
		{
			var file:File = new File();
			file.addEventListener(Event.SELECT, onImportFileSelected);
			var filter:FileFilter = new FileFilter("LPT file", "*.lpt");
			file.browseForOpen("Please select the translations project file", [filter]);
		}
			
		private function onImportFileSelected(pEvt:Event):void
		{
			var importList:Array = importTranslations(pEvt.target as File);
			
			if(importList.length==0) Alert.show("No languages found", "Import Report");
			else Alert.show("The following languages have sucessfully been imported: "+importList.toString()+". Imported data won't be copied to your properties files until you save your bundle.", "Import Report");
		}		
		
		private function importTranslations(pManifestFile:File):Array
		{
			var importer:ProjectImportExport = new ProjectImportExport(currentProject);
			var list:Array =  importer.importTranslation(pManifestFile);
			
			translationPanelPM.updateTranslations();	
			
			return list;
		}
		
		// Artificially updates views
		public function updateContents():void
		{
			contentDirectory = null;
			contentDirectory = currentProject.locale_directory;
		}
		
	}
}