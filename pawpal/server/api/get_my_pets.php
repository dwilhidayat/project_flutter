<?php
    header("Access-Control-Allow-Origin: *");
    include 'dbconnect.php';

    if ($_SERVER['REQUEST_METHOD'] != 'GET') {
        sendJsonResponse(array('status'=>'failed','message'=>'Method Not Allowed'));
        exit();
    }

    $userid = $_GET['user_id'];

    $sql = "SELECT * FROM tbl_pets WHERE user_id = '$userid' ORDER BY pet_id DESC";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $petdata = array();
        while ($row = $result->fetch_assoc()) {
            $petdata[] = $row;
        }
        sendJsonResponse(array('status'=>'success','data'=>$petdata));
    } else {
        sendJsonResponse(array('status'=>'failed','data'=>null));
    }

    function sendJsonResponse($sentArray) {
        header('Content-Type: application/json');
        echo json_encode($sentArray);
    }
?>
