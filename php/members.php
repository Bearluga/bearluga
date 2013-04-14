<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
		<title>Welcome back</title>
		<link type ="text/css" rel= "stylesheet" href= "../bearluga.css" />
        <script type="text/javascript" src="/js/jquery.animate-shadow.js"></script>
		<script type="text/javascript" src="/js/jquery.js"></script>
		<script type="text/javascript" src="/js/modernizr.js"></script> 
	</head>
	<body>
<?php 
	include("header.php"); 
	$arr = verifyStatus();	
	if($arr["loggedIn"]){echo "Welcome back, ". '<span class = "red">'.$arr['username'].'</span>'."!";}
	else {
		echo "Please login first";
?>
		<p><a href="login.php">login</a> or <a href="registration.php">register</a></p>
<?php
	}
	include("../includes/footer.html");
?>
	</body>
</html>

