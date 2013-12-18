/**
 * GameLayer.
 * Date: 18.03.13
 * Time: 12:59
 * Oleg Kornienko - malkiri.oleg@gmail.com
 */

package view.layer {
	import flash.display.SimpleButton;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import model.LevelController;

	import view.ViewController;

	public class FinishLayer extends Sprite {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		private var content:Sprite;
		private var continueBtn:SimpleButton;

		private var viewController:ViewController;

		//--------------------------------------------------------------------------
		//  Public properties
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Protected properties
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private properties
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------

		public function FinishLayer(_viewController:ViewController) {
			viewController = _viewController;
			init();
		}

		//--------------------------------------------------------------------------
		//  Public methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Protected methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private methods
		//--------------------------------------------------------------------------
		private function init():void {
			content = new scene3_mc();
			this.addChild(content);
			continueBtn = content["continueBtn"];
			(content["resultTf"] as TextField).text = LevelController.instance.getScoreTotalPoint().toString();
			startListen();
		}

		private function startListen():void {
			continueBtn.addEventListener(MouseEvent.CLICK, mouseEventHandler, false, 0, true);
		}

		//--------------------------------------------------------------------------
		//  Handlers
		//--------------------------------------------------------------------------   ibhyf
		private function mouseEventHandler(event:MouseEvent):void {
			//viewController.showStartLayer();
			Main.cSCClientController.showMainMenu();
			LevelController.instance.saveScore();
		}

		//--------------------------------------------------------------------------
		//  Destroy
		//--------------------------------------------------------------------------
		public function destroy():void {

			continueBtn.removeEventListener(MouseEvent.CLICK, mouseEventHandler);
			continueBtn = null;

			this.removeChild(content);
			content = null;

			while (this.numChildren > 0) {
				this.removeChildAt(0);
			}
		}
	}
}
