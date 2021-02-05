<?php
error_reporting(0);
include_once("dbconnect.php");
$image = $_POST['image'];
$id = $_POST['id'];
$coffeename = $_POST['coffeename'];
$email = $_POST['email'];
$name = $_POST['name'];
$review = $_POST['review'];
$rating = $_POST['rating'];

$sqlinsert = "INSERT INTO REVIEW(IMAGE,ID,COFFEENAME,EMAIL, NAME, REVIEW, RATING) VALUES('$image','$id','$coffeename','$email','$name','$review','$rating')";

if ($conn->query($sqlinsert) === TRUE) {

    echo "success";
  
}else{
    echo "failed";
}

?>