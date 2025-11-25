<?php
header("Access-Control-Allow-Origin: *"); // Allow cross-origin requests
include 'dbconnect.php'; // Include the database connection

// Only allow POST requests
if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405); // Method Not Allowed
    echo json_encode(array('error' => 'Method Not Allowed'));
    exit();
}

// Check if required POST fields are provided
if (!isset($_POST['user_email']) || !isset($_POST['user_password']) || !isset($_POST['user_name']) || !isset($_POST['user_phone'])) {
    http_response_code(400); // Bad Request
    echo json_encode(array('error' => 'Bad Request'));
    exit();
}

// Get user inputs from POST
$name = $_POST['user_name'];
$email = $_POST['user_email'];
$password = $_POST['user_password'];
$hashedPassword = sha1($password); // Hash the password using SHA1 (Note: This is not very secure. You should use password_hash())
$phone = $_POST['user_phone'];

// Check if email already exists in the database
$sqlcheckmail = "SELECT * FROM `tbl_users` WHERE `user_email` = '$email'";
$result = $conn->query($sqlcheckmail);
if ($result->num_rows > 0) {
    $response = array('status' => 'failed', 'message' => 'Email already registered');
    sendJsonResponse($response); // Send failure response if email already exists
    exit();
}

// Insert the new user into the database
$sqlreg = "INSERT INTO `tbl_users`(`user_name`, `user_email`, `user_password`, `user_phone`) VALUES ('$name','$email','$hashedPassword','$phone')";
try {
    if ($conn->query($sqlreg) === TRUE) {
        $response = array('status' => 'success', 'message' => 'User registered successfully');
        sendJsonResponse($response); // Send success response
    } else {
        $response = array('status' => 'failed', 'message' => 'User registration failed');
        sendJsonResponse($response); // Send failure response if insertion fails
    }
} catch (Exception $e) {
    $response = array('status' => 'failed', 'message' => $e->getMessage());
    sendJsonResponse($response); // Send failure response in case of an exception
}

// Function to send a JSON response
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
