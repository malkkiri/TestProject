/**
 * ViewController.
 * Date: 26.03.13
 * Time: 17:29
 * Oleg Kornienko - malkiri.oleg@gmail.com
 */

package view {
	import flash.display.Sprite;

	import view.layer.FinishLayer;

	import view.layer.GameLayer;

	import view.layer.HelpLayer;

	import view.layer.StartLayer;

	public class ViewController extends Sprite {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		private var startScene:StartLayer;
		private var helpScene:HelpLayer;
		private var gameScene:GameLayer;
		private var endScene:FinishLayer;

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

		public function ViewController() {
			super();
			initStartScene();
		}

		private function initStartScene():void {
			//showStartLayer();
			//showFinishScene();
			showPlayScene();
		}

		//--------------------------------------------------------------------------
		//  Public methods
		//--------------------------------------------------------------------------
		public function showPlayScene():void {
			gameScene = new GameLayer(this);
			this.addChild(gameScene);

			clearLayer(helpScene);
			clearLayer(startScene);
			clearLayer(endScene);
		}

		public function showHowToPlayScene():void {
			helpScene = new HelpLayer(this);
			this.addChild(helpScene);

			clearLayer(gameScene);
			clearLayer(endScene);
			clearLayer(startScene);
		}

		public function showFinishScene():void {
			endScene = new FinishLayer(this);
			this.addChild(endScene);

			clearLayer(gameScene);
			clearLayer(helpScene);
			clearLayer(startScene)
		}

		public function showStartLayer():void {
			startScene = new StartLayer(this);
			this.addChild(startScene);

			clearLayer(gameScene);
			clearLayer(helpScene);
			clearLayer(endScene)
		}

		//--------------------------------------------------------------------------
		//  Protected methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private methods
		//--------------------------------------------------------------------------
		private function clearLayer(layer:* = null):void {
			if (!layer)return;
			if (this.contains(layer)) {
				this.removeChild(layer);
				layer.destroy();
				layer = null;
			}
		}

		//--------------------------------------------------------------------------
		//  Handlers
		//--------------------------------------------------------------------------

		public function onPause(val:Boolean):void {
			if(gameScene){
				gameScene.onPause(val);
			}
		}
	}
}
