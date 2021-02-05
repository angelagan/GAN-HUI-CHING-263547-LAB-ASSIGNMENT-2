<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$id = $_POST['id'];
    $sql = "SELECT * FROM COFFEEORDER WHERE EMAIL = '$email' AND ID='$id'";
$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["coffee"] = array();
    while ($row = $result->fetch_assoc())
    {
        $coffeeorderlist = array();
        $coffeeorderlist["id"] = $row["ID"];
        $coffeeorderlist["name"] = $row["NAME"];
        $coffeeorderlist["price"] = $row["PRICE"];
        $coffeeorderlist["quantity"] = $row["QUANTITY"];
        array_push($response["coffeeorder"], $coffeeorderlist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>