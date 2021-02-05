<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$title = $_POST['title'];

    $sqlcoffeeinfo ="SELECT * FROM COFFEEINFO WHERE EMAIL = '$email'";
    $coffeeinforesult = $conn->query($sqlcoffeeinfo);
    if ($coffeeinforesult->num_rows > 0)
    {
    while ($row = $coffeeinforesult->fetch_assoc())
    {
        $sqldelete = "DELETE FROM COFFEEINFO WHERE EMAIL = '$email' AND TITLE='$title'";
        $conn->query($sqldelete);
    
    }
    }
    $sqldeletecomment = "DELETE FROM COMMENT WHERE TITLE = '$title'";
        $conn->query($sqldeletecomment);
?>