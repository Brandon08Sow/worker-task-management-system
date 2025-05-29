<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");


include_once("dbconnect.php");

// Safe default
$worker_id = isset($_POST['worker_id']) ? intval($_POST['worker_id']) : 0;

$tasks = [];

if ($worker_id > 0) {
    $sql = "SELECT * FROM tbl_works WHERE assigned_to = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $worker_id);
    $stmt->execute();
    $result = $stmt->get_result();

    while ($row = $result->fetch_assoc()) {
        $tasks[] = $row;
    }
}

// Output the result as JSON
echo json_encode($tasks);
?>
