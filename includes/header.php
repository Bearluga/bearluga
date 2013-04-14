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
				<div id = "right">

<?php

function verifyStatus(){
	$username = "";
	$loggedIn = false;
 // Connects to your Database 
	require("connect.php");
 //checks cookies to make sure they are logged in 
 if(isset($_COOKIE['ID_my_site'])) 
 { 
 	$username = $_COOKIE['ID_my_site']; 
 	$pass = $_COOKIE['Key_my_site']; 
 	$check = mysql_query("SELECT * FROM users WHERE name = '$username'")or die(mysql_error()); 
 	while($info = mysql_fetch_array( $check )) 	 
	{ 
 //if the cookie has the wrong password, they are taken to the login page 
		if ($pass != $info['password']) 
		{ 			
			//do nothing
		} 
		else {
			$loggedIn = true;
			break;
		}
	}
 }
 $arr["loggedIn"] = $loggedIn;
 $arr["username"] = $username;
 return $arr;
}


//	include("/php/function.php");
	$a = verifyStatus(); 
	echo $a["loggedIn"]." ".$a["username"];
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
				</div>
			</ul>


		</div>
