<?php
header("Access-Control-Allow-Origin: *"); 
include 'dbconnect.php'; 

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(array('error' => 'Method Not Allowed'));
    exit();
}

if (!isset($_POST['user_email']) || !isset($_POST['user_password']) || !isset($_POST['user_name']) || !isset($_POST['user_phone'])) {
    http_response_code(400);
    echo json_encode(array('error' => 'Bad Request'));
    exit();
}

$name = $_POST['user_name'];
$email = $_POST['user_email'];
$password = $_POST['user_password'];
$hashedPassword = sha1($password); 
$phone = $_POST['user_phone'];


$sqlcheckmail = "SELECT * FROM `tbl_users` WHERE `user_email` = '$email'";
$result = $conn->query($sqlcheckmail);
if ($result->num_rows > 0) {
    $response = array('status' => 'failed', 'message' => 'Email already registered');
    sendJsonResponse($response); 
    exit();
}


$sqlreg = "INSERT INTO `tbl_users`(`user_name`, `user_email`, `user_password`, `user_phone`) VALUES ('$name','$email','$hashedPassword','$phone')";
try {
    if ($conn->query($sqlreg) === TRUE) {
        $response = array('status' => 'success', 'message' => 'User registered successfully');
        sendJsonResponse($response); 
    }else{
        $response = array('status' => 'failed', 'message' => 'User registration failed');
        sendJsonResponse($response); 
    }
} catch (Exception $e) {
    $response = array('status' => 'failed', 'message' => $e->getMessage());
    sendJsonResponse($response); 
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
