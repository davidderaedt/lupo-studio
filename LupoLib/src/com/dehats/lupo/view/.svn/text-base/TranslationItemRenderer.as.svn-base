package com.dehats.lupo.view
{
	import com.dehats.lupo.model.KeyValuePair;
	
	import mx.controls.dataGridClasses.DataGridItemRenderer;

	public class TranslationItemRenderer extends DataGridItemRenderer
	{
		public function TranslationItemRenderer()
		{
			super();
		}
	
		override public function set text(value:String):void
		{
			if(data.translation==null)
			{
				setStyle("fontStyle", "italic");
				setStyle("color", "0xAAAAAA");
				super.text="Not translated";				
			}
			else
			{
				//trace(">"+data.translation+"<")
				setStyle("fontStyle", "normal");
				setStyle("color", "0x000000");								
				super.text = value;
			} 
		}
		
	}
}