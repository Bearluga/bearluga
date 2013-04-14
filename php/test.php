<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
		<title>Comment Box</title>
		<!--[if !IE]><!-->
		<link type ="text/css" rel= "stylesheet" href= "../bearluga.css" />
		<!--<![endif]-->
		<!--[if IE]>
			<link rel="stylesheet" type="text/css" href="../bearluga_ie_only.css" />
		<![endif]-->
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
<?php   include("header.php");
	error_reporting (E_ALL ^ E_NOTICE);
	require('connect.php');
	$name=$_POST['name'];
	$comment=$_POST['comment'];
	$submit=$_POST['submit'];
	date_default_timezone_set('America/Chicago');
	$time = time();
	$time = date('Y-m-d H:i:s', $time);

	if($submit)
	{
    if($name&&$comment)
    {
    $query=mysql_query("INSERT INTO comment (id,name,comment,time) VALUES ('','$name','$comment','$time')");
    	header("Location: test.php");
    }
    else
    {
        echo "Please fill out all the fields.";
    }
	}

?>

	<h2>Welcome to the Note Board at Bearluga.com</h2>
	<p>Please leave your comment:</p>
	<div id = "post">
		<form action="test.php" method="post">
			<label>Name:  </label><br /><input type="text" name="name" value="<?php echo "$name" ?>" /><br /><br />
			<label>Comment:  </label><br /><textarea name="comment" cols="40" rows="7"></textarea><br /><br /><br />
			<input type="submit" name="submit" value="Comment" /><br />
		</form>
	</div>

	<h2>Comments</h2>
	<?php
	require('connect.php');
	$query=mysql_query("SELECT * FROM comment ORDER BY id DESC");
	while($rows=mysql_fetch_assoc($query))
	{
    $id=$rows['id'];
    $dname=$rows['name'];
    $dcomment=$rows['comment'];
		$dtime = $rows['time'];
     //$linkdel="<a href=\"delete.php?id=" . $rows['id'] . "\">Delete User</a>";
		echo '<div class = "comment">'.$dcomment. '&nbsp' . '&nbsp' . '&nbsp' . '&nbsp'.'<br />'.'<br />'.'By '. '<span class= "red">'.$dname.'</span>'.' | '. $dtime. '&nbsp' . '&nbsp' . '<br />' .'</div>';
	}
	?>

<?php   include("../includes/footer.html"); ?>
	</body>

</html>
