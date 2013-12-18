package {
	/*
	 * setTimeout(ready, 100); //Ето для теста, если Вы запускаете флеш без контейтера   --- Вам надо убрать эту сроку для релиза.


	 Шаги по созданию игры с использованием контейнера.

	 создаем папку root, в папку ложем папку tunes.
	 в папку root ложем фаил игры game.swf и фаил настройки игры (tunes.dat), в папку tunes всю графику, в папку tunes\sounds - все звуки.
	 *
	 *
	 *
	 * // ОБЯЗАТЕЛЬНО
	 * Звук загружаем и воспроизводим через контейнер
	 * Графику грузим и используем через контейнер
	 * Читаем и Пишем в фиал настройки через контейнер
	 * */

	//import com.adobe.serialization.json.JSON;
	import com.junkbyte.console.Cc;

	import flash.display.MovieClip;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;

	import SCClient.SCClientController;

	import model.LevelController;

	import serialization.JSON1;

	/**
	 * ...
	 * @author ArtDon
	 */
	[SWF(width="640", height="480", frameRate="30", backgroundColor="#CCE3FF")]

	public class Main extends Sprite {
		public static var flashVars:Object; // Эта переменная обязательна!
		public static var cSCClientController:SCClientController = new SCClientController(); // Эта переменная обязательна!
		private var tuneLoader:URLLoader = new URLLoader();
		public static var fixPath:String;

		public static var gameTuneData:Object;

		public static var game:PenguinGame;

		public function Main():void {
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void {
			Cc.startOnStage(this, '`');
			Cc.log("game init");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			trace(stage.frameRate);
			if (!ExternalInterface.available) {
//				ready(); // ЭТО ДЛЯ ТЕСТА ЕСЛИ ВЫ ЗАПУСКАЕТЕСЬ НЕ С КОНТЕЙНЕРА ИНАЧЕ НУЖНО УБРАТЬ ЭТУ СТРОКУ
			}
			//setTimeout(callAdminPanel, 500);

			//stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		private var isPause:Boolean;

		private function onKeyDown(event:KeyboardEvent):void {
			if (event.charCode == Keyboard.SPACE) {
				isPause = !isPause;
				setPause(isPause);
			}
		}

		public function callAdminPanel():void // Эта функция обязательна! она должна выводить (запускать админ панель для настраивания игры)
		{
			//cGUI.addChild(new AdminPanel());
		}

		private function setGameLayaut():void {
			return;
			var data:URLRequest = new URLRequest(Main.flashVars.mainUrl + "savePosTune.php");
			var urlVariables:URLVariables = new URLVariables;
			data.method = "POST";
			urlVariables.data = '{"endBgText":{"x":"-66","y":"-23","t":"sprite"},"veryBad":{"x":"0","y":"0","t":"sprite"},"buttonRight":{"x":"201","y":"6","t":"button"},"buttonLeft":{"x":"207","y":"5","t":"button"},"endBg":{"x":"0","y":"0","t":"sprite"},"bg9":{"x":"0","y":"-6","t":"sprite"},"timerBg":{"x":"-43","y":"-6","t":"sprite"},"endTitle":{"x":"55","y":"40","t":"sprite"},"buttonUp":{"x":"205","y":"5","t":"button"},"r1":{"x":"0","y":"0","t":"sprite"},"buttonDown":{"x":"204","y":"2","t":"button"},"bgPlay":{"x":"0","y":"0","t":"sprite"}}';
			urlVariables.w = "Game";
			urlVariables.g = Main.flashVars.gameId;
			data.data = urlVariables;
			//navigateToURL(data, '_self');

			if (ExternalInterface.available) {
				ExternalInterface.call("saveLayout", urlVariables);
			}
		}

		private function setInstractLayaut():void {
			return;
			var data:URLRequest = new URLRequest(Main.flashVars.mainUrl + "savePosTune.php");
			var urlVariables:URLVariables = new URLVariables;
			data.method = "POST";
			urlVariables.data = '{"butPrev":{"type":"button","speed":1,"start":{"alpha":"1","scaleX":1,"scaleY":1,"rotation":0,"x":0,"y":0},"end":{"alpha":1,"scaleX":1,"scaleY":1,"rotation":0,"x":65,"y":374},"tween":"Elastic.easeInOut"},"butBack":{"type":"button","speed":1,"start":{"alpha":0,"scaleX":1,"scaleY":1,"rotation":0,"x":0,"y":0},"end":{"alpha":1,"scaleX":1,"scaleY":1,"rotation":0,"x":240,"y":375},"tween":"Elastic.easeInOut"},"bg":{"type":"sprite","speed":1,"start":{"alpha":0,"scaleX":1,"scaleY":1,"rotation":0,"x":0,"y":0},"end":{"alpha":1,"scaleX":1,"scaleY":1,"rotation":0,"x":-1,"y":1},"tween":"Elastic.easeInOut"},"butNext":{"type":"button","speed":1,"start":{"alpha":0,"scaleX":1,"scaleY":1,"rotation":0,"x":0,"y":0},"end":{"alpha":1,"scaleX":1,"scaleY":1,"rotation":0,"x":414,"y":374},"tween":"Elastic.easeInOut"},"cont":{"type":"sprite","realname":"cont","tween":"Elastic.easeInOut","end":{"alpha":1,"scaleX":1,"scaleY":1,"rotation":0,"x":-2,"y":2},"speed":1,"start":{"alpha":0,"scaleX":1,"scaleY":1,"rotation":0,"x":0,"y":0}},"count":{"count":"1","type":"counter"}}';
			urlVariables.w = "Inctru";
			urlVariables.g = Main.flashVars.gameId;
			data.data = urlVariables;
			//navigateToURL(data, '_self');

			if (ExternalInterface.available) {
				ExternalInterface.call("saveLayout", urlVariables);
			}
		}

		private function setMainMenuLayaut():void {
			return;
			var data:URLRequest = new URLRequest(Main.flashVars.mainUrl + "savePosTune.php");
			var urlVariables:URLVariables = new URLVariables;
			data.method = "POST";
			urlVariables.data = '{"butPlay":{"type":"button","speed":1,"tween":"Elastic.easeInOut","start":{"alpha":0,"scaleX":1,"scaleY":1,"rotation":0,"x":0,"y":0},"end":{"alpha":1,"scaleX":1,"scaleY":1,"rotation":0,"x":427,"y":401}},"title":{"type":"sprite","speed":1,"tween":"Elastic.easeInOut","start":{"alpha":0,"scaleX":1,"scaleY":1,"rotation":0,"x":0,"y":0},"end":{"alpha":1,"scaleX":1,"scaleY":1,"rotation":0,"x":87,"y":13}},"butHelp":{"type":"button","speed":1,"tween":"Elastic.easeInOut","start":{"alpha":0,"scaleX":1,"scaleY":1,"rotation":0,"x":0,"y":0},"end":{"alpha":1,"scaleX":1,"scaleY":1,"rotation":0,"x":51,"y":400}},"bg":{"type":"sprite","speed":1,"tween":"Elastic.easeInOut","start":{"alpha":1,"scaleX":1,"scaleY":1,"rotation":0,"x":0,"y":0},"end":{"alpha":1,"scaleX":1,"scaleY":1,"rotation":0,"x":-1,"y":-1}},"center":{"type":"sprite","speed":1,"tween":"Elastic.easeInOut","start":{"alpha":0,"scaleX":1,"scaleY":1,"rotation":0,"x":0,"y":0},"end":{"alpha":1,"scaleX":1,"scaleY":1,"rotation":0,"x":70,"y":187}},"footer":{"type":"sprite","tween":"Elastic.easeInOut","realname":"footer","end":{"alpha":1,"scaleX":1,"scaleY":1,"rotation":0,"x":195,"y":146},"speed":1,"start":{"alpha":0,"scaleX":1,"scaleY":1,"rotation":0,"x":0,"y":0}}}';
			urlVariables.w = "MainMenu";
			urlVariables.g = Main.flashVars.gameId;
			data.data = urlVariables;
			//navigateToURL(data, '_self');

			if (ExternalInterface.available) {
				ExternalInterface.call("saveLayout", urlVariables);
			}
		}

		public function setPause(val:Boolean):void // Эта функция обязательна! она true false - вкл выкл пауза
		{

			//cGUI.cGamePole.pause(val);
			if (game) {
				game.onPause(val);
			}
		}

		public function start(_flashVars:Object = null):void // Эта функция обязательна!
		{ //игрок нажмет старт, контейнер дернит эту функцию и передаст в нее параметры от сервера.	/ все также как и в 5456y - но вдруг юзер изменил параметр Main.flashVars.butVolume
			Cc.log("game start");
			trace("Start");
			game.start();
			//cGUI.start(); //Ваша функция на Ваше усмотрение
		}

		public function ready(_flashVars:Object = null):void // Эта функция обязательна!
		{ //Когда контейнер подгрузит Ваш флеш, контейнер дернит эту функцию и передаст в нее параметры от сервера.

			Cc.log("game ready");
			flashVars = _flashVars;
			addChild(cSCClientController); // Обязательно положите екземпляр этого класса в рутовый sprite
			if (!flashVars) // Если игра запущенна не контейнером, сами для теста заполняем данные.
			{
				Main.flashVars = {};
				Main.flashVars.noContainerMode = true; // Пути если Вы запускаете свою игру из контейнера и нет - разные, для этого вводим эту переменную, что бы можно было тестить и без контейнера - так удобнее
				Main.flashVars.gameId = "lostmigration"; //папка в которой лежит Ваша игра/
				Main.flashVars.userId = "1"; // id юзера
				Main.flashVars.mainUrl = "http://artdoncenter.com.ua/SmartContainer/"; // - он равен ./ всегда - не знаю зачем я ввел этот параметр - видимо потом пригодится не обращайте вниматия на него
				Main.flashVars.butVolume = true; // Включен или выключен у юзера звук
				Main.flashVars.levels = [10, 0, -1]; // Статус уровней для Вашей игры, -1 - заблокирован, >1 - количество набраных очков, 0 - не пройден
				// Main.flashVars.gameData = {};
				/*
				 Main.flashVars.instructionLayout = {"butPrev": {"type": "button", "speed": 1, "start": {"alpha": "1", "scaleX": 1, "scaleY": 1, "rotation": 0, "x": 0, "y": 0}, "end": {"alpha": 1, "scaleX": 1, "scaleY": 1, "rotation": 0, "x": 65, "y": 374}, "tween": "Elastic.easeInOut"}, "butBack": {"type": "button", "speed": 1, "start": {"alpha": 0, "scaleX": 1, "scaleY": 1, "rotation": 0, "x": 0, "y": 0}, "end": {"alpha": 1, "scaleX": 1, "scaleY": 1, "rotation": 0, "x": 240, "y": 375}, "tween": "Elastic.easeInOut"}, "bg": {"type": "sprite", "speed": 1, "start": {"alpha": 0, "scaleX": 1, "scaleY": 1, "rotation": 0, "x": 0, "y": 0}, "end": {"alpha": 1, "scaleX": 1, "scaleY": 1, "rotation": 0, "x": -1, "y": 1}, "tween": "Elastic.easeInOut"}, "butNext": {"type": "button", "speed": 1, "start": {"alpha": 0, "scaleX": 1, "scaleY": 1, "rotation": 0, "x": 0, "y": 0}, "end": {"alpha": 1, "scaleX": 1, "scaleY": 1, "rotation": 0, "x": 414, "y": 374}, "tween": "Elastic.easeInOut"}, "cont": {"type": "sprite", "realname": "cont", "tween": "Elastic.easeInOut", "end": {"alpha": 1, "scaleX": 1, "scaleY": 1, "rotation": 0, "x": -2, "y": 2}, "speed": 1, "start": {"alpha": 0, "scaleX": 1, "scaleY": 1, "rotation": 0, "x": 0, "y": 0}}, "count": {"count": "1", "type": "counter"}};
				 Main.flashVars.mainmenuLayout = {"butPlay": {"type": "button", "speed": 1, "tween": "Elastic.easeInOut", "start": {"alpha": 0, "scaleX": 1, "scaleY": 1, "rotation": 0, "x": 0, "y": 0}, "end": {"alpha": 1, "scaleX": 1, "scaleY": 1, "rotation": 0, "x": 427, "y": 401}}, "title": {"type": "sprite", "speed": 1, "tween": "Elastic.easeInOut", "start": {"alpha": 0, "scaleX": 1, "scaleY": 1, "rotation": 0, "x": 0, "y": 0}, "end": {"alpha": 1, "scaleX": 1, "scaleY": 1, "rotation": 0, "x": 87, "y": 13}}, "butHelp": {"type": "button", "speed": 1, "tween": "Elastic.easeInOut", "start": {"alpha": 0, "scaleX": 1, "scaleY": 1, "rotation": 0, "x": 0, "y": 0}, "end": {"alpha": 1, "scaleX": 1, "scaleY": 1, "rotation": 0, "x": 51, "y": 400}}, "bg": {"type": "sprite", "speed": 1, "tween": "Elastic.easeInOut", "start": {"alpha": 1, "scaleX": 1, "scaleY": 1, "rotation": 0, "x": 0, "y": 0}, "end": {"alpha": 1, "scaleX": 1, "scaleY": 1, "rotation": 0, "x": -1, "y": -1}}, "center": {"type": "sprite", "speed": 1, "tween": "Elastic.easeInOut", "start": {"alpha": 0, "scaleX": 1, "scaleY": 1, "rotation": 0, "x": 0, "y": 0}, "end": {"alpha": 1, "scaleX": 1, "scaleY": 1, "rotation": 0, "x": 70, "y": 187}}, "footer": {"type": "sprite", "tween": "Elastic.easeInOut", "realname": "footer", "end": {"alpha": 1, "scaleX": 1, "scaleY": 1, "rotation": 0, "x": 195, "y": 146}, "speed": 1, "start": {"alpha": 0, "scaleX": 1, "scaleY": 1, "rotation": 0, "x": 0, "y": 0}}};
				 Main.flashVars.gameLayout = gameTuneData = {"endBgText": {"x": "-66", "y": "-23", "t": "sprite"}, "veryBad": {"x": "0", "y": "0", "t": "sprite"}, "buttonRight": {"x": "201", "y": "6", "t": "button"}, "buttonLeft": {"x": "207", "y": "5", "t": "button"}, "endBg": {"x": "0", "y": "0", "t": "sprite"}, "bg9": {"x": "0", "y": "-6", "t": "sprite"}, "timerBg": {"x": "-43", "y": "-6", "t": "sprite"}, "endTitle": {"x": "55", "y": "40", "t": "sprite"}, "buttonUp": {"x": "205", "y": "5", "t": "button"}, "r1": {"x": "0", "y": "0", "t": "sprite"}, "buttonDown": {"x": "204", "y": "2", "t": "button"}, "bgPlay": {"x": "0", "y": "0", "t": "sprite"}};
				 */
			} else {


				//if (Main.flashVars.gameLayout == "{}") { setGameLayaut(); return;}
				//if (JSON.decode(Main.flashVars.instructionLayout).butPrev.start.alpha == "0") { setInstractLayaut(); return;}
				//if (JSON.decode(Main.flashVars.mainmenuLayout).bg.start.alpha == "0") { setMainMenuLayaut(); return; }

				/*	var GL:String = '{"endBgText":{"x":"-66","y":"-23","t":"sprite"},"veryBad":{"x":"0","y":"0","t":"sprite"},"buttonRight":{"x":"201","y":"6","t":"button"},"buttonLeft":{"x":"207","y":"5","t":"button"},"endBg":{"x":"0","y":"0","t":"sprite"},"bg9":{"x":"0","y":"-6","t":"sprite"},"timerBg":{"x":"-43","y":"-6","t":"sprite"},"endTitle":{"x":"55","y":"40","t":"sprite"},"buttonUp":{"x":"205","y":"5","t":"button"},"r1":{"x":"0","y":"0","t":"sprite"},"buttonDown":{"x":"204","y":"2","t":"button"},"bgPlay":{"x":"0","y":"0","t":"sprite"}}';
				 var IL:String = '{"butPrev":{"type":"button","speed":1,"start":{"alpha":"1","scaleX":1,"scaleY":1,"rotation":0,"x":0,"y":0},"end":{"alpha":1,"scaleX":1,"scaleY":1,"rotation":0,"x":65,"y":374},"tween":"Elastic.easeInOut"},"butBack":{"type":"button","speed":1,"start":{"alpha":0,"scaleX":1,"scaleY":1,"rotation":0,"x":0,"y":0},"end":{"alpha":1,"scaleX":1,"scaleY":1,"rotation":0,"x":240,"y":375},"tween":"Elastic.easeInOut"},"bg":{"type":"sprite","speed":1,"start":{"alpha":0,"scaleX":1,"scaleY":1,"rotation":0,"x":0,"y":0},"end":{"alpha":1,"scaleX":1,"scaleY":1,"rotation":0,"x":-1,"y":1},"tween":"Elastic.easeInOut"},"butNext":{"type":"button","speed":1,"start":{"alpha":0,"scaleX":1,"scaleY":1,"rotation":0,"x":0,"y":0},"end":{"alpha":1,"scaleX":1,"scaleY":1,"rotation":0,"x":414,"y":374},"tween":"Elastic.easeInOut"},"cont":{"type":"sprite","realname":"cont","tween":"Elastic.easeInOut","end":{"alpha":1,"scaleX":1,"scaleY":1,"rotation":0,"x":-2,"y":2},"speed":1,"start":{"alpha":0,"scaleX":1,"scaleY":1,"rotation":0,"x":0,"y":0}},"count":{"count":"1","type":"counter"}}';
				 var ML:String = '{"butHelp":{"speed":1,"tween":"Elastic.easeInOut","start":{"x":0,"alpha":0,"y":0,"rotation":0,"scaleX":1,"scaleY":1},"end":{"x":51,"alpha":1,"y":400,"rotation":0,"scaleX":1,"scaleY":1},"type":"button"},"butPlay":{"speed":1,"tween":"Elastic.easeInOut","start":{"x":0,"alpha":0,"y":0,"rotation":0,"scaleX":1,"scaleY":1},"end":{"x":427,"alpha":1,"y":401,"rotation":0,"scaleX":1,"scaleY":1},"type":"button"},"title":{"start":{"x":0,"alpha":0,"y":0,"rotation":0,"scaleX":1,"scaleY":1},"end":{"x":62,"alpha":1,"y":0,"rotation":0,"scaleX":1,"scaleY":1},"type":"sprite","speed":1,"realname":"title","tween":"Elastic.easeInOut"},"bg":{"speed":1,"tween":"Elastic.easeInOut","start":{"x":0,"alpha":0,"y":0,"rotation":0,"scaleX":1,"scaleY":1},"end":{"x":-1,"alpha":1,"y":-1,"rotation":0,"scaleX":1,"scaleY":1},"type":"sprite"},"center":{"speed":1,"tween":"Elastic.easeInOut","start":{"x":0,"alpha":0,"y":0,"rotation":0,"scaleX":1,"scaleY":1},"end":{"x":70,"alpha":1,"y":187,"rotation":0,"scaleX":1,"scaleY":1},"type":"sprite"},"footer":{"speed":1,"tween":"Elastic.easeInOut","start":{"x":0,"alpha":0,"y":0,"rotation":0,"scaleX":1,"scaleY":1},"end":{"x":212,"alpha":1,"y":148,"rotation":0,"scaleX":1,"scaleY":1},"type":"sprite"}}';

				 cSCClientController.setGameLayaut(GL);
				 cSCClientController.setMainMenuLayaut(ML);
				 cSCClientController.setInstractLayaut(IL);
				 */
			}

			cSCClientController.scc_trace(Main.flashVars);

			fixPath = "tunes/"; // - префикс для запуска локально
			if (Main.flashVars.noContainerMode) {

				//fixPath = "/game/tunes/"; // - префикс для запуска с контейнера
				fixPath = "tunes/"; // - префикс для запуска с контейнера
			} else {
				onLoadedLevel();
				return
			}
			//и в результате
			//Main.flashVars.mainUrl + Main.flashVars.gameId + fixPath; - // адрес папки tunes

			tuneLoader.addEventListener(Event.COMPLETE, onLoadedLevel);
			tuneLoader.load(new URLRequest(fixPath + "tunes.dat"));

		}

		private function onLoadedLevel(e:Event = null):void {
			Cc.log("game onLoadedLevel test ");

			var data:Object = {};
			if (e) {

				Cc.log("e.target.data");

				var dataSt:String = e.target.data;
				Cc.log(e.target.data);
				data = JSON1.decode(e.target.data)
			}
			else {
				Cc.log("else");
				try {
					Cc.log("try");
					//data = Main.flashVars.gameData;
					data = JSON1.decode(Main.flashVars.gameData);
					//  DataStorage.loadData(JSON.decode(Main.flashVars.gameData));
				}
				catch (err:Error) {
					Cc.log("game Error ");
				}
				finally {
					Cc.log("game finally ");
					//data = Main.flashVars.gameData;
					// DataStorage.loadData(Main.flashVars.gameData);
				}
			}

			/*var pattern:RegExp = /(\f|\n|\r|\t)(\s+$){0,1}/;
			 var pattern2:RegExp = /(\s){2,}/;

			 trace(st);

			 while (pattern.test(dataSt)) {
			 dataSt = dataSt.replace(pattern, "");
			 }
			 while (pattern2.test(dataSt)) {
			 dataSt = dataSt.replace(pattern2, " ");
			 }*/
			Cc.log("new PenguinGame");
			Cc.watch(data), "start data";
			LevelController.instance.parceBaseData(data);
			game = new PenguinGame();
			this.addChild(game);

			//cGUI = new GUI(); //Ваша функция на Ваше усмотрение
			//addChild(cGUI); //Ваша функция на Ваше усмотрение

			if (Main.flashVars.noContainerMode) {
				start();
			}
		}
	}

}