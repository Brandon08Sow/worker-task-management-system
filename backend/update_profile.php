<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
include_once("dbconnect.php");

$id = $_POST['worker_id'] ?? '';
$full_name = $_POST['full_name'] ?? '';
$email = $_POST['email'] ?? '';
$phone = $_POST['phone'] ?? '';
$address = $_POST['address'] ?? '';

if (empty($id) || !is_numeric($id)) {
    echo json_encode(["status" => "fail", "message" => "Missing or invalid worker ID"]);
    exit();
}

$sql = "UPDATE tbl_workers SET full_name = ?, email = ?, phone = ?, address = ? WHERE worker_id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ssssi", $full_name, $email, $phone, $address, $id);

if ($stmt->execute()) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "fail", "message" => $stmt->error]);
}
?>
