<?php
error_reporting(0);
include_once ("dbconnect.php");
$sql = "SELECT * FROM COFFEE";
$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["coffee"] = array();
    while ($row = $result->fetch_assoc())
    {
        $coffeelist = array();
        $coffeelist["image"] = $row["IMAGE"];
        $coffeelist["id"] = $row["ID"];
        $coffeelist["name"] = $row["NAME"];
        $coffeelist["price"] = $row["PRICE"];
        $coffeelist["quantity"] = $row["QUANTITY"];
        $coffeelist["rating"] = $row["RATING"];
        array_push($response["coffee"], $coffeelist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>