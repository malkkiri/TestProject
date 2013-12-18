/**
 * SoundController.
 * Date: 04.04.13
 * Time: 14:26
 * Sergey Sydorenko - sergey.sydorenko@gmail.com
 */

package model {
	import flash.display.Sprite;

	public class SoundController extends Sprite {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		private static var _instance:SoundController;
		//--------------------------------------------------------------------------
		//  Public properties
		//--------------------------------------------------------------------------

		public static var WIN_SOUND:String = "win";
		public static var LOSE_SOUND:String = "lose";

		public static var CLICK_SOUND:String = "click";
		public static var STEP_SOUND:String = "step";
		public static var PENALTY_SOUND:String = "fail";
		public static var FINISH_SOUND:String = "endGame";

		//--------------------------------------------------------------------------
		//  Protected properties
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private properties
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------
		public function SoundController() {
			super();
		}

		//--------------------------------------------------------------------------
		//  Public methods
		//--------------------------------------------------------------------------
		public static function get instance():SoundController {
			if (!_instance) {
				_instance = new SoundController();
			}
			return _instance;
		}

		public function playSound(soundName:String = ""):void {
			//trace("play " + soundName);
			if (!Main.flashVars.noContainerMode) {
				Main.cSCClientController.playSound(soundName);
			}
		}

		//--------------------------------------------------------------------------
		//  Protected methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Handlers 
		//--------------------------------------------------------------------------
	}
}
