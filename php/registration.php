<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
		<title>Registration at Bearluga.com</title>
		<link type ="text/css" rel= "stylesheet" href= "../bearluga.css" />
        <script type="text/javascript" src="/js/jquery.animate-shadow.js"></script>
		<script type="text/javascript" src="/js/jquery.js"></script>
		<script type="text/javascript" src="/js/modernizr.js"></script> 
	</head>
	<body>
<?php 
	include("header.php"); 
	//error_reporting (E_ALL ^ E_NOTICE);
	require_once('connect.php');

 //This code runs if the form has been submitted

	if (isset($_POST['submit'])) { 
 //This makes sure they did not leave any fields blank
		if (!$_POST['username'] | !$_POST['pass'] | !$_POST['pass2'] ) {
 		my_die('You did not complete all of the required fields');
 	}

 // checks if the username is in use

 	if (!get_magic_quotes_gpc()) {
 		$_POST['username'] = addslashes($_POST['username']);
 	}

 $usercheck = $_POST['username'];

 $check = mysql_query("SELECT name FROM users WHERE name = '$usercheck'") 

or my_die(mysql_error());

 $check2 = mysql_num_rows($check);


 //if the name exists it gives an error

 if ($check2 != 0) {
 		my_die('Sorry, the username '.$_POST['username'].' is already in use.');
 }
 //this makes sure both passwords entered match

 	if ($_POST['pass'] != $_POST['pass2']) {

 		my_die('Your passwords did not match. ');

 	}

 	// here we encrypt the password and add slashes if needed

 	$_POST['pass'] = md5($_POST['pass']);

 	if (!get_magic_quotes_gpc()) {
 		$_POST['pass'] = addslashes($_POST['pass']);
 		$_POST['username'] = addslashes($_POST['username']);
	}
 // now we insert it into the database
 	$insert = "INSERT INTO users (name, password, user_level)
 			VALUES ('".$_POST['username']."', '".$_POST['pass']."','0')";
 	$add_member = mysql_query($insert);
 echo '<h1>Registered</h1><p>Thank you, '.$_POST['username']. ', you have registered - you may now <a href = "login.php">login</a></p>';

?>
  <?php 
 } 

 else 
 {	
 ?>
 		<form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="post">
			<table border="0">
			<tr><td colspan=2><h1>Register</h1></td></tr> 
			<tr><td>Username:</td><td><input type="text" name="username" maxlength="60"></td></tr>
			<tr><td>Password:</td><td><input type="password" name="pass" maxlength="10"></td></tr>
			<tr><td>Confirm Password:</td><td><input type="password" name="pass2" maxlength="10"></td></tr>
			<tr><th colspan=2 align=right><input type="submit" name="submit" value="Register"></th></tr> </table>
		</form>
 <?php
 }
	include("../includes/footer.html");
 ?> 

	</body>
</html>
