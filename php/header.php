		<div id = "heading">
  <div id="headerword">
  <h1>Bearluga.com</h1>
    <h2> <a href = "/html/link1.php" title = "Daxiong's profile"> Home of<span class = "chn"> 大熊</span></a> </h2>
  </div>
</div>


<div id="navi">  
        <nav id="topNav">
	        <ul id = "naviIE">
       		    <li id="firstNaviL"><a id="firstNaviA" href="/default.php" title="">Home</a></li>
				<li><a href="/php/comment.php" title="Post a comment for Daxiong">Comment</a></li>
<!--						<ul>
                    	<li><a href="operation%20category.php?page=1" title="">人力资源咨询</a></li>
						<li><a href="operation%20category.php?page=2" title="">培训</a></li>
						<li class="last"><a href="operation%20category.php?page=3" title="">评估</a></li>
                    	</ul>
				</li>-->
                <span id = "right">
<?php
	include("function.php");
	$a = verifyStatus(); 
	if ($a["loggedIn"]) {
?>
					<li id="lastNaviL"><a id="lastNaviA" href="/php/logout.php" title="Logout" >Logout</a></li>
<?php
	}

	else{
?>	
					<li ><a class="firstNavi" href="/php/login.php" title="Login" >Login</a></li>
					<li id="lastNaviL"><a id="lastNaviA" href="/php/registration.php" title="Register" >Register</a></li>
<?php
	}
?>
				</span>
			</ul>
		</nav>
</div>







