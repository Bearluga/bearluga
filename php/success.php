<? ob_start(); ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
		<title>Login at Bearluga.com</title>
		<link type ="text/css" rel= "stylesheet" href= "../bearluga.css" />
		<script LANGUAGE="JavaScript" SRC="/js/timer.js">	</script>
        <script type="text/javascript" src="/js/jquery.animate-shadow.js"></script>
		<script type="text/javascript" src="/js/jquery.js"></script>
		<script type="text/javascript" src="/js/modernizr.js"></script> 
	</head>
	<body>

<?php
include("header.php");
	echo "Welcome back, ".'<span class = "red">'. $_GET['name'].'</span>'. ", redirecting you back to the main page in".' <span id= "timer" class = "red">'.'</span>'." seconds..."; ?>
	<span id = "timer" class = "red"></span>
	<script type ="text/javascript"> window.onload = CreateTimer();</script>
<?php
	header('refresh:3; url=/');
	include("../includes/footer.html");
?>
	</body>
</html>
