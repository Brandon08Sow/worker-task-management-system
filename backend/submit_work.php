<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
include_once("dbconnect.php");

$work_id = $_POST['work_id'] ?? '';
$worker_id = $_POST['worker_id'] ?? '';
$submission_text = $_POST['submission_text'] ?? '';
$submitted_at = date("Y-m-d");

$sqlinsert = "INSERT INTO tbl_submissions (work_id, worker_id, submission_text, submitted_at)
              VALUES (?, ?, ?, ?)";
$stmt = $conn->prepare($sqlinsert);
$stmt->bind_param("iiss", $work_id, $worker_id, $submission_text, $submitted_at);

if ($stmt->execute()) {
    $sqlupdate = "UPDATE tbl_works SET status = 'pending confirmation' WHERE id = ?";
    $stmt2 = $conn->prepare($sqlupdate);
    $stmt2->bind_param("i", $work_id);
    if ($stmt2->execute()) {
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode(["status" => "fail", "message" => "Status update failed"]);
    }
} else {
    echo json_encode(["status" => "fail", "message" => "Submission failed"]);
}
?>
