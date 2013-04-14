<?php ob_start();?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
		<title>Comment Box</title>
		<link type ="text/css" rel= "stylesheet" href= "../bearluga.css" />
        <script type="text/javascript" src="/js/jquery.animate-shadow.js"></script>
		<script type="text/javascript" src="/js/jquery.js"></script>
		<script type="text/javascript" src="/js/modernizr.js"></script> 
		<style type= "text/css">
			#post{
				text-align: left;
				border-bottom: 3px groove white;
			}
			.comment{
				background-color: #EEEEEE ;
				margin: 10px 0px;
			}

		</style>
	</head>
	<body>
    <?php 
	include("header.php");
	?>
    <div id= "allContent">
	<?php 
	$a = verifyStatus();//get login info
	if($loggedIn = (boolean)$a["loggedIn"]) $name=$a["username"];
		
	if(isset($_POST['submitted'])){
	  //$name=$_POST['name'];
	  
	  $comment=$_POST['comment'];
	  $submit=$_POST['submitted'];
	  date_default_timezone_set('America/Vancouver');
	  $time = time();
	  $time = date('Y-m-d H:i:s', $time);
	  if($comment){
		  require_once('connect.php');
		  $query=mysql_query("INSERT INTO comment (id,name,comment,time) VALUES ('','$name','$comment','$time')"); // id is "comment-id"
		  header("Location: comment.php");
	  }
	  else{
		  echo '<p class="red" >Please leave some words for Daxiong.</p>';
	  }
	}
	echo '<h2>Welcome to the Note Board at Bearluga.com</h2>';
	
    if($loggedIn){
    // the user has logged-in
      echo '<p>Hey, <span class="red">'.$name.'</span>, wanna say something? :)</p>
      <div id = "post">
          <form action="comment.php" method="post">
		  <label>Comment:  </label><br /><textarea name="comment" cols="40" rows="7"></textarea><br /><br />
            <input type="submit" name="submitted" value="Comment" />
            <br /><br />
          </form>
      </div>';
	}
	else{
		//the user hasn't logged-in yet
		echo '<p>Please <a href="login.php">sign in</a> before leaving your comment :)</p>';
	}
	?>
	<?php 
	include("displayComment.php");
	include("../includes/footer.html");
	ob_flush(); ?>
</div>
</body>
</html>
