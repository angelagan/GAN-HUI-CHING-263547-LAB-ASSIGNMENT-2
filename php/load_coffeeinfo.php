<?php
error_reporting(0);
include_once("dbconnect.php");
$sql = "SELECT * FROM COFFEEINFO"; 
$result = $conn->query($sql);

if ($result->num_rows > 0) 
{
    $response["coffeeinfo"]= array();
    while($row = $result -> fetch_assoc())
    {
        $coffeeinfolist = array();
        $coffeeinfolist[coffeeinfoid] = $row["COFFEEINFOID"];
        $coffeeinfolist[email] = $row["EMAIL"];
        $coffeeinfolist[username] = $row["USERNAME"];
        $coffeeinfolist[image] = $row["IMAGE"];
        $coffeeinfolist[title] = $row["TITLE"]; 
        $coffeeinfolist[description] = $row["DESCRIPTION"];
        $coffeeinfolist[date] = $row["DATE"];
        array_push($response["coffeeinfo"], $coffeeinfolist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>