/**
 * FieldModel.
 * Date: 13.03.13
 * Time: 15:03
 * Oleg Kornienko - malkiri.oleg@gmail.com
 */

package model {
	import com.greensock.TweenMax;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.setTimeout;

	import view.GameFieldView;
	import view.cell.CellItem;

	public class ShowStarController extends EventDispatcher {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------
		public static const EVENT_END_STAR:String = "event_end_star";
		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		private var cellDict:Dictionary = new Dictionary();
		private var pathList:Array = [];
		private var timer:Timer;
		private var innerId:int;
		private var gameView:GameFieldView;

		private var isWithTimeout:Boolean;

		private var isPause:Boolean;
		private var allStarCount:int;
		private var finishStarCount:int;

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

		public function ShowStarController(game:GameFieldView) {
			gameView = game;
		}

		//--------------------------------------------------------------------------
		//  Public methods
		//--------------------------------------------------------------------------
		public function showStars(ar:Array = null, _cellDict:Dictionary = null):void {
			cellDict = _cellDict;
			pathList = ar;
			allStarCount = pathList.length;
			addTimer(pathList.length);
		}

		public function onPause(val:Boolean):void {
			isPause = val;
			if (val) {
				clearTimer();
			} else {
				addTimer(allStarCount - finishStarCount);
			}
		}

		//--------------------------------------------------------------------------
		//  Protected methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private methods
		//--------------------------------------------------------------------------
		private function addTimer(count:int = 0):void {
			if (allStarCount == 0) {
				setTimeout(onCompleteTween, 500);
				//	onCompleteTween();
				return;
			}
			timer = new Timer(200, allStarCount);
			timer.addEventListener(TimerEvent.TIMER, timerEventHandler, false, 0, true);
			timer.start();
		}

		private function timerEventHandler(event:TimerEvent):void {
			if (isPause)return;
			finishStarCount++;
			addStar();
		}

		private function addStar():void {
			innerId++;
			if (!pathList[0]) return;
			var position:Point = pathList[0];
			var cell:CellItem = cellDict[position.x + "," + position.y];
			//cell.setAsCompleted("move_down");
			var item:Sprite = new CellStar();
			//var bt:Bitmap = new Bitmap(new cheese());
			//bt.x = -bt.width * 0.5;
			//bt.x = -bt.height * 0.5;
			//item.addChild(bt);
			item.x = cell.x + int((cell.width - item.width) * 0.5) + item.width * 0.5;
			item.y = cell.y + int((cell.height - item.height) * 0.5) + item.height * 0.5;
			//item.scaleX = item.scaleY = 1.5;
			gameView.addChild(item);

			TweenMax.to(item, 0.5, {scaleX: 0, scaleY: 0, rotation: 90, onComplete: onCompleteTween, onCompleteParams: [pathList.length]});
			pathList.splice(0, 1);
		}

		private function onCompleteTween(len:int = 1):void {
			if (len == 1) {
				if (isPause)return;
				dispatchEvent(new Event(ShowStarController.EVENT_END_STAR));
				clearTimer();
			}
		}

		private function clearTimer():void {
			if (timer) {
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, timerEventHandler);
				timer = null;
			}

		}

		//--------------------------------------------------------------------------
		//  Handlers
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Destroy
		//--------------------------------------------------------------------------
		public function destroy():void {
			clearTimer();
			cellDict = null;
			pathList = null;
			gameView = null;
		}

	}
}
