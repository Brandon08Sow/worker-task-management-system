<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
include_once("dbconnect.php");

$id = $_POST['worker_id'] ?? '';

$sql = "SELECT * FROM tbl_workers WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    echo json_encode([
        "status" => "success",
        "data" => [
            "id" => $row['id'],
            "name" => $row['name'],
            "email" => $row['email'],
            "phone" => $row['phone'],
            "address" => $row['address'],
        ]
    ]);
} else {
    echo json_encode(["status" => "fail", "message" => "Worker not found"]);
}
?>
