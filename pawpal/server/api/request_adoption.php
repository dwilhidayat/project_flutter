<?php
    header("Access-Control-Allow-Origin: *");
    include 'dbconnect.php';

    if ($_SERVER['REQUEST_METHOD'] != 'POST') {
        sendJsonResponse(['status' => 'failed', 'message' => 'Method Not Allowed']);
        exit();
    }

    $pet_id = $_POST['pet_id'] ?? '';
    $user_id = $_POST['user_id'] ?? '';
    $message = $_POST['message'] ?? '';

    if (empty($pet_id) || empty($user_id) || empty($message)) {
        sendJsonResponse(['status' => 'failed', 'message' => 'Empty fields']);
        exit();
    }

    $sql = "INSERT INTO tbl_adoptions (pet_id, user_id, message)
            VALUES ('$pet_id', '$user_id', '$message')";

    if ($conn->query($sql) === TRUE) {
        sendJsonResponse(['status' => 'success']);
    } else {
        sendJsonResponse(['status' => 'failed']);
    }

    function sendJsonResponse($arr) {
        header('Content-Type: application/json');
        echo json_encode($arr);
    }
?>
