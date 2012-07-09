package com.dehats.lupomgr.presentation
{
	import com.dehats.air.DeclarativeMenu;
	import com.dehats.air.LicenseManager;
	import com.dehats.air.NativeAppBase;
	import com.dehats.lupo.model.Project;
	import com.dehats.lupo.model.TranslationMemory;
	import com.dehats.lupo.presentation.AbsPMPM;
	import com.dehats.lupomgr.model.Config;
	import com.dehats.lupomgr.model.LupoMgrModel;
	import com.dehats.lupomgr.model.ProjectHistoryManager;
	
	import flash.desktop.NativeApplication;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	[Bindable]
	public class MainPM extends AbsPMPM
	{
		public static const EVENT_NEW_PROJECT:String="newProject";
		public static const EVENT_REQUEST_LICENSE:String="requestLicense";		
		public static const EVENT_EXPORT:String="export";
		public static const EVENT_PREFS:String="preferences";
		
		public static const REGISTRATION_SCRIPT_URL:String="http://www.dehats.com/products/common/registration.php";
		public static const UNREGISTRATION_SCRIPT_URL:String="http://www.dehats.com/products/common/unregistration.php";
		
		public static const PRODUCT_CODE:String="lupo manager";
		
		public static const PAGE_OPEN:int=0;
		public static const PAGE_MAIN:int=1;

		public static const TAB_EXTRACTION:int=0;
		public static const TAB_BUNDLES:int=1;
		public static const TAB_CODEGEN:int=2;


		public var currentPage:int=0;
		public var currentTab:int=0;
		public var projectPM:ProjectPM;		
		public var extractionPM:SourceExtractionPM;
		public var licenseMgr:LicenseManager;
		public var config:Config;

		private var nativeAppBase:NativeAppBase;		
		private var projectHistoryManager:ProjectHistoryManager;		
		private var model:LupoMgrModel;	
		private var firstInvocation:Boolean=true;
		private var licensed:Boolean=false;
		private var translationMemory:TranslationMemory;
		
		public function MainPM()
		{
			model = new LupoMgrModel();
			translationMemory = new TranslationMemory();
			
			config = new Config();
			projectPM = new ProjectPM(translationMemory);
			extractionPM = new SourceExtractionPM();
			extractionPM.addEventListener(SourceExtractionPM.EVENT_END_OF_EXTRACTION, onEndOfExtraction);
			licenseMgr = new LicenseManager(REGISTRATION_SCRIPT_URL, UNREGISTRATION_SCRIPT_URL, PRODUCT_CODE);
			licenseMgr.addEventListener( LicenseManager.EVENT_REGISTRATION_SUCCESSFULL, onRegistrationSuccess);
			licenseMgr.addEventListener( LicenseManager.EVENT_UNREGISTRATION_SUCCESSFULL, onUnregistrationSuccess);
			licenseMgr.addEventListener( LicenseManager.EVENT_UNREGISTRATION_ERROR, onUnregistrationError);
			licenseMgr.addEventListener( LicenseManager.EVENT_UNREGISTRATION_FAILURE, onUnregistrationError);
			
			projectHistoryManager = new ProjectHistoryManager();
		}
		
		public function init(pNativeApp:NativeApplication, pMenu:XML):void
		{
			var menu:DeclarativeMenu = new DeclarativeMenu(pMenu); 
			menu.addEventListener(Event.SELECT, onMenuSelect);

			nativeAppBase = new NativeAppBase(pNativeApp, menu);
			nativeAppBase.addEventListener(NativeAppBase.EVENT_CLOSING, tryClosing);
			nativeAppBase.addEventListener(NativeAppBase.EVENT_SUBS_INVOKE, onInvoke);
			
			translationMemory.init();
			nativeAppBase.init();
						
		}
		
		public function get appName():String
		{
			return nativeAppBase.appName;
		}
		
		public function onCreationComplete():void
		{	
			
			/*
			// Kept for reference only - Lupo Manager does not require a license anymore
			licensed = licenseMgr.checkLicense();
			if( ! licensed) dispatchEvent(new Event(EVENT_REQUEST_LICENSE));
			else launch();						
			*/
			
			launch();
		}
		
		private function onRegistrationSuccess(pEvt:Event):void
		{	
			licensed=true;
		}
			
		public function launch():void
		{			
			// 1. The user tried to open a file
			if( nativeAppBase.parameters && nativeAppBase.parameters.length>0)
			{					
				var f:File = new File(nativeAppBase.parameters[0]);
									
				if( f.exists && f.extension=="lpm") openProjectFile(f);
				
				else promptErrorMessage("The file does not exist, or is not a valid project file.");
			}

			// 2. The App was launched without parameter
			else
			{					
				var lastProject:File = projectHistoryManager.getPreviousProject();				
				if( lastProject) openProjectFile(lastProject);				
				//	Note that we don't do anything here for now, the user can choose to open an existing project or create a new one
			}
		}
		
		// called if the app is invoked after launch
		private function onInvoke(pEvt:Event):void
		{
			//TODO add the capacity of opening a project by invokation even if the app is already opened
		}


		// Method used to check the changes made the the current project and save it
		// called on opening a new project, creating one, or closing the app
		private function projectClosingWarning(pCallback:Function):Boolean
		{
			//check if files need to be changed
			var changes:Boolean = false; 
			
			if( projectPM.currentProject !=null) changes = projectPM.currentProject.getHasChanged();
						
			if( changes)
			{
				Alert.show("Some bundles are not saved. If you don't save now, all changes will be lost. Do you want to save this project ?", 
							"Warning", Alert.YES|Alert.NO|Alert.CANCEL, null, pCallback);
			}
			
			return changes;			
		}		
		
		
		private function onEndOfExtraction(pEvt:Event):void
		{
			currentTab =TAB_BUNDLES;
		}
	
		public function promptOpenProject():void
		{
			var changed:Boolean = projectClosingWarning(onSaveOnOpenAnswer);			
			if(!changed) actuallyPromptOpenProject();			
		}
		
		private function onSaveOnOpenAnswer(pEvt:CloseEvent):void
		{
			if(pEvt.detail==Alert.YES) projectPM.currentProject.saveAllBundles();
			if(pEvt.detail!=Alert.CANCEL) actuallyPromptOpenProject();
		}	
		
		private function actuallyPromptOpenProject():void
		{
			var file:File = new File( File.documentsDirectory.nativePath);
			file.addEventListener(Event.SELECT, onProjectFileSelected);
			var filter:FileFilter= new FileFilter("Lupo Manager Project", "*.lpm");
			file.browseForOpen("Select a Project file", [filter]);
		}
			
		private function onProjectFileSelected(pEvt:Event):void
		{
			var file:File = pEvt.target as File;
			openProjectFile(file);
		}
		
		public function promptNewProject():void
		{
			var changed:Boolean = projectClosingWarning(onSaveOnCreateAnswer);			
			if(!changed) actuallyPromptNewProject();
		}
		
		private function onSaveOnCreateAnswer(pEvt:CloseEvent):void
		{
			if(pEvt.detail==Alert.YES) projectPM.currentProject.saveAllBundles();
			if(pEvt.detail!=Alert.CANCEL) actuallyPromptNewProject();
		}	
		
		private function actuallyPromptNewProject():void
		{
			dispatchEvent(new Event(EVENT_NEW_PROJECT));			
		}
		
		
		private function openProjectFile(pProjectFile:File):void
		{
			var project:Project = model.openProjectFile(pProjectFile);
			
			if(project==null)
			{
				promptErrorMessage("Invalid Project file. Please remove the LPM file from your Flex project and create a new lupo project");
				return;
			}
			
			setProject(project);
		}

		public function createProject(pName:String, pMasterLanguage:String, pLocaleDirectory:File, pSrcDir:File, pDefaultBundleName:String):void
		{
			var project:Project =model.createProject(pName, pMasterLanguage, pLocaleDirectory, pSrcDir, pDefaultBundleName);
			model.promptSaveProjectDescription();// auto save description	
			setProject( project);
		}
		
		private function setProject(pProject:Project):void
		{
			projectPM.currentProject = pProject;
			extractionPM.project = pProject ;
			projectHistoryManager.addProject(model.currentProjectFile);
			currentPage = PAGE_MAIN;			
		}
		
		private function refreshProject():void
		{
			var changed:Boolean = projectClosingWarning(onSaveOnRefreshAnswer);			
			if(!changed) actuallyRefreshProject();
		}
		private function onSaveOnRefreshAnswer(pEvt:CloseEvent):void
		{
			if(pEvt.detail==Alert.YES) projectPM.currentProject.saveAllBundles();
			if(pEvt.detail!=Alert.CANCEL) actuallyRefreshProject();
		}	
		
		
		private function actuallyRefreshProject():void
		{
			openProjectFile( model.currentProjectFile);
		}
		
		private function promptAboutDialog():void
		{
			Alert.show(nativeAppBase.appName+" "+nativeAppBase.appVersion+"\n\nProduct License:\n"+licenseMgr.license, "About");
		}
				
		public function promptExport():void
		{
			dispatchEvent( new Event(EVENT_EXPORT));
		}
		
		public function openHelp():void
		{
			var req:URLRequest = new URLRequest("http://www.dehats.com/drupal/?q=node/85");
			navigateToURL(req);
		}

		private function onMenuSelect(pEvt:Event):void
		{	
						
			var item:NativeMenuItem = pEvt.target as NativeMenuItem;
			
			switch (item.name)
			{
				case "HelpCommand":
					openHelp();
				break;
				
				case "PrefsCommand":
					dispatchEvent(new Event(EVENT_PREFS));
				break;
				
				case "QuitCommand":
					tryClosing();
				break;

				case "AboutCommand":
					promptAboutDialog();
				break;

				case "UnregisterCommand":
					promptUnregistrationDialog();
				break;

				case "CopyCommand":
					nativeAppBase.nativeApp.copy();
				break;

				case "PasteCommand":
					nativeAppBase.nativeApp.paste();
				break;

				case "CutCommand":
					nativeAppBase.nativeApp.cut();
				break;

				case "SelectAllCommand":
					nativeAppBase.nativeApp.selectAll();
				break;
								
				case "OpenCommand":
					if(licensed) promptOpenProject();
				break;

				case "CreateCommand":
					if(licensed) promptNewProject();
				break;

				case "ExportCommand":
					if(projectPM.currentProject!=null) promptExport();
				break;

				case "ImportCommand":
					if(projectPM.currentProject!=null) projectPM.promptImportFile();
				break;

				case "SaveCommand":
					if(projectPM.currentProject!=null) projectPM.currentProject.saveAllBundles();
				break;

				case "RefreshCommand":
					if(projectPM.currentProject!=null) refreshProject();
				break;


				default:break;
			}
			
		}
		
		private function promptUnregistrationDialog():void
		{
			if(licenseMgr.license==null) return;
			
			Alert.show("License:\n"+licenseMgr.license+"\n\nUnregistering will remove the licensing info from this operating system, making this software unusable unless a new license is provided. Only use this option if you want to use this software on another system.",
			 "Warning", Alert.OK|Alert.CANCEL, null, onUnregistrationAnswer1);			
		}
		
		private function onUnregistrationAnswer1(pEvt:CloseEvent):void
		{
			if( pEvt.detail==Alert.OK) Alert.show("Are you sure you want to unregister this software on this system ?",
			 "Last Warning", Alert.YES|Alert.NO, null, onUnregistrationAnswer2);		
		}

		private function onUnregistrationAnswer2(pEvt:CloseEvent):void
		{
			if( pEvt.detail==Alert.YES) licenseMgr.unregister();
		}
		private function onUnregistrationError(pEvt:Event):void
		{
			Alert.show("Unable to unregister this product, probably because the server cannot be reached. Please try again later.", "Unregistration failure");
		}		
		private function onUnregistrationSuccess(pEvt:Event):void
		{
			Alert.show("Unregistration successful", "Unregistration successful", Alert.OK, null, onUnregistrationOK);
		}
		private function onUnregistrationOK(pEvt:CloseEvent):void
		{
			tryClosing();
		}
		
		
		public function tryClosing(pEvt:Event=null):void
		{
			config.saveConfig();
			
			var changed:Boolean = projectClosingWarning(onSaveOnExitAnswer);				
			if(!changed) nativeAppBase.closeApp();
		}
		
		private function onSaveOnExitAnswer(pEvt:CloseEvent):void
		{
			if(pEvt.detail==Alert.YES) projectPM.currentProject.saveAllBundles();
			if(pEvt.detail!=Alert.CANCEL) nativeAppBase.closeApp();
		}	
			
	}
}