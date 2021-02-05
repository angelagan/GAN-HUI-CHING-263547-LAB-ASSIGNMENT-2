<?php
error_reporting(0);
include_once("dbconnect.php");

$title = $_POST['title'];

$sql = "SELECT * FROM COMMENT WHERE TITLE = '$title'"; 
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $response["comment"] = array();
    
    while ($row = $result ->fetch_assoc()){
        $commentlist = array();
        $commentlist[title] = $row["TITLE"];
        $commentlist[comment] = $row["COMMENT"];
        $commentlist[email] = $row["EMAIL"];
        $commentlist[username] = $row["USERNAME"];
        $commentlist[date] = $row["DATE"];
        
        array_push($response["comment"], $commentlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>