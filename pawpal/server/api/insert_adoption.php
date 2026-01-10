<?php
	header("Access-Control-Allow-Origin: *");
	include 'dbconnect.php';

	if ($_SERVER['REQUEST_METHOD'] != 'POST') {
		echo json_encode(['status'=>'failed']);
		exit();
	}

	$pet_id = $_POST['pet_id'];
	$user_id = $_POST['user_id'];
	$message = $_POST['message'];

	if (empty($pet_id) || empty($user_id) || empty($message)) {
		echo json_encode(['status'=>'failed']);
		exit();
	}

	$sql = "INSERT INTO tbl_adoptions(pet_id, user_id, message)
			VALUES('$pet_id','$user_id','$message')";

	if ($conn->query($sql)) {
		echo json_encode(['status'=>'success']);
	} else {
		echo json_encode(['status'=>'failed']);
	}
?>
