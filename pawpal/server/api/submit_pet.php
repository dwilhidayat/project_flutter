<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(array('error' => 'Method Not Allowed'));
    exit();
}

$user_id     = $_POST['user_id'];
$pet_name    = addslashes($_POST['pet_name']);
$pet_type    = $_POST['pet_type'];
$category    = $_POST['category'];
$description = addslashes($_POST['description']);
$lat         = $_POST['lat'];
$lng         = $_POST['lng'];
$encodedimage = base64_decode($_POST['image0']); // ✅ MATCH FLUTTER

$sqlinsertpet = "INSERT INTO `tbl_pets`
(`user_id`, `pet_name`, `pet_type`, `category`, `description`, `lat`, `lng`)
VALUES
('$user_id','$pet_name','$pet_type','$category','$description','$lat','$lng')";

try {
    if ($conn->query($sqlinsertpet) === TRUE) {

        $last_id = $conn->insert_id;

        // ✅ USER-ID BASED IMAGE NAME
        $path = "../uploads/pet_user_" . $user_id . "_" . $last_id . ".png";
        file_put_contents($path, $encodedimage);

        $imagepath = "uploads/pet_user_" . $user_id . "_" . $last_id . ".png";
        $sqlupdate = "UPDATE `tbl_pets` SET `images`='$imagepath' WHERE `pet_id`='$last_id'";
        $conn->query($sqlupdate);

        $response = array('status' => 'success', 'message' => 'Pet added successfully');
        sendJsonResponse($response);

    } else {
        $response = array('status' => 'failed', 'message' => 'Pet not added');
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
