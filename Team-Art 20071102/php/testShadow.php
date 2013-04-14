<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>box-shadow</title>
<style>
body{
	background-color:green;	
}

#main{
	background-image:url(../images/page-bg-testShadow.jpg);
	width:1024px;
	background-repeat:repeat-y;
}

#box1, #box2{
	background-color:white;	
}

</style>
</head>

<body>
<div id="main">
<div id="box1" style="filter: progid:DXImageTransform.Microsoft.Shadow(color='#969696', Direction=145, Strength=3);  width: 250px; height: 90px;  -webkit-box-shadow: 2px 2px 3px #969696; -moz-box-shadow: 2px 2px 3px #969696;box-shadow: 2px 2px 3px #969696;"></div>

<div id="box2" style=" width:500px;filter: progid:DXImageTransform.Microsoft.Shadow(color='#969696', Direction=135, Strength=5); background-color: white; height:200px; margin:0 auto; -moz-box-shadow:2px 2px 5px #969696; -webkit-box-shadow:2px 2px 5px #969696; box-shadow:2px 2px 5px #969696;"></div>
</div>
</body>
</html>
