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


	public class Jewels extends MovieClip {
		
		public var contentTotal:Number;
		public var i:Number;
		public var justBelowMenu:Number = -8;
		
		public var mc:MovieClip;
		public var theUrl:String;
		
		public var jewelsMainLoader:MovieClip;
		public var jewelsSubLoader:MovieClip;
		
		//inside jewelsMainLoader
		public var contMc:MovieClip;
		public var jewelsHolder:MovieClip;
		public var jewelsMask:MovieClip;
		public var imageBgMc:MovieClip;
		public var jewels:MovieClip;
		public var nextBtnMc:MovieClip;
		public var prevBtnMc:MovieClip;
		
		public var imageMainHolder:MovieClip;
		public var imageHolderMc:MovieClip;
		public var imageDetailsHolderMc:MovieClip;
		
		//inside jewelsSubLoader
		public var jewelPicsMc:MovieClip;
		public var closeBtnMc:MovieClip;
		public var backBtnMc:MovieClip;
		public var mainCategoryLbl:MovieClip;		
				
		public var mainCategoryLoader:Loader;
		public var subCategoryLoader:Loader;
		public var imageMcLoader:Loader;
		
		public var jewelThumb_:Array;
		public var jewelTween_:Array;
		public var jewelPic_:Array;
		
		public var jewelLoadTimer:Timer;
		
		public var jewelsHolderX:Tween;
		public var contMcTweenNext:Tween;
		public var contMcTweenPrev:Tween;	
		public var jewelTypeTween_:Tween;
		public var jewelThumbTween_alpa:Tween;
		public var jewelTypeTween_alpha:Tween
		public var jewelsMainLoaderFadeOut:Tween;
		public var jewelsSubLoaderFadeOut:Tween;
		
		public function Jewels(){		
			//init();			
		}
		
		public function initJewels(mc:MovieClip , theUrl){
			
			var myXML:XML = new XML();
			var XML_URL:String = theUrl;
			var myXMLURL:URLRequest = new URLRequest(XML_URL);
			var myLoader:URLLoader = new URLLoader(myXMLURL);
			myLoader.addEventListener("complete", loadMainCategory);			
					
			
			function loadMainCategory(event:Event):void	{							
				
				myXML = XML(myLoader.data);
				contentTotal = myXML.content.length();
				
				jewelsMainLoader = new MovieClip();
				
				jewelsMask= new MovieClip();			
				jewelsMask.graphics.beginFill(0xFFFFFF);
				jewelsMask.graphics.drawRect(0, 0, 835, 450);
				jewelsMask.graphics.endFill();				
				
				contMc = new MovieClip();	
				contMc.id = "jewelMainCont";
				
				nextBtnMc = new next_btn();
				prevBtnMc = new prev_btn();				
				
				
				mc.addChild(jewelsMainLoader);
				jewelsMainLoader.addChild(jewelsMask);					
				jewelsMainLoader.addChild(contMc);
				jewelsMainLoader.addChild(nextBtnMc);
				jewelsMainLoader.addChild(prevBtnMc);												
				
				nextBtnMc.x = jewelsMask.width;
				prevBtnMc.y = nextBtnMc.y = jewelsMask.height/2;
				
				contMc.mask = jewelsMask;			
				jewelThumb_ = new Array();
				jewelTween_ = new Array();				
				
				jewelLoadTimer = new Timer(1000, 1);
				jewelLoadTimer.start();	
				//jewelLoadTimer.addEventListener(TimerEvent.TIMER, onTick);
				jewelLoadTimer.addEventListener(TimerEvent.TIMER_COMPLETE, showMainCategoryThumbs );
			
				for(i = 0; i < contentTotal; i++){
				
						//trace("jewel "+i);							
						jewels = new jewelsMc();						
						jewelThumb_[i] = jewels;					
						
						jewelThumb_[i].jewelType.text = myXML.content[i].@type;			
						jewelThumb_[i].id = i;
						jewelsHolder = new MovieClip();	
						//trace(myXML.content[i].image.length());		

						jewelsHolder.addChild(jewelThumb_[i]);				
						contMc.addChild(jewelsHolder);
						
						jewelTween_[i] = new Tween(jewelThumb_[i], "x", Strong.easeOut, 0,  i * 202, i, true);				
						
				}				

				function showMainCategoryThumbs(e:TimerEvent):void {
					//trace("loadMainCategoryThumbs started");
					jewelLoadTimer.stop();
					initArrowBtns(contMc, jewelsMask);
					
						for(i = 0; i < contentTotal; i++){
							
							mainCategoryLoader = new Loader();					
							
							var jewelThumbURL:String =  myXML.content[i].@thumbnail;
							var jewelThumbReq:URLRequest = new URLRequest(jewelThumbURL);
							mainCategoryLoader.load(jewelThumbReq);
							mainCategoryLoader.y = 55;					
							
							configureListeners(mainCategoryLoader.contentLoaderInfo , jewelThumb_[i]);							
							
							mainCategoryLoader.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) { 
											trace(e.target.parent.id);																					
											loadSubCategory(e, e.target.parent.id , myXML.content[e.target.parent.id]);
							});	
							
							mainCategoryLoader.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent) {thumbRolledOver(e, jewelThumb_[e.target.parent.id])});
							mainCategoryLoader.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent) {thumbRolledOut(e, jewelThumb_[e.target.parent.id])});
							
							jewelThumb_[i].addChild(mainCategoryLoader);							
						}
				}				
				
			}
			
			function loadSubCategory(e, contentId , catContents):void {
			
				//trace("jewelThumb_ : "+jewelThumb_[contentId].parent.parent.name);
				jewelsSubLoader = new MovieClip();
				jewelsSubLoader.x= 0;
				jewelsSubLoader.y = 0;
				jewelPicsMc = new MovieClip();
				jewelsMask= new MovieClip();
							
				
					jewelsMask.graphics.beginFill(0xFFFFFF);
					jewelsMask.graphics.drawRect(0, 0, 835, 450);
					jewelsMask.graphics.endFill();
				
				jewelPicsMc.mask = jewelsMask;			
				
				mc.addChild(jewelsSubLoader);			
				
				jewelsSubLoader.addChild(jewelPicsMc);
				jewelsSubLoader.addChild(jewelsMask);				
				
					
				jewelsMainLoaderFadeOut = new Tween(jewelsMainLoader, "alpha", Strong.easeOut, jewelsMainLoader.alpha , 0, 1, true);
								
				jewelsMainLoaderFadeOut.addEventListener(TweenEvent.MOTION_FINISH , function(e:TweenEvent){ showSubCategoryThumbs(catContents) });
				
				
				function showSubCategoryThumbs(catContents):void{	
					
					mc.removeChild(jewelsMainLoader);
					
					trace("showSubCategory = "+catContents.image.length());
					trace("showSubCategory.contentId = "+contentId+ " ; MC :"+jewelPicsMc.parent);
					//MovieClip(jewelThumb_[contentId].parent.parent.parent).alpha = 0;
					jewelPic_ = new Array();
					jewelTween_ = new Array();
					nextBtnMc = new next_btn();
					prevBtnMc = new prev_btn();		
					backBtnMc = new back_btn();										
					
					backBtnMc.x = 0;					backBtnMc.y = justBelowMenu;
					backBtnMc.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) { closeSubCategory(e, contentId , catContents.image.length())});
					
					mainCategoryLbl = new category_txt();					
					mainCategoryLbl.catLbl.text += catContents.@type;
					mainCategoryLbl.catLbl.autoSize = TextFieldAutoSize.LEFT;
					mainCategoryLbl.x  = jewelsMask.width - mainCategoryLbl.catLbl.width;	
					mainCategoryLbl.y = justBelowMenu;
					trace(catContents.@type);
					
					jewelsSubLoader.addChild(backBtnMc);
					jewelsSubLoader.addChild(mainCategoryLbl);
					jewelsSubLoader.addChild(nextBtnMc);
					jewelsSubLoader.addChild(prevBtnMc);
					
					trace("3");
					nextBtnMc.x = jewelsMask.width;
					prevBtnMc.y = nextBtnMc.y = jewelsMask.height/2;

					
					for(var i:Number = 0; i <catContents.image.length(); i++){						
						
						jewels = new jewelsMc();						
						jewelPic_[i] = jewels;
						jewelPic_[i].id = i;
						//trace(jewelPic_[i]);
						jewelPic_[i].jewelType.text = catContents.image[i].@name;					
						jewelsHolder = new MovieClip();	
						jewelsHolder.addChild(jewelPic_[i]);				
						jewelPicsMc.addChild(jewelsHolder);						
						
						subCategoryLoader = new Loader();					
							
						var subCategoryThumbURL:String =  catContents.image[i].@url;
						var subCategoryThumbReq:URLRequest = new URLRequest(subCategoryThumbURL);
						subCategoryLoader.load(subCategoryThumbReq);
						subCategoryLoader.y = 70;					
							
						configureListeners(subCategoryLoader.contentLoaderInfo , jewelPic_[i]);
											
						jewelPic_[i].addChild(subCategoryLoader);	
						
						jewelTween_[i] = new Tween(jewelPic_[i], "x", Strong.easeOut, 0,  i * 202, i, true);
						
						if( i == catContents.image.length() - 1){
							jewelTween_[i].addEventListener(TweenEvent.MOTION_FINISH , initBtns);
						}
					
						subCategoryLoader.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {										
										//e.target.parent.parent.parent.alpha = 0;
										jewelThumbTween_alpa = new Tween(jewelsSubLoader, "alpha", Strong.easeOut, jewelsSubLoader.alpha,  0, 1, true);
										jewelThumbTween_alpa.addEventListener(TweenEvent.MOTION_FINISH , function(){
											initImageHolder(e, e.target.parent.id , catContents);
										});
										
						});
						subCategoryLoader.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent) {thumbRolledOver(e, jewelPic_[e.target.parent.id])});
						subCategoryLoader.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent) {thumbRolledOut(e, jewelPic_[e.target.parent.id])});
							
					}
					function initBtns(e:TweenEvent){
						initArrowBtns(jewelPicsMc, jewelsMask);						
					}
					
				}				
			}
			
			function closeSubCategory(e:MouseEvent , catIndexId , total):void {
					//trace("closeSubCategory total : "+total+"; catIndexId : "+catIndexId+"; mc ="+jewelPic_[catIndexId].parent.parent);
					
					if(catIndexId != total){
						jewelsHolderX = new Tween(jewelPic_[catIndexId].parent.parent, "x", Strong.easeOut, jewelPic_[catIndexId].parent.parent.x ,  0, .5, true);
					}		
					
					jewelTween_ = new Array();
					for (var i=0; i< total; i++){
						jewelTween_[i] = new Tween(jewelPic_[i], "x", Strong.easeOut, jewelPic_[i].x ,  i * -202, total, true);
					}
					jewelsSubLoaderFadeOut = new Tween(jewelsSubLoader, "alpha", Strong.easeOut, jewelsSubLoader.alpha,  0, 1, true);
					
					jewelsSubLoaderFadeOut.addEventListener(TweenEvent.MOTION_FINISH, function(e:TweenEvent){ 
						mc.removeChild(jewelsSubLoader);
						loadMainCategory(e);
					});										
			}		
			
			
		}
		
		
		private function initImageHolder(e:MouseEvent, imgIndexId, catContents):void {
				
				trace("loadImage = "+imgIndexId+"; imageDetails = "+catContents.image[imgIndexId].@url);
				trace("loadImage = "+e.target.parent.parent.parent.parent.parent);
				
				
				jewelsSubLoader = e.target.parent.parent.parent.parent;				
				//new Tween(jewelsSubLoader, "alpha", Strong.easeOut, jewelsSubLoader.alpha,  0, 1, true);
				
				var imgUrl:String;
				var imgUrlReq:URLRequest;
				
				imageMainHolder = new MovieClip;
				
				imageHolderMc = new imageHolder();
				imageDetailsHolderMc = new imageDetailsHolder();			
				
				imageMainHolder.addChild(imageHolderMc);	
				imageMainHolder.addChild(imageDetailsHolderMc);
							
				//imageDetailsHolderMc.x = 574;				
				var loaderMc:MovieClip = MovieClip(e.target.parent.parent.parent.parent.parent);				
				loaderMc.addChild(imageMainHolder);
				
				imageDetailsHolderMc.closeBtn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent){ 
						closeImageMainHolder(e, loaderMc);
				});				
				
				loadImage(imgIndexId);
				
				function loadImage(i) {
					
					imageMcLoader = new Loader();
					imgUrl =  catContents.image[i].@url;
					imgUrlReq = new URLRequest(imgUrl);
					imageMcLoader.load(imgUrlReq);					
					imageMcLoader.x = 574 / 2 ;
					imageMcLoader.y = 25;	
					
					imageBgMc = new MovieClip;
					imageBgMc.graphics.beginFill(0xFFFFFF);
					imageBgMc.graphics.drawRect(0, 0, imageMcLoader.scaleX, imageMcLoader.scaleY);
					imageBgMc.graphics.endFill();
					
					imageHolderMc.addChild(imageBgMc);
					
					imageDetailsHolderMc.imgNameTxt.text = catContents.image[i].@url;
					imageDetailsHolderMc.imgDescTxt.text = catContents.image[i].@name;
					imageDetailsHolderMc.imgCatTxt.text = catContents.image[i].@thumnail;
					
					imageHolderMc.addChild(imageMcLoader);
					//imageMcLoader.scaleX = .5;
					//imageMcLoader.scaleY = .5;
					new Tween(imageBgMc, "scaleX", Strong.easeOut, .5,  1, 1, true);	
					new Tween(imageBgMc, "scaleY", Strong.easeOut, .5,  1, 1, true);	

					
				}
				
				function closeImageMainHolder(e:MouseEvent, targetMc):void {
					//trace('closing closeImageMainHolder'+targetMc+" : "+imgIndexId);
					loaderMc.removeChild(imageMainHolder);
					new Tween(jewelsSubLoader, "alpha", Strong.easeOut, jewelsSubLoader.alpha,  1, 1, true);				
				}	
				
									
				
		}
		
		
		private function configureListeners(dispatcher:IEventDispatcher ,  theMc):void {						
						dispatcher.addEventListener(ProgressEvent.PROGRESS, function(e:ProgressEvent){ progressHandler(e, theMc)});
						dispatcher.addEventListener(Event.COMPLETE, function(e:Event) {completeHandler(e, theMc)}); 						 
		}
		
		private function thumbRolledOver(e:MouseEvent, thumbMc){
				//trace('rolledOver : '+e+'; i : '+i);
				//jewelThumb_[i].jewelsMc_bg.visible = false;
				new Tween(thumbMc.jewelsMc_bg , "x", Strong.easeOut, thumbMc.jewelsMc_bg.x ,  -65, 1,  true);
				jewelTypeTween_alpha = new Tween(thumbMc.jewelsMc_bg , "alpha", Strong.easeOut, thumbMc.jewelsMc_bg.alpha ,  1, 1,  true);
		}
		
		private function thumbRolledOut(e:MouseEvent, thumbMc){
				//trace('rolledOut : '+e+'; i : '+i);
				jewelTypeTween_alpha = new Tween(thumbMc.jewelsMc_bg , "alpha", Strong.easeOut, thumbMc.jewelsMc_bg.alpha ,  .5, 1,  true);
				new Tween(thumbMc.jewelsMc_bg , "x", Strong.easeOut, thumbMc.jewelsMc_bg.x ,  35, 1, true);					
		}		
		
		private function progressHandler(event:ProgressEvent, i):void {
			//trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal+" , i ="+i);				
		}
		 
		private function completeHandler(event:Event,  theMc):void {
			trace("completeHandler: " + event.target+" , i ="+i+"; theMc"+theMc);
			theMc.thumbLoader.visible = false;			
		}		

		
		private function initArrowBtns(contMc, jewelsMask):void {
			trace("initArrowBtns"+contMc.width+": mask_width = "+jewelsMask.width);	
			
			if(contMc.width > jewelsMask.width){
				trace("is not visible");
				nextBtnMc.addEventListener(MouseEvent.CLICK , function(e:MouseEvent) {showNextType(e, contentTotal)});
				prevBtnMc.addEventListener(MouseEvent.CLICK , function(e:MouseEvent) {showPrevType(e, contentTotal)});
			}			
			else {
				trace("is not visible");
				nextBtnMc.visible = false;
				prevBtnMc.visible = false;
			}
			
			function showNextType(e:MouseEvent, typeTotal):void{				
				var limitX = contMc.width - jewelsMask.width;
				//trace("limitX ="+limitX+" currentX = "+contMc.x);	
				if(contMc.x >= - limitX ){
					var contMcTweenNext:Tween = new Tween(contMc, "x", Strong.easeOut, contMc.x,  contMc.x - 202, 2, true);
				}
					
			}			
			function showPrevType(e:MouseEvent, typeTotal):void{
				var limitX = contMc.width - jewelsMask.width;
					//trace("showPrev");	
					if(contMc.x <= 0 ){
						var contMcTweenPrev:Tween = new Tween(contMc, "x", Strong.easeOut, contMc.x,  contMc.x + 202, 2, true);	
					
					}
					
			}
		}
		
		
		
	}//class ends here
	
}//package

		