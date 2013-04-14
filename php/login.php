<?php
ob_start();?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
		<title>Login at Bearluga.com</title>
		<link type ="text/css" rel= "stylesheet" href= "../bearluga.css" />
        <script type="text/javascript" src="/js/jquery.animate-shadow.js"></script>
		<script type="text/javascript" src="/js/jquery.js"></script>
		<script type="text/javascript" src="/js/modernizr.js"></script> 
	</head>
	<body>
<?php
 include("header.php"); 
 // Connects to your Database 
 require("connect.php");
 //Checks if there is a login cookie

 if(isset($_COOKIE['ID_my_site']))

 //if there is, it logs you in and directes you to the main page

 { 
 	$username = $_COOKIE['ID_my_site']; 

 	$pass = $_COOKIE['Key_my_site'];

 	$check = mysql_query("SELECT * FROM users WHERE name = '$username'")or die(mysql_error());

 	while($info = mysql_fetch_array( $check )) 	
	{
 		if ($pass != $info['password']) {		}
 		else
 			{
				header("Location: success.php?name=".$username); 
 			}
	}
 }


 //if the login form is submitted 

 if (isset($_POST['submit'])) { // if form has been submitted

 // makes sure they filled it in

 	if(!$_POST['username'] | !$_POST['pass']) {

 		my_die('You did not fill in a required field.');

 	}

 	// checks it against the database



 	if (!get_magic_quotes_gpc()) {

 		$_POST['pass'] = addslashes($_POST['pass']);

 	}

 	$check = mysql_query("SELECT * FROM users WHERE name = '".$_POST['username']."'")or my_die(mysql_error());



 //Gives error if user dosen't exist

 $check2 = mysql_num_rows($check);

 if ($check2 == 0) {

 		my_die('That user does not exist in our database. <a href= registration.php>Click Here to Register</a>');

 				}

 while($info = mysql_fetch_array( $check )) 	

 {

 	$_POST['pass'] = stripslashes($_POST['pass']);

 	$info['password'] = stripslashes($info['password']);

 	$_POST['pass'] = md5($_POST['pass']);



 //gives error if the password is wrong

 	if ($_POST['pass'] != $info['password']) {

 		my_die('Incorrect password, please try again.');

 	}
  else  { 

  // if login is ok then we add a cookie 

	$_POST['username'] = stripslashes($_POST['username']); 
	$hour = time() + 3600; 
	setcookie('ID_my_site', $_POST['username'], $hour, '/'); 
	setcookie('Key_my_site', $_POST['pass'], $hour,'/');	

  //then redirect them to the members area 
	header("Location: success.php?name=".$_POST['username']); 

	//$ref = $_SERVER['HTTP_REFERER'];
	//header( 'refresh: 5; url=/'.$ref);
  } 

 } 

 } 

 else 

 {	 
 // if they are not logged in 
 ?>
 <form action="<?php echo $_SERVER['PHP_SELF']?>" method="post"> 

 <table border="0"> 

 <tr><td colspan=2><h1>Sign in</h1></td></tr> 

 <tr><td>Username:</td><td> <input type="text" name="username" maxlength="40"> </td></tr> 

 <tr><td>Password:</td><td>  <input type="password" name="pass" maxlength="50"> </td></tr> 

 <tr><td colspan="2" align="right">  <input type="submit" name="submit" value="Sign in">  </td></tr> 

 </table> 

 </form><?php 
 }
	include("../includes/footer.html"); 
	ob_flush(); 
?>	</body>
</html>
