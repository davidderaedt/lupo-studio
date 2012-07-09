package com.dehats.demoapp.presentation
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class AbstractPM extends EventDispatcher
	{
		public var l:Myi18nMgr;
		
		public function AbstractPM(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}