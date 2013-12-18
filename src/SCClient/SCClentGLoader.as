package  SCClient
{
	/**
	 * ...
	 * @author ArtDon adkcenter@gmail.com
	 */

	import com.junkbyte.console.Cc;
	import flash.geom.Rectangle;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	public class SCClentGLoader extends Sprite
	{
		public static const IMAGE_LOADED:String = "imageLoaded";
		private var lLoader:Loader;
		private var urlRequest:URLRequest;
		private var _sPath:String = '';
		private var _doContent:DisplayObject;
		private var bCenterAlign:Boolean;
		private var imageW:int = 0;
		private var imageH:int = 0;
		public static var dAvasMemory:Dictionary = new Dictionary();
		private var isSWF:Boolean = false;
		
		public var setUserData:Object = { };
		
		public static var tasks:int = 0;
		
		public static var allImagesToLoadCounter:int = 0;
		
		public static function loadImages(tuneJsonUrlCore:String):void {
			
		}
		
		
		public function SCClentGLoader(sPath:String = null, bCenter:Boolean = false, imageW:int = 0, imageH:int = 0) {			
			bCenterAlign = bCenter;
			this.imageW = imageW;
			this.imageH = imageH;
			if (!sPath) return;
			updateImage(sPath);
		}
		
		public function updateImage(sPath:String = null):void {
			//sPath = sPath + "?a=" + Math.random();
			if (_sPath == sPath) return;
	
			while (numChildren > 0) {
				removeChildAt(0);
			}
			if (sPath == null) return;
			_sPath = sPath;
			
			//if (dAvasMemory[_sPath]) {
				//_doContent = (dAvasMemory[_sPath]);
				//if (_doContent) addChild(_doContent);
				//return;
			//}
			
			tasks++;
			lLoader = new Loader();
			
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.checkPolicyFile = true;
			
			urlRequest = new URLRequest(_sPath);
			trace("->", _sPath);
			lLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadedData);			
			lLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorLoaded);
			lLoader.load(urlRequest, loaderContext);
			

	
		}
		
		private function onLoadedData(event:Event):void {
			_doContent = lLoader.contentLoaderInfo.content;
			if (!_doContent){return}
			
			
			if (!isSWF){
			var bd:BitmapData = new BitmapData(_doContent.width, _doContent.height);	
			bd.draw(_doContent);
			_doContent.cacheAsBitmap = true;
			(_doContent as Bitmap).smoothing = true;
			dAvasMemory[_sPath] = _doContent;			
			_doContent.cacheAsBitmap = true;			
			if (bCenterAlign) {
				_doContent.x = -_doContent.width * 0.5;
				_doContent.y = -_doContent.height * 0.5;
			}
			}
			addChild(_doContent);
			scaleContent();
			tasks--;
			dispatchEvent(new Event(IMAGE_LOADED));
			scaleContent();
		}
		
		
		private function onErrorLoaded(event:IOErrorEvent):void {			
			
			if (path.substr( -3, 3) == "png") {
				var npath:String = path.substr(0, path.length - 3) + "jpg";
				tasks--;
			
				updateImage(npath);
				return;
			}
			if (path.substr( -3, 3) == "jpg") {
			isSWF = true;
				npath = path.substr(0, path.length - 3) + "swf";
				tasks--;
			
				updateImage(npath);			
			}
			
		}
		
		public function get path():String { return _sPath; }
		
		public function set path(value  : String) : void {
			_sPath = value; 
		}
		
		private function scaleContent():void {
			if (imageW == 0) return;
			if (!_doContent) return;
			if (_doContent.height*imageW > _doContent.width*imageH) {
				_doContent.width = imageW;	
				_doContent.scaleY = _doContent.scaleX;
			} else {
				_doContent.height = imageH;	
				_doContent.scaleX = _doContent.scaleY;
			}
			_doContent.x = imageW * 0.5 - _doContent.width * 0.5;
			_doContent.y = imageH * 0.5 - _doContent.height * 0.5;
			scrollRect = new Rectangle(0, 0, imageW, imageH);
		}
		
		public function get content():DisplayObject { return _doContent; }
		
	}

}