<?php ob_start();
?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
		<title>Login at Bearluga.com</title>
		<link type ="text/css" rel= "stylesheet" href= "../bearluga.css" />
		<script LANGUAGE="JavaScript" SRC="timer.js">	</script>
	</head>
	<body>	<?php include("header.php");
		?><h2> <span id ="timer" class = "red"> </span></h2>
		<script type ="text/javascript"> window.onload = CreateTimer();</script><?php
		include("../includes/footer.html");
	?></body>
</html><?php ob_flush();?>
