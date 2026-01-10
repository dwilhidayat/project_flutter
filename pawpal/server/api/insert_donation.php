<?php
	header("Access-Control-Allow-Origin: *");
	include 'dbconnect.php';

	if ($_SERVER['REQUEST_METHOD'] != 'POST') {
		sendJsonResponse(array(
			'status' => 'failed',
			'message' => 'Method Not Allowed'
		));
		exit();
	}

	$user_id = $_POST['user_id'];
	$pet_id  = $_POST['pet_id'];
	$type    = $_POST['donation_type'];
	$amount  = $_POST['amount'] ?? '';
	$desc    = $_POST['description'] ?? '';

	$sql = "INSERT INTO tbl_donations
			(user_id, pet_id, donation_type, amount, description)
			VALUES
			('$user_id', '$pet_id', '$type', '$amount', '$desc')";

	if ($conn->query($sql) === TRUE) {
		sendJsonResponse(array(
			'status' => 'success',
			'message' => 'Donation recorded'
		));
	} else {
		sendJsonResponse(array(
			'status' => 'failed',
			'message' => 'Donation failed'
		));
	}

	function sendJsonResponse($sentArray)
	{
		header('Content-Type: application/json');
		echo json_encode($sentArray);
	}
?>
