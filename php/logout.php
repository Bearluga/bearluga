<?php ob_start();?>
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
	<body><?php
 include("header.php"); 
 if(isset($_COOKIE['ID_my_site']))
 //if there is, delete it
 { 
	$username = $_COOKIE['ID_my_site']; 
	$pass = $_COOKIE['Key_my_site'];
 // if login is ok then we delete a cookie 

	//$_POST['username'] = stripslashes($_POST['username']); 
	$hour = time() - 3600*25; 
	setcookie('ID_my_site', $username, $hour,'/'); 
	setcookie('Key_my_site', $pass, $hour,'/');
	 
	echo '<span class= "red">'.$username.'</span>'.", you have successfully logged-out, please come back!"; 
 }
	else{
		include("header.php"); 
		echo "did not find any cookies";
		// header("Location: members.php"); 
		//$ref = $_SERVER['HTTP_REFERER'];
		//header( 'refresh: 5; url='.$ref);
	}
	include("../includes/footer.html"); 
	ob_flush();
 ?></body>
</html>

