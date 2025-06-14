<?php
$servername = "localhost";
$username = "root";
$password = ""; // default password for XAMPP
$dbname = "workertable";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    echo json_encode(["status" => "fail", "message" => "DB connection error"]);
    exit();
}
