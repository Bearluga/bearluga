	<h2>Comments</h2><?php
	//it shows all previous comments
	require('connect.php');
	$query=mysql_query("SELECT * FROM comment WHERE display=1 ORDER BY id DESC");
	while($rows=mysql_fetch_assoc($query))
	{
	  $id=$rows['id'];
	  $dname=htmlentities($rows['name'], ENT_QUOTES, "UTF-8");
	  $dcomment= htmlentities($rows['comment'], ENT_QUOTES, "UTF-8"); //use htmlentites to prevent malicious XSS
	  $dcomment= nl2br($dcomment);// correctly show newline character when print out
	  $dtime = $rows['time'];
	  $linkdel="<a href=\"delete.php?id=" . $rows['id'] . "\">Delete this comment</a>";
		echo '<div class = "comment ContentShadow">'.$dcomment. '&nbsp' . '&nbsp' . '&nbsp' . '&nbsp'.'<br />'.'<br />'.'By '. '<span class= "red">'.$dname.'</span>'.' | '. $dtime. '&nbsp;&nbsp;';
		$a = verifyStatus();
		if($a['user_level']==1) {echo $linkdel;}
		echo '<br />' .'</div>';
	}
	?>