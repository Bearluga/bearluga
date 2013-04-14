<?php
require_once('connect.php');
$deleteid=$_GET['id'];
//mysql_query("DELETE FROM comment WHERE id='$deleteid'");
mysql_query("UPDATE  `onibjcc_comment`.`comment` SET  `display` =  '0' WHERE  `comment`.`id` ='$deleteid';");
header("location: comment.php");
?>