		<div id = "heading">
			<h1>Bearluga.com</h1>
			<h2> <a href = "/html/link1.php" title = "Daxiong's profile"> Home of<span class = "chn"> 大熊</span></a> </h2>
		</div>

		<!-- Navigation -->
		<div id="menu_wrapper" class="grey">
			<div id="left"></div>
			<ul id="menu">
				<li><a href="/">Home</a></li>
				<li class="active"><a href="#">About</a></li>
				<li class = "chn"><a href="#">大熊</a></li>
				<li><a href="/php/comment.php" title="Post a comment for Daxiong">comment</a></li>
				<span id = "right">

<?php
	include("function.php");
	$a = verifyStatus(); 
	$a = verifyStatus(); 
	if ($a["loggedIn"]) {
?>
					<li ><a href="/php/logout.php" title="Logout" >logout</a></li>
<?php
	}

	else{
?>	
					<li ><a href="/php/login.php" title="Login" >login</a></li>
					<li ><a href="/php/registration.php" title="Register" >register</a></li>
<?php
	}
?>
				</span>
			</ul>


		</div>
