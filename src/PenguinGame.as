package {

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;

import model.LevelController;

import view.ViewController;
import view.layer.GameLayer;

[SWF(width="640", height="480", frameRate="30", backgroundColor="#CCE3FF")]
public class PenguinGame extends Sprite {

    public var gamLayer:GameLayer;
    private var viewController:ViewController;
    private var recoursePath:String = "";
    private var levelController:LevelController;

    public function PenguinGame() {
        super();
        this.addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(e:Event = null):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, init);
        //recoursePath="../../../assets/";
        recoursePath = "tunes/";
        LevelController.instance.recoursePath = recoursePath;
//        viewController = new ViewController();
//
//        this.addChild(viewController);
        //			gamLayer = new GameLayer();
        //			gamLayer.x = 0;
        //			gamLayer.y = 0;
        //			this.addChild(gamLayer);

    }

	public function start():void{
		viewController = new ViewController();
		this.addChild(viewController);
	}
    private var testMc:MovieClip;

    private function testing():void {
        //testMc = new MovieClip();


        trace(testMc.width)
        this.addChild(testMc);
        this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        testMc.addEventListener(Event.ADDED_TO_STAGE, enterFrameHandler2)
    }

    private function enterFrameHandler2(event:Event):void {
        trace("testMc.width " + testMc.width);
    }

    private function enterFrameHandler(event:Event):void {
        trace(testMc.width);
    }

	public function onPause(val:Boolean):void {
		viewController.onPause(val);
	}
}
}
