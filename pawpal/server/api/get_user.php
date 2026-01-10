<?php
	header("Access-Control-Allow-Origin: *");
	include 'dbconnect.php';

	$user_id = $_GET['user_id'];

	$sql = "SELECT * FROM tbl_users WHERE user_id='$user_id'";
	$result = $conn->query($sql);

	if ($result->num_rows > 0) {
		$row = $result->fetch_assoc();
		echo json_encode(['status'=>'success','data'=>$row]);
	} else {
		echo json_encode(['status'=>'failed']);
	}
?>
