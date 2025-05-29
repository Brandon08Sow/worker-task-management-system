<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
include_once("dbconnect.php");

if (!isset($_POST['work_id']) || !isset($_POST['worker_id']) || !isset($_POST['submission_text'])) {
    echo json_encode(["status" => "failed", "message" => "Missing fields"]);
    exit();
}

$work_id = $_POST['work_id'];
$worker_id = $_POST['worker_id'];
$submission_text = $_POST['submission_text'];
$submitted_at = date("Y-m-d");

// 1. Insert submission record using prepared statement
$sqlinsert = "INSERT INTO tbl_submissions (work_id, worker_id, submission_text, submitted_at) 
              VALUES (?, ?, ?, ?)";
$stmt = $conn->prepare($sqlinsert);
$stmt->bind_param("iiss", $work_id, $worker_id, $submission_text, $submitted_at);

if ($stmt->execute()) {
    // 2. Update task status
    $sqlupdate = "UPDATE tbl_works SET status = 'pending confirmation' WHERE id = ?";
    $stmt2 = $conn->prepare($sqlupdate);
    $stmt2->bind_param("i", $work_id);

    if ($stmt2->execute()) {
        echo "success";
    } else {
        echo "failed: " . $stmt2->error;
    }

    $stmt2->close();
} else {
    echo "failed: " . $stmt->error;
}

$stmt->close();
$conn->close();
?>
