<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
include_once("dbconnect.php");

$submission_id = $_POST['submission_id'] ?? '';
$updated_text = $_POST['updated_text'] ?? '';

if (!$submission_id || !$updated_text) {
    echo json_encode(["status" => "failed", "message" => "Missing fields"]);
    exit();
}

$sql = "UPDATE tbl_submissions SET submission_text = ? WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ss", $updated_text, $submission_id);

if ($stmt->execute()) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "failed", "message" => $stmt->error]);
}
?>
