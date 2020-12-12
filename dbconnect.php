<?php
$servername = "localhost";
$username = "doubleks_coffee_homeadmin";
$password = "27P8T6LI2N";
$dbname = "doubleks_coffee_home";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: ". $conn ->connect_error);
}
?>
