<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

if (!isset($_POST['email']) || !isset($_POST['password'])) {
    echo json_encode(["status" => "failed", "message" => "Missing fields"]);
    exit();
}

include_once("dbconnect.php");

$email    = $_POST['email'];
$password = sha1($_POST['password']);

$sql    = "SELECT * FROM tbl_workers WHERE email = ? AND password = ?";
$stmt   = $conn->prepare($sql);
$stmt->bind_param("ss", $email, $password);
$stmt->execute();
$result = $stmt->get_result();

if ($result && $result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $response = [
        "status" => "success",
        "data"   => [
    
            "id"        => $row['worker_id'],
            "full_name" => $row['full_name'],
            "email"     => $row['email'],
            "phone"     => $row['phone'],
            "address"   => $row['address']
        ]
    ];
} else {
    $response = ["status" => "failed"];
}

echo json_encode($response);
?>
