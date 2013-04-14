<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<!-- This is the stylesheet that makes the footer stick. -->
	<link href="Style/stickyFooter.css" media="all" rel="stylesheet" type="text/css" />
    <link href="css/nav.css" media="all" rel="stylesheet" type="text/css">
    <link href="css/Team-Art.css" rel="stylesheet" type="text/css">
    
<script type="text/javascript" src="js/jquery.animate-shadow.js"></script>
<script type="text/javascript" src="js/jquery.js"></script>
<script type="text/javascript" src="js/modernizr.js"></script> 
<script type="text/javascript">
function changeTitle(x){
	var y;
	switch(x){
	case 1:
  y = "人力资源咨询";
  break;
case 2:
  y = "培训";
  break;

default:
    y = "评估";
	}
	document.getElementById("currentLoc").innerHTML = y;
}
</script>

<title>天慕众和业务范畴</title>
<meta name="Microsoft Border" content="tb">
</head>

<body onload = "displayLoc()">
<div id="wrap">  <!-- This wrap div needs to encompass everything except the footer div at bottom -->

<?php include("php/header.php");?>
	<div id="main"> 
    	<div id = "breadcrumbs">
        	<p><span class = "otherLoc">当前位置: <a target="_self" href="default.php" >首页</a>&gt;&gt;业务范畴：产品与服务&gt;&gt;</span><span id = "currentLoc"><?php 
			
if (isset($_GET["page"])) {
	$val = $_GET["page"];
} else {
	$val = 1;
}
switch($val){ 
case 1:
 	echo "人力资源咨询";
	break;
case 2:
	echo "培训";
	break;
default:
	echo "评估";	
 }
 ?>
 </span></p>
        </div>

<div class="ContentShadow">

<noscript> 
<iframe src="*.htm"></iframe> 
</noscript>


<div align="center">
	<div align="center">
		<table border="0" cellspacing="1" id="table8" width="800" height="457">
			<!-- MSTableType="layout" -->
			<tr>
				<td colspan="2" height="29">
				<p style="margin-left: 6px; margin-right: 8px; margin-top: 1px; margin-bottom: 1px">
				<font size="2">&nbsp;&nbsp;&nbsp; 
				天慕众和的产品与服务包括：人力资源咨询（<a target="_blank" href="HR%20consultation_01.php">详细</a>）、培训（<a target="_blank" href="trainning_01.php">详细</a>）、评估（<a target="_blank" href="evaluation_01.php">详细</a>）。</font></td>
			</tr>
			<tr>
				<td height="17"></td>
				<td rowspan="7" width="662">
				<p style="margin-left: 6px; margin-right: 8px; margin-top: 1px; margin-bottom: 1px">
				<iframe name="operationI1" width="638" height="411" marginwidth="3" marginheight="6" border="1" frameborder="1" src="operation_0<?php echo $val;?>.htm">
				浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</iframe></td>
			</tr>
			<tr>
				<td class="sideboxTitle" height="29">
				<p <?php if ($val == 1){echo 'class = "bold"';}  ?> style="margin-left: 8px; margin-right: 6px; margin-top: 1px; margin-bottom: 1px" align="right" onclick="changeTitle(1)" id="myHeader1">
				<a target="operationI1" href="operation_01.htm" style="text-decoration: none">
				人力资源咨询</a></font></td>
			</tr>
			<tr>
				<td class="sideboxTitle" height="29">
				<p <?php if ($val == 2){echo 'class = "bold"';}  ?> style="margin-left: 8px; margin-right: 6px; margin-top: 1px; margin-bottom: 1px" align="right" onclick="changeTitle(2)" id="myHeader2">
				<a target="operationI1" href="operation_02.htm" style="text-decoration: none">
				培训</a></font></td>
			</tr>
			<tr>
				<td class="sideboxTitle" height="29">
				<p <?php if ($val == 3){echo 'class = "bold"';}  ?> align="right" style="margin-left: 8px; margin-right: 6px; margin-top: 1px; margin-bottom: 1px"  onclick="changeTitle(3)" id="myHeader3">
				<a target="operationI1" href="operation_03.htm" style="text-decoration: none" >
				评估</a></font></td>
			</tr>
			<tr>
				<td height="21">
				<p style="margin-left: 8px; margin-right: 6px; margin-top: 1px; margin-bottom: 1px" align="left">
				<font size="2">&nbsp;</font></td>
			</tr>
			<tr>
				<td valign="top" height="255">
				<p align="left" style="margin-left: 8px; margin-right: 6px; margin-top: 1px; margin-bottom: 1px">　</td>
			</tr>
			<tr>
				<td height="39" width="131">
				<p style="margin-left: 8px; margin-right: 6px; margin-top: 1px; margin-bottom: 1px" align="left">　</td>
			</tr>
		</table>
	</div>
</div>
</div>

</div> <!-- content-->

</div> <!-- close the wrap div here -->
<?php include("php/footer.php");?>


<script language="JavaScript">
	
    $("#myHeader1").click(function () {
      $("#myHeader1").addClass("bold"); 
	   $("#myHeader2").removeClass("bold"); 
      $("#myHeader3").removeClass("bold"); 
	});
	
	    $("#myHeader2").click(function () {
      $("#myHeader2").addClass("bold"); 
	   $("#myHeader1").removeClass("bold"); 
      $("#myHeader3").removeClass("bold"); 
	});
	
	    $("#myHeader3").click(function () {
      $("#myHeader3").addClass("bold"); 
	   $("#myHeader1").removeClass("bold"); 
      $("#myHeader2").removeClass("bold"); 
	});
	

	
</script>
</body>

</html>
