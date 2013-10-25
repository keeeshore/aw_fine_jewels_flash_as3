package {

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.filters.*;
	import fl.transitions.*;
	import flash.net.*;
	import flash.geom.*;

	public class ContactUs extends MovieClip {
		
		public var userName:TextField;	
		public var userMail:TextField;	
		public var userNumber:TextField;	
		public var userComments:TextField;	
		public var spacing:Number = 50;
		public var contactContMc:MovieClip
		
		public var submit:MovieClip;
		
		public function ContactUs(){		
			//init();		
			trace('contact is init');
		}
		
		public function initContact (contentContMc, contentUrl) {
			
			trace('initContact' + contentContMc + "::" + contentUrl);
			
			userName = new TextField();
			userName.type = TextFieldType.INPUT;
			userName.background = true;
			//userName.text = "Type Your Name Here";
			userName.y = 10;
			
			userMail = new TextField();
			userMail.type = TextFieldType.INPUT;
			userMail.background = true;
			//userMail.text = "Type Your Mail Id here..";
			userMail.y = 60;
			
			userNumber = new TextField();
			userNumber.type = TextFieldType.INPUT;
			userNumber.background = true;
			//userNumber.backgroundColor = 0xcc0000;
			//userNumber.text = "Type Your Contact Number Here";
			userNumber.y = 110;
			
			userComments = new TextField();
			userComments.type = TextFieldType.INPUT;
			userComments.background = true;
			//userComments.text = "Type Your Comments Here";
			userComments.y = 160;
			
			submit = new submitBtn();
			submit.y = 250;
			submit.x = 200;
			
			userName.height = userMail.height = userName.height = userNumber.height =  25;
			userComments.height = 80;
			
			userName.width = userMail.width = userNumber.width = userComments.width = 250;			
			userName.x = userMail.x = userNumber.x = userComments.x = 110;			
			
			contactContMc = new contactBg();
			//contactContMc.graphics.beginFill(0x000000);
			//contactContMc.graphics.drawRect(0, 0, 350, 500);
			//contactContMc.graphics.endFill();
			contactContMc.x = 556;
			
			contactContMc.addChild(userName);
			contactContMc.addChild(userMail);
			contactContMc.addChild(userNumber);
			contactContMc.addChild(userComments);
			contactContMc.addChild(submit);
			
			contentContMc.addChildAt(contactContMc, 0);
			
			//userName.addEventListener(MouseEvent.MOUSE_DOWN, clearText);
			//userMail.addEventListener(MouseEvent.MOUSE_DOWN, clearText);
			//userNumber.addEventListener(MouseEvent.MOUSE_DOWN, clearText);
			//userComments.addEventListener(MouseEvent.MOUSE_DOWN, clearText);
			
			submit.addEventListener(MouseEvent.CLICK, validateAndSendForm);
			
			function clearText(e:MouseEvent) {
				e.target.text = "";				
			}
			

		}
		
		private function validateAndSendForm(e:MouseEvent) {
			
			this.userNumber.backgroundColor = 0xFFFFFF;
			this.userName.backgroundColor = 0xFFFFFF;
			this.userMail.backgroundColor = 0xFFFFFF;
				contactContMc.errorMsg.text = '';
				
			var formObj = {};
			formObj = { 
				comments: this.userComments,
				userName: this.userName,
				userMail: this.userMail,
				userTel:this.userNumber,
				errorMsg : contactContMc.errorMsg,
				submitBtn : contactContMc.submit
			}
			//trace('validate called = ' + validateMessage(formObj);
			trace(formObj);
			
			if(!validateMessage(formObj)){
				return false;
			}
			else {				
				sendMessage(formObj);
			}
			
			
		}
		
		private function validateMessage(formObj){
			
			var mailRegExp = new RegExp(/^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,252}$/);
			var nameRegExp = new RegExp("^[a-zA-Z\\s\'\-]+$");
			var telRegExp = new RegExp("^[0-9\-]+$");
			var errorMsg = '';
			var isValid = true;
		     
			if(formObj.userTel.text.length <= 0 || !telRegExp.test(formObj.userTel.text)){
				   formObj.errorMsg.text = 'Please enter valid Telephone Number';
				   formObj.userTel.backgroundColor = 0xcc0000;
				   isValid = false;
			}
			else if(formObj.userName.text.length <=0 ){
				formObj.errorMsg.text = 'Name is required.';
				formObj.userName.backgroundColor = 0xcc0000;
				isValid = false;
			}
			else if(formObj.userMail.text.length <=0 || !mailRegExp.test(formObj.userMail.text) ){
				formObj.errorMsg.text = 'Please enter a proper Mail Address.';
				formObj.userMail.backgroundColor = 0xcc0000;
				isValid = false;
			}
			return isValid;  
                    
                }
		
		
                private function sendMessage(formObj) {
			
				trace('sending message');
				var variables:URLVariables=new URLVariables();
				
				variables.name = formObj.userName.text;
				variables.email = formObj.userMail.text;
				variables.message = formObj.comments.text;
				variables.contact = formObj.userTel.text;
				
				var request:URLRequest=new URLRequest();
				request.url='email_new.php';
				request.method=URLRequestMethod.POST;
				request.data = variables;
				
				var loader:URLLoader=new URLLoader();
				loader.dataFormat=URLLoaderDataFormat.VARIABLES;
				//loader.addEventListener(Event.EVENT_PROGRESS, function(){formObj.errorMsg.text = 'in progress...'})
				loader.addEventListener(Event.COMPLETE,messageSent);
				try {
					loader.load(request);
				} 
				catch (error:Error){
					formObj.errorMsg.text = 'Unable to load requested document.';
				}
                                
			function messageSent(e:Event) {
			    trace(e);
			    formObj.errorMsg.text = 'Your message has been sent successfully!.';
			}
		}
                
              
		
		
		
		
	}//class ends here
	
}//package

		