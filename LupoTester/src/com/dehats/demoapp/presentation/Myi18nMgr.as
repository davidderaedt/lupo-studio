package com.dehats.demoapp.presentation
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	
	public class Myi18nMgr extends EventDispatcher
	{
		
		public static const LOCALE_COLLEC:ArrayCollection=new ArrayCollection(["en_US", "fr_FR", "zh_CN"]);
		public static const FALLBACK:String="en_US";

		protected var resourceManager:IResourceManager ;
		
		
		public function Myi18nMgr(target:IEventDispatcher=null)
		{
			super(target);
			resourceManager = ResourceManager.getInstance();
		}
		
		
		public function setLocale(pLocale:String):void
		{
			resourceManager.localeChain=[pLocale, FALLBACK];
			dispatchEvent(new Event("change"));
		}
		
		
		[Bindable("change")]
		public function get welcome():String{
			return resourceManager.getString('Main', 'Welcome');
		}
		
		[Bindable("change")]
		public function get error():String{
			return resourceManager.getString('Main', 'Error');
		}
		
		[Bindable("change")]
		public function get hello_dear_costumer__and_welcome_to_our_():String{
			return resourceManager.getString('Main', 'Hello_dear_costumer__and_Welcome_to_our_');
		}
		
		[Bindable("change")]
		public function get an_error_has_occured__this_is_a_fake_err():String{
			return resourceManager.getString('Main', 'An_error_has_occured__this_is_a_fake_err');
		}
		
		[Bindable("change")]
		public function get product_name():String{
			return resourceManager.getString('Main', 'Product_Name');
		}
		
		[Bindable("change")]
		public function get quantity():String{
			return resourceManager.getString('Main', 'Quantity');
		}
		
		[Bindable("change")]
		public function get price():String{
			return resourceManager.getString('Main', 'Price');
		}
		
		[Bindable("change")]
		public function get total():String{
			return resourceManager.getString('Main', 'Total');
		}
		
		[Bindable("change")]
		public function get amazon_grants_you_a_limited_license_to_a():String{
			return resourceManager.getString('Main', 'Amazon_grants_you_a_limited_license_to_a');
		}
		
		[Bindable("change")]
		public function get conditions_of_use_():String{
			return resourceManager.getString('Main', 'Conditions_of_use_');
		}
		
		[Bindable("change")]
		public function get i_accept_those_conditions():String{
			return resourceManager.getString('Main', 'I_accept_those_conditions');
		}
		
		[Bindable("change")]
		public function get proceed_to_payment():String{
			return resourceManager.getString('Main', 'Proceed_to_Payment');
		}
		
		[Bindable("change")]
		public function get _lt_some_special_chars__amp__stuff_gt_():String{
			return resourceManager.getString('Main', '_lt_Some_special_chars__amp__stuff_gt_');
		}
		
		[Bindable("change")]
		public function get you_are_being_redirected_to_a_payment_in():String{
			return resourceManager.getString('Main', 'You_are_being_redirected_to_a_payment_in');
		}
		
		[Bindable("change")]
		public function get redirection():String{
			return resourceManager.getString('Main', 'Redirection');
		}
		
		[Bindable("change")]
		public function get personnal_infos():String{
			return resourceManager.getString('Main', 'Personnal_Infos');
		}
		
		[Bindable("change")]
		public function get firstname():String{
			return resourceManager.getString('Main', 'Firstname');
		}
		
		[Bindable("change")]
		public function get lastname():String{
			return resourceManager.getString('Main', 'Lastname');
		}
		
		[Bindable("change")]
		public function get date_of_birth():String{
			return resourceManager.getString('Main', 'Date_of_birth');
		}
		
		[Bindable("change")]
		public function get address():String{
			return resourceManager.getString('Main', 'Address');
		}
		
		[Bindable("change")]
		public function get submit():String{
			return resourceManager.getString('Main', 'Submit');
		}
		
		[Bindable("change")]
		public function get file_accept_png():Class{
			return resourceManager.getClass('Main', 'file_accept_png');
		}
		
		[Bindable("change")]
		public function get some_cool_shop():String{
			return resourceManager.getString('Main', 'Some_Cool_Shop');
		}
		
		[Bindable("change")]
		public function get a_demo_application():String{
			return resourceManager.getString('Main', 'A_demo_application');
		}
		
		[Bindable("change")]
		public function get sign_up():String{
			return resourceManager.getString('Main', 'Sign_Up');
		}
		
		[Bindable("change")]
		public function get login():String{
			return resourceManager.getString('Main', 'Login');
		}
		
		[Bindable("change")]
		public function get logout():String{
			return resourceManager.getString('Main', 'Logout');
		}
		
		[Bindable("change")]
		public function get products():String{
			return resourceManager.getString('Main', 'Products');
		}
		
		[Bindable("change")]
		public function get order_validation():String{
			return resourceManager.getString('Main', 'Order_Validation');
		}
		
		[Bindable("change")]
		public function get basket():String{
			return resourceManager.getString('Main', 'Basket');
		}
		
		[Bindable("change")]
		public function get personnal_informations():String{
			return resourceManager.getString('Main', 'Personnal_Informations');
		}
		
		[Bindable("change")]
		public function get confirmation():String{
			return resourceManager.getString('Main', 'Confirmation');
		}
		
		
	}
}