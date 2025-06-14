<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
include_once("dbconnect.php");

$worker_id = $_POST['worker_id'] ?? '';

if (!$worker_id) {
    echo json_encode([]);
    exit();
}

$sql = "SELECT s.id, s.submission_text, s.submitted_at, w.title 
        FROM tbl_submissions s
        JOIN tbl_works w ON s.work_id = w.id
        WHERE s.worker_id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $worker_id);
$stmt->execute();
$result = $stmt->get_result();

$submissions = [];
while ($row = $result->fetch_assoc()) {
    $submissions[] = $row;
}

echo json_encode($submissions);
?>
