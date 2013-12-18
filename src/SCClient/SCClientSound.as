package SCClient
{
	import com.junkbyte.console.Cc;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author ArtDon
	 */
	public class SCClientSound
	{
		private static var mem:Object = { };
		
		public function SCClientSound()
		{
		
		}
		
		public static function playSound(snd:String):void {
			var mems:Object = mem[snd];
			if (mems) {
				mems['chanels'].stop();
				mems['chanels'] = mems.sound.play();
			}
			else {
				mems = { };
				var s:Sound = new Sound();
				mems.sound = s;
				s.load(new URLRequest(Main.flashVars.mainUrl + Main.flashVars.gameId + Main.fixPath + "sounds/" + snd + ".mp3"));	

				
				s.addEventListener(Event.COMPLETE, playIt);
			}
		}
		
		static private function playIt(e:Event):void 
		{
			var s:Sound = e.currentTarget as Sound;
			var ch:SoundChannel = s.play();
			var tmpArray:Array = s.url.split('/');
			var getCORE:String = (tmpArray[tmpArray.length-1] as String).substr(0, -4);			
			var obg:Object = { };
			obg.chanels = ch;
			obg.sound = s;
			mem[getCORE] = obg;
			trace(getCORE);
		}
		
		
		public static function stopSound(snd:String):void {
			var mems:Object = mem[snd];
			if (mems) {
				mems['chanels'].stop();				
			}
		}
		
	}
}