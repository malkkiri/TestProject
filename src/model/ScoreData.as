/**
 * ScoreData.
 * Date: 26.03.13
 * Time: 14:53
 * Oleg Kornienko - malkiri.oleg@gmail.com
 */

package model {
	public class ScoreData {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		private var _scorePoint:int = 0;
		private var userLifePoint:int = 0;
		private var levelNumber:int = 0;
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

		public function ScoreData() {
			super();
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

		//--------------------------------------------------------------------------
		//  Handlers 
		//--------------------------------------------------------------------------

		public function updateData(levelData:Object):void {
			var levelScore:int = 0;
			if (levelData.isEnemy) {
				trace("IS ENEMY WIN");
				//levelScore = 20 * (levelData.heroSteps as int) * levelNumber;
				//userLifePoint--;
			} else {
				levelScore = 20 * (levelData.heroSteps as int) * levelNumber + 10 * levelData.enemySteps;
				//				TotalScores = TotalScore + 20* G_num_step * Num_level + 10* W_step;
			}
			_scorePoint += levelScore;
			trace("levelScore= " + levelScore);
			trace("_scorePoint= " + _scorePoint);
		}

		public function setStartLevelParam(data:Object):void {
			levelNumber = data.level;
		}

		public function get scorePoint():int {
			return _scorePoint;
		}

		public function clear():void {
			_scorePoint = 0;
			userLifePoint = 0;
			levelNumber = 1;
		}
	}
}
