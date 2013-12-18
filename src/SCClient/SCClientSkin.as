package SCClient
{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.system.System;
	
	/**
	 * ...
	 * @author ArtDon
	 */
	public class SCClientSkin
	{
		public function SCClientSkin()
		{
		
		}

		public static function setAsButton(mc:MovieClip, urlCore:String):void
		{
			var sp:MovieClip;
			
			var typeM:MovieClip = new MovieClip();
			mc.addChild(typeM);
			typeM.name = "button";
			
			sp = new MovieClip();
			sp.name = "skin_1";
			sp.addChild(new SCClentGLoader("./tunes/" + urlCore + '_normal.png'));
			mc.addChild(sp);
			sp = new MovieClip();
			sp.name = "skin_2";
			sp.addChild(new SCClentGLoader("./tunes/" + urlCore + '_over.png'));
			sp.visible = false;
			mc.addChild(sp);
			sp = new MovieClip();
			sp.visible = false;
			sp.addChild(new SCClentGLoader("./tunes/" + urlCore + '_down.png'));
			sp.name = "skin_3";
			mc.addChild(sp);
			mc.buttonMode = true;
			mc.mouseChildren = false;
			mc.addEventListener(MouseEvent.ROLL_OVER, onOver);
			mc.addEventListener(MouseEvent.ROLL_OUT, onOut);
			mc.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			mc.addEventListener(MouseEvent.MOUSE_UP, onOut);
			
	
		}
		
		
		
		static private function onDown(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			(mc.getChildByName("skin_1") as MovieClip).visible = false;
			(mc.getChildByName("skin_2") as MovieClip).visible = false;
			(mc.getChildByName("skin_3") as MovieClip).visible = true;
		}
		
		static private function onOut(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			(mc.getChildByName("skin_1") as MovieClip).visible = true;
			(mc.getChildByName("skin_2") as MovieClip).visible = false;
			(mc.getChildByName("skin_3") as MovieClip).visible = false;
		}
		
		static private function onOver(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			(mc.getChildByName("skin_1") as MovieClip).visible = false;
			(mc.getChildByName("skin_2") as MovieClip).visible = true;
			(mc.getChildByName("skin_3") as MovieClip).visible = false;
		}
		
	
		
		

		public static function setAsMovieClip(mc:MovieClip, urlCore:String):void
		{			
			var sp:MovieClip = new MovieClip();
			
			var typeM:MovieClip = new MovieClip();
			mc.addChild(typeM);
			typeM.name = "sprite";

			
			sp.name = "skin";
			mc.addChild(sp);
			
			sp.addChild(new SCClentGLoader("./tunes/" + urlCore + '.png'));


		}
		
		
		
		
		
	}

}