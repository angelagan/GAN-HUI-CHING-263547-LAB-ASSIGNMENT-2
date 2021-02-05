<?php
include_once("dbconnect.php");
$email = $_POST['email'];
$username = $_POST['username'];
$image = $_POST['image'];
$title = $_POST['title'];
$description = $_POST['description'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$path = '../images/coffeeimages/'.$image.'.jpg';
$is_written = file_put_contents($path, $decoded_string);

if ($is_written > 0){
    $sqlregister = "INSERT INTO COFFEEINFO(EMAIL,USERNAME,IMAGE,TITLE,DESCRIPTION) VALUES('$email','$username','$image','$title','$description')";

    if ($conn->query($sqlregister) === TRUE){
    echo "success";
    }else{
    echo "failed";
}
}else{
    echo "failed";
}

?>