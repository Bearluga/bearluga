<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="../Team-ART Webset/Team-ArtNew/js/jquery-1.7.1.js"></script>


<style>
 .fat{
	font-weight:bolder; 
 }
 .red{
	color :red; 
 }

</style>

</head>
<body>


<h1 id="myHeader" onClick="changeTitle(1)" >Click me!</h1>

<h1 id="myHeader2" >Click me!</h1>

<h1 id="myHeader3" >Click me!</h1>

<p><span class="fat" id= "a1">hello</span></p>
<p><span class="fat" id= "a2">hello</span></p>
<p><span class="fat" id= "a3">hello</span></p>
<p><span class="fat" id= "a4">hello</span></p>
<p><span class="fat" id= "a5">hello</span></p>

<button id="button">My Button</button>

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
	document.getElementById("myHeader").innerHTML = y;
}
</script>
<script language="JavaScript">

    $("#myHeader").click(function () {
      $("#myHeader2").addClass("red"); 
      $("#myHeader3").toggleClass("red"); 
	});
</script>


</body>
</html>
