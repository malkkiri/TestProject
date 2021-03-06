/**
 * GameLayer.
 * Date: 18.03.13
 * Time: 12:59
 * Oleg Kornienko - malkiri.oleg@gmail.com
 */

package view.layer {
	import com.greensock.TweenMax;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.SimpleButton;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;

	import flashx.textLayout.edit.IInteractionEventHandler;

	import model.LevelController;

	import view.GameFieldView;
	import view.ViewController;

	public class StartLayer extends Sprite {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		private var content:Sprite;
		private var playBtn:SimpleButton;
		private var howToPlayBtn:SimpleButton;

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

		public function StartLayer(_viewController:ViewController) {
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
			content = new scene1_mc();
			this.addChild(content);

			playBtn = content["playBtn"];
			howToPlayBtn = content["howToPlayBtn"];
			startListen();
		}

		private function startListen():void {
			playBtn.addEventListener(MouseEvent.CLICK, mouseEventHandler, false, 0, true);
			howToPlayBtn.addEventListener(MouseEvent.CLICK, mouseEventHandler, false, 0, true);
		}

		//--------------------------------------------------------------------------
		//  Handlers
		//--------------------------------------------------------------------------
		private function mouseEventHandler(event:MouseEvent):void {
			if (event.currentTarget == playBtn) {
				viewController.showPlayScene();
			}
			if (event.currentTarget == howToPlayBtn) {
				viewController.showHowToPlayScene();
			}
		}

		//--------------------------------------------------------------------------
		//  Destroy
		//--------------------------------------------------------------------------
		public function destroy():void {

			playBtn.removeEventListener(MouseEvent.CLICK, mouseEventHandler);
			howToPlayBtn.removeEventListener(MouseEvent.CLICK, mouseEventHandler);

			playBtn = null;
			howToPlayBtn = null;

			this.removeChild(content);
			content = null;

			while (this.numChildren > 0) {
				this.removeChildAt(0);
			}
		}
	}
}
