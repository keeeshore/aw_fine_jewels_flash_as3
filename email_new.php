<?php 
$to = "keeeshore@gmail.com"; 
$subject = ($_POST['name']); 
$message = ($_POST['message']); 
$contact = ($_POST['contact']); 
$message .= "\n\n---------------------------\n"; 
$message .= "Contact Us Form from AWFINEJEWELS.COM " . $_POST['name'] . " <" . $_POST['email']  . ">\n"; 
$headers = "From: " . $_POST['name'] . " <" . $_POST['email'] . ">\n"; 
if(@mail($to, $subject, $message, $headers)) 
{ 
    echo "answer=ok"; 
}  
else  
{ 
    echo "answer=error"; 
} 
?>