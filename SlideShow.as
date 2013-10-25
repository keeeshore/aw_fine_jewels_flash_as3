package {
	import Main;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.filters.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.net.*;
	import flash.geom.*;
	import flash.xml.*;
	import flash.utils.Timer;


	public class SlideShow extends MovieClip {

		public var imageHolder:MovieClip;
		public var i:Number = 0;
		public var imageContMc:Loader;
		public var preLoaderMc:MovieClip;
		public var dontSetInterval:Boolean = true;
		public var minuteTimer:Timer;
		
		public var newImageContMcBlur:Tween;
		public var newImageContMcFade:Tween;
		public var myBlur:BlurFilter;

		public function SlideShow() {
			//trace('slideShow');
		}
		
		public function initSlideShow(mc:MovieClip , url:String) {
			//trace("mc= "+mc+", url = "+url);
		
			var myXML:XML = new XML();
			var XML_URL:String = url;
			var myXMLURL:URLRequest = new URLRequest(XML_URL);
			var slideLoader:URLLoader = new URLLoader(myXMLURL);
			var contents:Array = new Array;
			var imageMc:Array = new Array;
			imageHolder = new MovieClip();
			//imageHolder.width = 400;

			//xmlData = new XML(event.target.data);        
			//var length:int = elements.length();

			slideLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			slideLoader.addEventListener(ProgressEvent.PROGRESS, xmlLoading);

			function xmlLoaded(e:Event) {
				
				slideLoader.removeEventListener(ProgressEvent.PROGRESS, xmlLoading);
				
						myXML = XML(slideLoader.data);
				
						mc.addChild(imageHolder);				
						var imgTotal:Number = myXML.image.length();
						
						//---- load first image without any timer set.
						imageContMc = new Loader();
						configureListeners(imageContMc.contentLoaderInfo);
						
						preLoaderMc = new mainLoaderStar_normal();
						
						var pictURL:String =  myXML.image[i].@url;
						var pictURLReq:URLRequest = new URLRequest(pictURL);
						imageContMc.load(pictURLReq);
						//imageContMc.alpha = 0;					
						imageHolder.addChild(imageContMc);	
						
						//---- end of loading first image		
						
						minuteTimer = new Timer(1000, 5);
						minuteTimer.start();	
						//minuteTimer.addEventListener(TimerEvent.TIMER, onTick);
						minuteTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function(){loadNextOne(imgTotal)} );			

			}			
			
			function loadNextOne(imgTotal){
					minuteTimer.stop();
					minuteTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, loadNextOne );
					if(i < imgTotal -1){
						//trace("current i :"+i);
						i++;
						//trace("loading i:"+i);
						nextImg(i , imgTotal , myXML.image[i].@url);
						minuteTimer = new Timer(1000, 8);
						minuteTimer.start();	
						minuteTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function(){ loadNextOne(imgTotal)} );
					}
					else {
						i = 0;
						nextImg(i , imgTotal , myXML.image[i].@url);
						minuteTimer = new Timer(1000, 8);
						minuteTimer.start();	
						minuteTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function(){ loadNextOne(imgTotal)} );
					}					
			}//loadNextOne
			
			function xmlLoading(e:Event) {
				//trace("gallery xml loading");
			}
			
			function nextImg( i , imgTotal , theImg) {	
				trace("Time's Up! & current i is "+i+" and total : "+imgTotal);				
				if (imageContMc) {
					imageHolder.removeChild(imageContMc);					
				}		
								
				preLoaderMc = new mainLoaderStar_normal();
				imageContMc = new Loader();
				var pictURL:String = theImg;
				var pictURLReq:URLRequest = new URLRequest(pictURL);
				imageContMc.load(pictURLReq);
				configureListeners(imageContMc.contentLoaderInfo);
				//imageContMc.alpha = 0;					
				imageHolder.addChild(imageContMc);				
						
			}			

		}//initSlideShow
		
		 private function configureListeners(dispatcher:IEventDispatcher):void {
			 	dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			 	dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            	
        }
		
		private function progressHandler(event:ProgressEvent):void {
           	//trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);			
			imageHolder.addChild(preLoaderMc);
			preLoaderMc.x = 190;
			preLoaderMc.y = 230;
        }
		 
		 private function completeHandler(event:Event):void {
           //trace("completeHandler: " + event.target);
			imageHolder.removeChild(preLoaderMc);		
			myBlur = new BlurFilter(10 , 8 , 3);
			imageContMc.filters = [myBlur];
			
			var imgBlurQltyTween:Tween  = new Tween(myBlur, "quality", Strong.easeOut, myBlur.quality, 1, 1, true);
			var imgBlurTween:Tween = new Tween(myBlur, "blurY", Strong.easeOut, myBlur.blurY, 0, 1, true);
					
			newImageContMcBlur = new Tween(myBlur, "blurX", Strong.easeOut, myBlur.blurX, 0, 1, true);		
			newImageContMcFade = new Tween(imageContMc, "alpha", Strong.easeOut, 0, 1, 2, true);
			newImageContMcBlur.addEventListener(TweenEvent.MOTION_CHANGE, function(){ imageContMc.filters = [myBlur] });
			
			/*function removeBlur(e:TweenEvent){
				myBlur.blurY = myBlur.blurX;
				imageContMc.filters = [myBlur];
			}*/		
			
        }
		
		function removeSlideShow(e:Event):void {
			////trace("ok in slideShow class");
		}
		// __________________________________________________________________________________________ END OF CLASS
	}
}

