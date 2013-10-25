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
		public var imgHolderMc:MovieClip;
				
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
		public var imgHolderMcTween:Tween;
		
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
											//trace(e.target.parent.id);																					
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
					
					//trace("showSubCategory = "+catContents.image.length());
					//trace("showSubCategory.contentId = "+contentId+ " ; MC :"+jewelPicsMc.parent);
					//MovieClip(jewelThumb_[contentId].parent.parent.parent).alpha = 0;
					jewelPic_ = new Array();
					jewelTween_ = new Array();
					nextBtnMc = new next_btn();
					prevBtnMc = new prev_btn();		
					backBtnMc = new back_btn();										
					
					backBtnMc.x = 0;
					backBtnMc.y = justBelowMenu;
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
						var jewelsSubHolder:MovieClip = new MovieClip();
						
						var jewelsSubMask:MovieClip =  new MovieClip();
							jewelsSubMask.graphics.beginFill(0xFFFFFF);
							jewelsSubMask.graphics.drawRect(0 , 0, 202, 350);
							jewelsSubMask.graphics.endFill();
							
						
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
										initImageHolder(e, e.target.parent.id , catContents);									
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
					jewelsSubLoaderFadeOut = new Tween(jewelsSubLoader, "alpha", Strong.easeOut, jewelsSubLoader.alpha,  1, 1, true);
					
					jewelsSubLoaderFadeOut.addEventListener(TweenEvent.MOTION_FINISH, function(e:TweenEvent){ 
						mc.removeChild(jewelsSubLoader);
						loadMainCategory(e);
					});										
			}		
			
			
		}
		
		
		private function initImageHolder(e:MouseEvent, imgIndexId, catContents):void {
				
				//trace("loadImage = "+imgIndexId+"; imageDetails = "+catContents.image[imgIndexId].@url);
				//trace("loadImage = "+e.target.parent.parent.parent.parent.parent.parent);
				
				var nextImgBtnMc:MovieClip = new next_btn();
				var prevImgBtnMc:MovieClip = new prev_btn();	
	
				var stageMc:Stage = e.target.parent.parent.parent.parent.parent.parent;
				var imgMainBgMc:MovieClip = new MovieClip;
					imgMainBgMc.graphics.beginFill(0x000000);
					imgMainBgMc.graphics.drawRect(0, 0, stageMc.stage.width, stageMc.stage.height);
					imgMainBgMc.graphics.endFill();
					imgMainBgMc.alpha = .85
					//imgMainBgMc.addEventListener(MouseEvent.CLICK, closeImageHolder);
				
				stageMc.addChild(imgMainBgMc);	
				stageMc.addChild(nextImgBtnMc);	
				stageMc.addChild(prevImgBtnMc);	
				//nextImgBtnMc.visible = prevImgBtnMc.visible = false;
				nextImgBtnMc.y = prevImgBtnMc.y = 600/2;
				nextImgBtnMc.x = prevImgBtnMc.x = 1024/2;
				
				loadImage(imgIndexId);
				
				function loadImage(i) {									
					
					imgMainBgMc.removeEventListener(MouseEvent.CLICK, closeImageHolder);
					
					var imgUrl:String;
					var imgUrlReq:URLRequest;
					var imgDesc:String;
					imgDesc = catContents.image[i].@name;
					
					imageMcLoader = new Loader();
					imgUrl =  catContents.image[i].@url;
					imgUrlReq = new URLRequest(imgUrl);
					configureImgListeners(imageMcLoader.contentLoaderInfo);
					imageMcLoader.load(imgUrlReq);
					
					function configureImgListeners(dispatcher:IEventDispatcher):void {						
						//dispatcher.addEventListener(ProgressEvent.PROGRESS, function(e:ProgressEvent){ progressHandler(e, theMc)});
						dispatcher.addEventListener(Event.COMPLETE, function(e:Event) {							
							var imgWidth = e.target.width;
							var imgHeight = e.target.height;							
							//trace("ImgListeners:complete"+imgWidth+":"+imgHeight);
							imgHolderMc = new imageBg();							
							stageMc.addChild(imgHolderMc);
							
							imgHolderMc.x = 1024/2;
							imgHolderMc.y = 600/2;
							
							var imgHolderMcTweenW:Tween = new Tween(imgHolderMc.imgBorderMc, 'width' , Strong.easeOut, 50 , imgWidth+10, 1, true);
							imgHolderMcTween = new Tween(imgHolderMc.imgBorderMc, 'height', Strong.easeOut, 50, imgHeight+10, 1, true);
							imgHolderMcTween.addEventListener(TweenEvent.MOTION_FINISH, function(){
								
									imgHolderMc.imgLoader.addChild(imageMcLoader);
									imgHolderMc.imgLoader.indexId = i;
									imgHolderMc.imgLoader.width = imgWidth;
									imgHolderMc.imgLoader.height = imgHeight;
									imgHolderMc.imgLoader.x = -(imgWidth/2);
									imgHolderMc.imgLoader.y = -(imgHeight/2);
									imgHolderMc.imgLoader.addEventListener(MouseEvent.MOUSE_OVER, showImgDesc);									
									
									var newNextX:Number = 1024/2 + (imgWidth/2 + 20);
									var newPrevX:Number = 1024/2 - (imgWidth/2 + 50);
									
									var imgBtnTween:Tween = new Tween(nextImgBtnMc, 'x', Strong.easeOut, nextImgBtnMc.x, newNextX, 1, true);
										imgBtnTween = new Tween(prevImgBtnMc, 'x', Strong.easeOut, prevImgBtnMc.x, newPrevX, 1, true);									
																				
										imgMainBgMc.addEventListener(MouseEvent.CLICK, closeImageHolder);
							});
							
						});					
					}
					
					function showImgDesc(e:MouseEvent):void {
						trace("showImgDesc"+imgDesc+"indexId = "+e.target);
					}

				}
				
				nextImgBtnMc.addEventListener(MouseEvent.CLICK, function(e:MouseEvent){
						trace("nextImgClicked:currId ="+imgIndexId+"totalLength = "+catContents.image.length());
						nextImgBtnMc.visible = prevImgBtnMc.visible = true;
						if(imgIndexId < (catContents.image.length()-1)){							
							stageMc.removeChild(imgHolderMc);
							imgIndexId = imgIndexId+1;
							trace("nextBtn_id = "+imgIndexId);
							loadImage(imgIndexId);
						}						
				});

				prevImgBtnMc.addEventListener(MouseEvent.CLICK, function(e:MouseEvent){
						trace("prevImgClicked:currId ="+imgIndexId+"totalLength = "+catContents.image.length());
						nextImgBtnMc.visible = prevImgBtnMc.visible = true;
						if(imgIndexId > 0 ){							
							stageMc.removeChild(imgHolderMc);
							imgIndexId = imgIndexId-1;
							trace("prevBtn_id = "+imgIndexId);
							loadImage(imgIndexId);
						}						
				});
				
				function closeImageHolder(e:MouseEvent):void {
					trace('closing closeImageMainHolder'+e);
					stageMc.removeChild(imgMainBgMc);
					stageMc.removeChild(imgHolderMc);	
					stageMc.removeChild(nextImgBtnMc);
					stageMc.removeChild(prevImgBtnMc);						
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

		