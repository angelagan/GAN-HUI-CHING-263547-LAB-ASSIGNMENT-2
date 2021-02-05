<?php
include_once("dbconnect.php");

$title = $_POST['title'];
$comment = $_POST['comment'];
$email = $_POST['email'];
$username = $_POST['username'];

$sqlregister = "INSERT INTO COMMENT(TITLE,COMMENT,EMAIL,USERNAME) VALUES('$title','$comment','$email','$username')";

if ($conn->query($sqlregister) === TRUE) {

    echo "success";
  
}else{
    echo "failed";
}

?>