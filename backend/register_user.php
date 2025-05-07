<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    echo json_encode($response);
    die;
}

include_once("dbconnect.php");

$name = $_POST['name'];
$email = $_POST['email'];
$password = sha1($_POST['password']);
$phone = $_POST['phone'];
$address = $_POST['address'];

$sqlinsert = "INSERT INTO tbl_workers (full_name, email, password, phone, address) 
VALUES ('$name','$email','$password','$phone','$address')";

if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
} else {
    $response = array('status' => 'failed', 'data' => null);
}
echo json_encode($response);
?>
