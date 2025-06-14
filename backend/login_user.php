<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
include_once("dbconnect.php");

$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';

$sql = "SELECT * FROM tbl_workers WHERE email = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    if (password_verify($password, $row['password'])) {
        echo json_encode([
            "status" => "success",
            "data" => [
                "id" => $row['worker_id'],
                "full_name" => $row['full_name'],
                "email" => $row['email'],
                "phone" => $row['phone'],
                "address" => $row['address'],
            ]
        ]);
    } else {
        echo json_encode(["status" => "fail", "message" => "Incorrect password"]);
    }
} else {
    echo json_encode(["status" => "fail", "message" => "Worker not found"]);
}
?>
