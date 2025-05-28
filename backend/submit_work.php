<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

if (!isset($_POST['work_id']) || !isset($_POST['worker_id']) || !isset($_POST['submission_text'])) {
    echo json_encode(["status" => "failed", "message" => "Missing fields"]);
    exit();
}

include_once("dbconnect.php");

$work_id = $_POST['work_id'];
$worker_id = $_POST['worker_id'];
$submission_text = $_POST['submission_text'];
$submitted_at = date("Y-m-d");

$sqlinsert = "INSERT INTO tbl_submissions (work_id, worker_id, submission_text, submitted_at) 
              VALUES ('$work_id','$worker_id','$submission_text','$submitted_at')";

if ($conn->query($sqlinsert) === TRUE) {
    echo "success";
} else {
    echo "failed";
}
?>
