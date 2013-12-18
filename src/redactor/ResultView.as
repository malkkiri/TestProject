/**
 * ResultView.
 * Date: 01.10.13
 * Time: 0:12
 * Oleg Kornienko - oleg.kornienko.flash@gmail.com
 */

package redactor {
	import flash.display.Sprite;
	import flash.text.TextField;

	import org.osmf.metadata.Metadata;

	public class ResultView extends Sprite {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		private var resultLabel:TextField;
		private var herouPosition:TextField;
		private var enemyPosition:TextField;
		private var cheesePositionFirst:TextField;
		private var cheesePositionSecond:TextField;

		private var resultData:Object;
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

		public function ResultView(data:Object) {
			resultData = data;
			createResultPanel();
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
		private function createResultPanel():void {
			var field:TextField = getTextField(50, 20);
			field.text = "Field : ";
			this.addChild(field);

			resultLabel = getTextField(280, 160, true);
			resultLabel.text = resultData.field;
			resultLabel.x = field.x + field.textWidth + 5;
			this.addChild(resultLabel);

			//herou position
			var herou:TextField = getTextField(80, 20);
			herou.y = resultLabel.y + resultLabel.height + 10;
			herou.text = "Herou Position : ";
			this.addChild(herou);

			var herouLabel:TextField = getTextField(50, 20, true);
			herouLabel.text = resultData.herouPosition;
			herouLabel.x = herou.x + herou.width + 5;
			herouLabel.y = herou.y;
			this.addChild(herouLabel);

			//enemy position
			var enemy:TextField = getTextField(80, 20);
			enemy.x = herouLabel.x + herouLabel.width + 10;
			enemy.y = herou.y;
			enemy.text = "enemy Position : ";
			this.addChild(enemy);

			var enemyLabel:TextField = getTextField(50, 20, true);
			enemyLabel.text = resultData.enemyPosition;
			enemyLabel.x = enemy.x + enemy.width + 5;
			enemyLabel.y = enemy.y;
			this.addChild(enemyLabel);

			//goal position
			var itemPositionFirst:TextField = getTextField(120, 20);
			itemPositionFirst.y = enemyLabel.y + enemyLabel.height + 10;
			itemPositionFirst.text = "Item Position First : ";
			this.addChild(itemPositionFirst);

			var itemPositionFirstLabel:TextField = getTextField(50, 20, true);
			itemPositionFirstLabel.text = resultData.itemPositionFirst;
			itemPositionFirstLabel.x = itemPositionFirst.x + itemPositionFirst.width + 5;
			itemPositionFirstLabel.y = itemPositionFirst.y;
			this.addChild(itemPositionFirstLabel);

			//goal position second
			var itemPositionSecond:TextField = getTextField(120, 20);
			itemPositionSecond.y = itemPositionFirstLabel.y + itemPositionFirstLabel.height + 10;
			itemPositionSecond.text = "Item Position Second : ";
			this.addChild(itemPositionSecond);

			var itemPositionSecondLabel:TextField = getTextField(50, 20, true);
			itemPositionSecondLabel.text = resultData.itemPositionSecond;
			itemPositionSecondLabel.x = itemPositionSecond.x + itemPositionSecond.width + 5;
			itemPositionSecondLabel.y = itemPositionSecond.y;
			this.addChild(itemPositionSecondLabel);

			//columns
			var columns:TextField = getTextField(50, 20);
			columns.y = itemPositionSecondLabel.y + itemPositionSecondLabel.height + 10;
			columns.text = "Colums : ";
			this.addChild(columns);

			var columnsLabel:TextField = getTextField(50, 20, true);
			columnsLabel.text = resultData.colums;
			columnsLabel.x = columns.x + columns.width + 5;
			columnsLabel.y = columns.y;
			this.addChild(columnsLabel);

			//rows
			var row:TextField = getTextField(50, 20);
			row.x = columnsLabel.x + columnsLabel.width + 10;
			row.y = columnsLabel.y;
			row.text = "Rows : ";
			this.addChild(row);

			var rowLabel:TextField = getTextField(50, 20, true);
			rowLabel.text = resultData.rows;
			rowLabel.x = row.x + row.width + 5;
			rowLabel.y = row.y;
			this.addChild(rowLabel);
		}

		private function getTextField(w:int, h:int, isBorder:Boolean = false):TextField {
			var fieldResult:TextField = new TextField();
			fieldResult.wordWrap = true;
			fieldResult.border = isBorder;
			fieldResult.width = w;
			fieldResult.height = h;
			return fieldResult;
		}

		//--------------------------------------------------------------------------
		//  Handlers 
		//--------------------------------------------------------------------------

	}
}
