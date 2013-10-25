package {

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.filters.*;
	import fl.transitions.*;
	import fl.transitions.easing.Strong;
	import flash.net.*;
	import flash.geom.*;
	import flash.ui.Mouse;
	import flash.xml.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;

	public class Main extends MovieClip {

		//public var mainBgMc:MovieClip;
		public var menuMc:MovieClip;
		public var logoMc:MovieClip;
		public var footerMc:MovieClip;
		public var contentMc:MovieClip;
		public var galleryMc:MovieClip;
		public var preLoaderMc:MovieClip;
		public var contentContMc:MovieClip;
		public var contentUrl:String;
		public var introSlideCont:MovieClip;
		public var introSlideMask:MovieClip;
		public var introMc:MovieClip;
		//public var btnActive:Boolean;
		public var prevMc:MovieClip;
		
		public var myMusic:Sound;	
		public var channel:SoundChannel;
		public var curSoundPos:int;
		
		public var contentContMcFadeOut:Tween;
		public var mainBgMcTween:Tween;
		public var fadeInLoader:Tween;
		public var menuBtnFadeOut:Tween;
		public var fadeInlogoBg:Tween;
		public var fadeOutIntroTween:Tween;
		
		var secDef:Number = .5;
		var secShort:Number = .25;
		var secNormal:Number = 1;
		var secLong:Number = 2;

		public var intro:Boolean;
		public var picSlide:Boolean;	
		public var soundOn:Boolean;	
		
		public var scrollBtnPlaceHolder:Rectangle;
		public var scrollBtnX:Number = 556;
		public var scrollBtnY:Number = 0;

		public var introSlide:SlideShow;
		public var slideLoaderContMc:MovieClip;


		public function Main():void {
			//stop();
			//addEventListener(Event.ENTER_FRAME , function showingProg(e:Event) {////trace("showing:"+this.getBytesLoaded)});
			this.loaderInfo.addEventListener(ProgressEvent.PROGRESS, showProgress);
			this.loaderInfo.addEventListener(Event.COMPLETE, loadItems);
		}
		
		public function showProgress(e:Event):void {
			trace("main progressing called"+e);
		}
		
		public function loadItems(e:Event):void {
			//trace("initAll called"+e);

			//mainBgMc = new mainBg();
			//mainBgMc.y = stage.stageHeight/2;
			//mainBgMc.x = stage.stageWidth - mainBgMc.width ;
			
			
			mainBgMc.alpha = 0;
			mainBgMc.redBg.alpha = 0;
			
			footerMc = new footer();
			footerMc.alpha = 0;
			footerMc.y = stage.stageHeight - 30;

			menuMc = new menu();
			menuMc.y = stage.stageHeight/2 ;			
			menuMc.menuBtnCont.alpha = 0;
			
			introMc = new introCont();
			introMc.x = 92;
			introMc.y = 61;

			logoMc = new logo();
			logoMc.width  = 86;
			logoMc.height = 94;
			logoMc.x = menuMc.width/2 - 19;
			logoMc.y = -38;
			logoMc.logoTxt.alpha = 0;
			
			slideLoaderContMc = new MovieClip();

			stage.addChildAt(mainBgMc, 0);			
			stage.addChildAt(slideLoaderContMc, 2);
			stage.addChildAt(menuMc, 3);
			stage.addChildAt(footerMc, 4);
			stage.addChildAt(introMc, 5);
			menuMc.addChild(logoMc);			
			
			preLoaderMc = new mainLoaderStar_normal();
			preLoaderMc.x = 455;
			preLoaderMc.y = 261;
			stage.addChild(preLoaderMc);
			preLoaderMc.visible = false;
			
			menuMc.stop();
			menuMc.menuMask.stop();
			//footerMc.soundBtn.gotoAndStop(1);
			var introSkip:Boolean = false;
			
			initMusic();
						
			introMc.addEventListener(Event.ENTER_FRAME, introInitialized);	
			introMc.skipIntroBtn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
				trace("skipIntroClicked"+e);
				introSkip = true;
				introInitialized();
			});				
			
			function introInitialized(){
				if(introMc.currentFrame == introMc.totalFrames || introSkip == true){
					introMc.removeEventListener(Event.ENTER_FRAME, introInitialized);					
					fadeInlogoBg = new Tween(menuMc.logoBg, "alpha", Strong.easeOut, menuMc.logoBg.alpha , 0, secLong, true);
					introMc.stop();
					menuMc.menuMask.gotoAndPlay(2); 
					menuMc.addEventListener(Event.ENTER_FRAME, initMenuBtns);					
					fadeOutIntroTween = new Tween(introMc, "alpha", Strong.easeOut, introMc.alpha , 0, 8, true);
					fadeOutIntroTween.addEventListener(TweenEvent.MOTION_FINISH, function(e:TweenEvent){
						stage.removeChild(introMc);
						
					});					
				}
			}
			
			function initMenuBtns(e:Event):void {				
				if (menuMc.currentFrame == menuMc.totalFrames) {					
					menuMc.removeEventListener(Event.ENTER_FRAME, initMenuBtns);
					activateMenu();					
				}
			}
			
			function initMusic() {				
				//var myMusic:Sound = new Sound(new URLRequest('test1.mp3'));
				myMusic = new Sound(new URLRequest('november_sky.mp3'));
				//channel = myMusic.play();
				footerMc.soundBtn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) { 
						(soundOn)? soundOn = false : soundOn = true;
						toggleSound(e, channel, curSoundPos, soundOn);
				});
				
				function toggleSound(e:MouseEvent, channel, curSoundPos, soundOn) {
					curSoundPos = channel.position;
					if (soundOn) {
						MovieClip(e.target.parent).gotoAndStop(5);
						//var pausePosition:int = channel.position;				
						channel.stop();
					}			
					else {
						MovieClip(e.target.parent).gotoAndPlay(1);
						channel = myMusic.play(curSoundPos);
					}
				}
			}
		

		}//loadItems
		

		public function activateMenu() {

			intro = true;
			picSlide = false;

			var menuBtnTween:Tween = new Tween(menuMc.menuBtnCont, "alpha", Strong.easeOut, menuMc.menuBtnCont.alpha , 1, secLong, true);
			var logoMove:Tween = new Tween(logoMc, "y", Strong.easeOut, logoMc.y , logoMc.y - 20, 3, true);
			var logoTxtTween:Tween = new Tween(logoMc.logoTxt, "alpha", Strong.easeOut, 0, 1, secDef, true);
			var footerMcFadeIn:Tween = new Tween(footerMc, "alpha", Strong.easeOut, footerMc.alpha, 1, 1, true);
			
			//all content URL's comes here
			footerMc.privacyBtn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) { initContents(e, "privacy_policy.xml" ) } );
							
			menuMc.menuBtnCont.homeBtn.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent){ initContents(e, "home.xml" )} );
			menuMc.menuBtnCont.homeBtn.addEventListener(MouseEvent.MOUSE_OVER, btnRolledOver);
			menuMc.menuBtnCont.homeBtn.addEventListener(MouseEvent.MOUSE_OUT, btnRolledOut);
			menuMc.menuBtnCont.homeBtn.buttonMode = true;
			menuMc.menuBtnCont.homeBtn.useHandCursor = true;

			menuMc.menuBtnCont.aboutUsBtn.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent){ initContents(e, "about_us.xml" )});
			menuMc.menuBtnCont.aboutUsBtn.addEventListener(MouseEvent.MOUSE_OVER, btnRolledOver);
			menuMc.menuBtnCont.aboutUsBtn.addEventListener(MouseEvent.MOUSE_OUT, btnRolledOut);

			menuMc.menuBtnCont.jewelsBtn.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent){ initContents(e, "jewels.xml" )});
			menuMc.menuBtnCont.jewelsBtn.addEventListener(MouseEvent.MOUSE_OVER, btnRolledOver);
			menuMc.menuBtnCont.jewelsBtn.addEventListener(MouseEvent.MOUSE_OUT, btnRolledOut);

			menuMc.menuBtnCont.contactBtn.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent){ initContents(e, "contact_us.xml" )});
			menuMc.menuBtnCont.contactBtn.addEventListener(MouseEvent.MOUSE_OVER, btnRolledOver);
			menuMc.menuBtnCont.contactBtn.addEventListener(MouseEvent.MOUSE_OUT, btnRolledOut);
			
			//logoMc.addEventListener(MouseEvent.MOUSE_UP, deActivateMenu);

			//---------------------------------- ROLLOVER AND ROLLOUT FUNCTIONS --------------------------

			
			function btnRolledOver(e:MouseEvent) {
				var rollOverClr:ColorTransform = new ColorTransform();
					rollOverClr.color = 0xffc000;
					e.target.transform.colorTransform = rollOverClr;
			}
			
			function btnRolledOut(e:MouseEvent) {
				var linkClr:ColorTransform = new ColorTransform();
					linkClr.color = 0xFFFFFF;
					e.target.transform.colorTransform = linkClr;
			}
			
		}//activateMenu
		
		public function deActivateMenu(e:Event){
			if (contentContMc) {
				contentContMcFadeOut = new Tween(contentContMc, "alpha", Strong.easeOut, contentContMc.alpha , 0, secNormal, true);
				menuBtnFadeOut = new Tween(menuMc.menuBtnCont, "alpha", Strong.easeOut, menuMc.menuBtnCont.alpha , 0, secNormal, true);
				contentContMcFadeOut.addEventListener(TweenEvent.MOTION_FINISH, removeContents);
							function removeContents(){
								stage.removeChild(contentContMc);
								showIntro( stage.stageWidth/2 , stage.stageHeight/2);
							}
			}
			else {
				new Tween(menuMc.menuBtnCont, "alpha", Strong.easeOut, menuMc.menuBtnCont.alpha , 0, 2, true);
			}			
			
		}//deActivateMenu		
		
		
		public function initContents(e:Event, contentUrl):void {
			trace("currMc = "+e.target.parent.urlString);	
			trace("picSlide == " + picSlide);
			
			
			if(!picSlide){
				showIntro(608, 103);
				picSlide = true;
			}			
			
			//contentUrl = e.target.parent.urlString;	
			preLoaderMc.visible = true;
	
			if (intro) {
				mainBgMcTween = new Tween(mainBgMc, "alpha", Strong.easeOut, mainBgMc.alpha , 1, 2, true);
				var moveMenu:Tween = new Tween(menuMc, "y", Strong.easeOut, menuMc.y , 100, 2, true);
				mainBgMcTween.addEventListener(TweenEvent.MOTION_FINISH, showContents);
				intro = false;
			}
			else {					
				showContents();
			}
			
			function showContents():void{	
				
				if (contentContMc) {
					contentContMcFadeOut  = new Tween(contentContMc , "alpha" , Strong.easeOut, contentContMc.alpha , 0, 1, true);
					
					if(contentMc){					
						new Tween(contentMc.scrollBtn, "alpha", Strong.easeOut, contentMc.scrollBtn.alpha , 0 , .5, true);
						new Tween(contentMc.scrollBtn, "y", Strong.easeOut, contentMc.scrollBtn.y , contentMc.scrollBtn.y + 40 , .5, true);
					}
					
					contentContMcFadeOut.addEventListener(TweenEvent.MOTION_FINISH , function(e:Event){ 
							stage.removeChild(contentContMc);  
							setNewContents(contentUrl)}
					);	
				}
				else {
					setNewContents(contentUrl);
				}				
			}					

		}//initContents
		
		public function setNewContents(contentUrl){							
				
				contentContMc = new MovieClip();	
				var maxHeight:Number = stage.stageHeight;
					footerMc.y = maxHeight - 30;
				
				if(contentUrl == "jewels.xml"){	
					
					fadeOutIntro();					
					contentContMc.x = 95;
					contentContMc.y = maxHeight / 4;					
					//contentContMc.y = 110;	
										
					stage.addChildAt(contentContMc, 5);	
					preLoaderMc.visible = false;
					
					//____________________________________________ JEWELS CLASS
					var jewels:Jewels = new Jewels();
					jewels.initJewels(contentContMc , contentUrl);				
				}				
				else {
					
					fadeInIntro();
					
					contentContMc.x = 49;
					contentContMc.y = 181;
					scrollBtnX = 556;
					
					contentMc = new contentLoader();					
					contentContMc.addChildAt(contentMc, 0);	
					
					if (contentUrl == 'contact_us.xml') {
						
						//contentMc.contentTxtMask.width = 210;
						//contentMc.contentTxtHover.width = 210;
						//contentMc.scrollBtn.x = 200;
						//contentMc.contentTxt.width = 210;
						//scrollBtnX = 210;
						var contact:ContactUs = new ContactUs;
						contact.initContact(contentContMc , contentUrl);	
					}					
					
					
					contentMc.contentTxtMask.height = maxHeight - 250;
					contentMc.contentTxtHover.height = maxHeight - 250;
					contentMc.scrollBtn.alpha = 0;
					contentMc.contentTxtHover.alpha = 0;
					contentMc.alpha = 0;
					
					stage.addChildAt(contentContMc, 5);					
					loadXml(contentUrl);				
				}				
		}
		
		
		public function showIntro(xPos, yPos):void {			
				//logoMc.removeEventListener(MouseEvent.MOUSE_UP, deActivateMenu);
				picSlide = false;
				introSlideCont = new MovieClip();	
				introSlideMask  = new MovieClip();
					introSlideMask.graphics.beginFill(0xFFFFFF);
					introSlideMask.graphics.drawRect(xPos, yPos, 415, 490);
					introSlideMask.graphics.endFill();
					
				stage.addChildAt(introSlideCont, 2);
				stage.addChildAt(introSlideMask, 3);
				introSlideCont.mask = introSlideMask;
				
				introSlideCont.x = xPos;
				introSlideCont.y = yPos;				
				introSlide = new SlideShow();
				introSlide.initSlideShow(introSlideCont , 'intro.xml');
		}
		
		public function fadeOutIntro():void {					
					//stage.removeChild(introSlideCont);	
					//new Tween(introSlideCont, "alpha", Strong.easeOut, introSlideCont.alpha , 0, 1, true);	
					introSlideCont.visible = false;
		}
		public function fadeInIntro():void {				
					//stage.removeChild(introSlideCont);	
					//new Tween(introSlideMask, "alpha", Strong.easeOut, introSlideCont.alpha , 1, 1, true);
					introSlideCont.visible = true;
		}
		
				
		public function loadXml(contentUrl) {

			var myXML:XML = new XML();
			myXML.ignoreWhitespace = true;
			myXML.condenseWhite  = true;
			var XML_URL:String = contentUrl;
			var myXMLURL:URLRequest = new URLRequest(XML_URL);
			var myLoader:URLLoader = new URLLoader(myXMLURL);
			var contents:TextField = contentMc.contentTxt;			

			myLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			myLoader.addEventListener(ProgressEvent.PROGRESS, xmlLoading);


			function xmlLoading(event:Event):void {
				//trace("progressing");
				//preLoaderMc.x = 200;
				//preLoaderMc.y = contentContMc.y + preLoaderMc.height;
				//preLoaderMc.y = 200;
				//stage.addChild(preLoaderMc);
			}

			function xmlLoaded(event:Event):void {

				preLoaderMc.visible = false;	
				fadeInLoader = new Tween(contentMc, "alpha", Strong.easeOut, contentMc.alpha , 1, 1, true);
				/*fadeLoader.addEventListener(TweenEvent.MOTION_FINISH, function(e:TweenEvent){ contentContMc.removeChild(preLoaderMc) });*/
				
				myLoader.removeEventListener(ProgressEvent.PROGRESS, xmlLoading);

				myXML = XML(myLoader.data);
				myXML.ignoreWhitespace = true;
				contents.htmlText  = myXML.desc;

				contents.autoSize = TextFieldAutoSize.LEFT;
				
				var scrollHeight:Number = contentMc.contentTxtMask.height;
				var diffY:Number  = (contents.height - scrollHeight ) / contentMc.contentTxtMask.height;
				
				addScroller(contentMc , contents , scrollHeight, diffY );

				/*var fadeInContentMc:Tween = new Tween(contents, "alpha", Strong.easeOut, contents.alpha , 1, 1, true);
				fadeInContentMc.addEventListener(TweenEvent.MOTION_FINISH , function(){
											addScroller(contentMc , contents , scrollHeight, diffY )
				});	*/		

			}
		}
		//loadXml
		
		public function addScroller(contentMc , contents , scrollHeight , diffY ){			
							
			//var scrollHeight:Number = contentMc.contentTxtMask.height - contentMc.scrollBtn.height;
			//var scrollHeight:Number = contentMc.contentTxtMask.height;
			//var diffY:Number  = (contents.height - scrollHeight ) / contentMc.contentTxtMask.height;

			if (contents.height <= contentMc.contentTxtMask.height) {
				contentMc.scrollBtn.visible = false;
				contentMc.contentTxtHover.visible = false;
			}
			else {	
			
				var fadeInSlideBtn:Tween = new Tween(contentMc.scrollBtn, "alpha", Strong.easeOut, contentMc.scrollBtn.alpha , 1 , 1, true);
				new Tween(contentMc.scrollBtn, "y", Strong.easeOut, 40 , contentMc.scrollBtn.y , 1, true);
		
				contentMc.scrollBtn.addEventListener(MouseEvent.MOUSE_DOWN , startScroller);
				//contentMc.scrollBtn.addEventListener(MouseEvent.MOUSE_WHEEL , startScroller);
				//contentMc.scrollBtn.addEventListener(MouseEvent.MOUSE_WHEEL , startScroller);
				contentMc.scrollBtn.addEventListener(MouseEvent.MOUSE_UP , stopScroller);
				contentMc.scrollBtn.addEventListener(MouseEvent.MOUSE_OUT , stopScroller);

				contentMc.contentTxtHover.addEventListener(MouseEvent.MOUSE_WHEEL, startScroller);
				contentMc.contentTxtHover.addEventListener(MouseEvent.MOUSE_OUT, stopScroller );
			}
					
			function startScroller(e:MouseEvent) {
				trace("mouseOver :"+e.type);
				if (e.type == "mouseWheel") {
					var mDelta:Number = e.delta * 5;
					if (contentMc.scrollBtn.y >= scrollHeight) {
						if (e.delta > 0) {
							addEventListener(Event.ENTER_FRAME, scrolling);
							contentMc.scrollBtn.y = contentMc.scrollBtn.y -  mDelta;						
						}
					} 
					else if (contentMc.scrollBtn.y <=0) {
						if (e.delta < 0) {
							addEventListener(Event.ENTER_FRAME, scrolling);
							contentMc.scrollBtn.y = contentMc.scrollBtn.y - mDelta;
						}
					} 
					else {
						contentMc.scrollBtn.y = contentMc.scrollBtn.y - mDelta;
						addEventListener(Event.ENTER_FRAME, scrolling);
					}
				} 
				else {
					//trace('contentMc. = ' + contentMc.width);
					scrollBtnPlaceHolder = new Rectangle(scrollBtnX, 0 , 0, scrollHeight );
					//addEventListener(Event.ENTER_FRAME , function(e:Event):void{ scrolling (e, e.target.parent, e.target )}, false, 0, false);
					addEventListener(Event.ENTER_FRAME, scrolling);
					//e.target.startDrag();
					e.target.startDrag(false, scrollBtnPlaceHolder);
				}
			}
			
			function scrolling(e:Event) {
				var txtY:Number =  - contentMc.scrollBtn.y * diffY;
				var scrollTween:Tween = new Tween(contentMc.contentTxt, "y", Strong.easeOut, contentMc.contentTxt.y, txtY, 1, true);
			}//scrolling
			
			function stopScroller(e:MouseEvent) {
					removeEventListener(Event.ENTER_FRAME , scrolling);
					if (e.target.name == "scrollBtn") {
						////trace(e);
						e.target.stopDrag();
					}
			}
		
		}//addScroller	

		

		//---------------------------------------------------------------------------------------------------- END OF CLASS
	}
}