package com.dehats.lupotranslator.presentation
{
	import com.dehats.air.DeclarativeMenu;
	import com.dehats.air.LicenseManager;
	import com.dehats.air.NativeAppBase;
	import com.dehats.lupo.model.Bundle;
	import com.dehats.lupo.model.Project;
	import com.dehats.lupo.model.TranslationMemory;
	import com.dehats.lupo.presentation.AbsPMPM;
	import com.dehats.lupo.presentation.TranslationPanelPM;
	import com.dehats.lupotranslator.model.ProjectHistoryManager;
	import com.dehats.lupotranslator.model.PropTranslatorModel;
	
	import flash.desktop.NativeApplication;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	[Bindable]
	public class AppPM extends AbsPMPM
	{
		
		public static const EVENT_PROJECT_CREATE:String="createProject";		
		public static const EVENT_REQUEST_LICENSE:String="requestLicense";		
		
		public static const REGISTRATION_SCRIPT_URL:String="http://www.dehats.com/products/common/registration.php";		
		public static const UNREGISTRATION_SCRIPT_URL:String="http://www.dehats.com/products/common/unregistration.php";		
		public static const PRODUCT_CODE:String="lupo translator";		
		
		public static const PAGE_HOME:int=0;
		public static const PAGE_MAIN:int=1;
		
		public var model:PropTranslatorModel = new PropTranslatorModel();
		public var translationPanelPM:TranslationPanelPM;
		public var currentProject:Project;
		public var selectedBundle:Bundle;
		public var bundleCollec:ArrayCollection;
		public var currentPage:int;
		public var ready:Boolean = false;
		public var licenseMgr:LicenseManager;
		
		private var nativeAppBase:NativeAppBase;
		private var translationMemory:TranslationMemory;
		private var projectHistoryManager:ProjectHistoryManager;		
		private var licensed:Boolean=false;
		
		
		public function AppPM()
		{			
			licenseMgr = new LicenseManager(REGISTRATION_SCRIPT_URL, UNREGISTRATION_SCRIPT_URL, PRODUCT_CODE);		
			licenseMgr.addEventListener( LicenseManager.EVENT_REGISTRATION_SUCCESSFULL, onRegistrationSuccess);			
			licenseMgr.addEventListener( LicenseManager.EVENT_UNREGISTRATION_SUCCESSFULL, onUnregistrationSuccess);
			licenseMgr.addEventListener( LicenseManager.EVENT_UNREGISTRATION_ERROR, onUnregistrationError);
			licenseMgr.addEventListener( LicenseManager.EVENT_UNREGISTRATION_FAILURE, onUnregistrationError);
			
			projectHistoryManager = new ProjectHistoryManager();
			
			translationMemory = new TranslationMemory();
		}
		
		public function init(pNativeApp:NativeApplication, pMenu:XML):void
		{
			var menu:DeclarativeMenu = new DeclarativeMenu(pMenu); 
			menu.addEventListener(Event.SELECT, onMenuSelect);

			nativeAppBase = new NativeAppBase(pNativeApp, menu);
			nativeAppBase.addEventListener(NativeAppBase.EVENT_CLOSING, tryClosing);
			
			translationMemory.init();
			
			nativeAppBase.init();
						
		}		
		
		public function onCreationComplete():void
		{		
			translationPanelPM = new TranslationPanelPM(true, translationMemory);	

			launch();
			
			/*

			// Kept for reference only - Lupo Translatoor is now free of charge
			
			licensed = licenseMgr.checkLicense();
			if( ! licensed) dispatchEvent(new Event(EVENT_REQUEST_LICENSE));
			
			*/
		}
		private function onRegistrationSuccess(pEvt:Event):void
		{	
			licensed=true;
		}
		
		public function get appName():String
		{
			return nativeAppBase.appName;
		}
		
		
		public function launch():void
		{
			// Decide what to do depending on the launch scenario :
			
			// 1. The user tried to open a file
			if( nativeAppBase.parameters.length>0)
			{					
				var f:File = new File(nativeAppBase.parameters[0]);
									
				if( f.exists && f.extension=="lpt")
				{
					openManifestFile(f);
				}
				
				else promptErrorMessage("The file does not exist, or is not a valid project file.");
			}

			// 2. The App was launched without parameter
			else
			{	
				
				var lastProject:File = projectHistoryManager.getPreviousProject();
				
				if( lastProject) openManifestFile(lastProject);
				
				/* We don't do anything here for now, the user can choose to open
					an existing project or create a new one */
			}
			
			// make the main interface visible
			ready=true;
		}
		

		public function tryClosing(pEvt:Event=null):void
		{
			// TODO check changes
			nativeAppBase.closeApp();
		}
		
		public function promptAboutDialog():void
		{
			Alert.show(nativeAppBase.appName+" "+nativeAppBase.appVersion, "About");
		}
		

		public function promptOpenManifest():void
		{
			var manifestFile:File = new File();
			manifestFile.addEventListener(Event.SELECT, onManifestSelected);
			manifestFile.browseForOpen("Please select a translation project (LPT) file");
		}	
		
		private function onManifestSelected(pEvt:Event):void
		{
			openManifestFile(pEvt.target as File);
		}
		
		private function openManifestFile(pFile:File):void
		{
			var project:Project = model.openTranslationProjectManifest(pFile);			
			setProject(project);		
		}
		
		public function createNewTranslationProject(localeDir:File, projectName:String, masterLg:String):void
		{
			var project:Project = model.createNewTranslationProject(localeDir, projectName, masterLg);
			setProject(project);			
		}
		
		private function setProject(pProject:Project):void
		{
			currentProject =pProject;		
			currentProject.addEventListener(Project.ANALYSIS_DONE, onProjectReady);						
			projectHistoryManager.addProject(model.currentProjectFile);
			
			if(currentPage != PAGE_MAIN) currentPage = PAGE_MAIN;
		}
		
		
		private function onProjectReady(pEvt:Event):void
		{			
			bundleCollec = currentProject.bundleCollec ;
			selectBundle( bundleCollec.getItemAt(0) as Bundle);
			
		}
		
		public function selectBundle(pBundle:Bundle):void
		{
			selectedBundle = pBundle;
			translationPanelPM.setContext(selectedBundle, currentProject.targetLanguages);
		}
		
		private function onMenuSelect(pEvt:Event):void
		{	
						
			var item:NativeMenuItem = pEvt.target as NativeMenuItem;
			
			switch (item.name)
			{
				case "QuitCommand":
					tryClosing();
				break;

				case "AboutCommand":
					promptAboutDialog();
				break;

				case "HelpCommand":
					openHelp();
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
					 if(licensed) promptOpenManifest();
				break;

				case "CreateCommand":
					if(licensed) dispatchEvent( new Event(EVENT_PROJECT_CREATE));
				break;
				
				case "SaveCommand":
					if(translationPanelPM.bundle!=null)translationPanelPM.save();
				break;
				
				

				default:break;
			}
			
		}		

		public function openHelp():void
		{
			var req:URLRequest = new URLRequest("http://www.dehats.com/products/lupotrans/help.html");
			navigateToURL(req);
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
				
	}
}