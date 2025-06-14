<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
include_once("dbconnect.php");

$full_name = $_POST['name'] ?? ''; // still use 'name' from Flutter
$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';
$phone = $_POST['phone'] ?? '';
$address = $_POST['address'] ?? '';

$hashed_password = password_hash($password, PASSWORD_DEFAULT);

$sql = "INSERT INTO tbl_workers (full_name, email, password, phone, address) VALUES (?, ?, ?, ?, ?)";
$stmt = $conn->prepare($sql);

if (!$stmt) {
    echo json_encode(["status" => "fail", "message" => "Prepare failed: " . $conn->error]);
    exit();
}

$stmt->bind_param("sssss", $full_name, $email, $hashed_password, $phone, $address);

if ($stmt->execute()) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "fail", "message" => $stmt->error]);
}
?>
