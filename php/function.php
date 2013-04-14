<?php
function verifyStatus(){
  /*** verify if the user has logged in
  *  this returns an array $arr, which contains boolean "loggedIn" and string "username"   
  ****/
  $username = "";
  $loggedIn = false;
  $user_level = 0;
  // Connects to Database 
  require_once("connect.php");

 //checks cookies to make sure they are logged in 
 if(isset($_COOKIE['ID_my_site'])) 
 { 
 	$username = $_COOKIE['ID_my_site']; 
 	$pass = $_COOKIE['Key_my_site']; 
 	$check = @mysql_query("SELECT * FROM users WHERE name = '$username'")or die(mysql_error()); 
 	while($info = mysql_fetch_array( $check )) 	 
	{ 
   //if the cookie has the wrong password, they are taken to the login page 
	  if ($pass != $info['password']) 
	  { 			
		  //do nothing
	  } 
	  else {
		$loggedIn = true;
		$user_level = $info['user_level'];
		break;
	  }
	}
 }
 $arr["loggedIn"] = $loggedIn;//is true iff there's a valid cookie
 $arr["username"] = $username;//is the username if logged in, "" otherwise
 $arr["user_level"] = $user_level;// 1 if the user is admin
 return $arr;
}

function my_die($msg){
  echo $msg;
  include("../includes/footer.html");
  die();
}
?>
