<?php
	header("Access-Control-Allow-Origin: *");
	header("Content-Type: application/json");
	include 'dbconnect.php';

	if (!isset($_GET['user_id'])) {
		echo json_encode(['status'=>'failed','data'=>null]);
		exit();
	}

	$user_id = $conn->real_escape_string($_GET['user_id']);

	$sql = "
	SELECT 
		d.donation_id,
		d.user_id,
		d.pet_id,
		d.donation_type,
		d.amount,
		d.description,
		d.created_at,
		p.pet_name
	FROM tbl_donations d
	JOIN tbl_pets p ON d.pet_id = p.pet_id
	WHERE d.user_id = '$user_id'
	ORDER BY d.created_at DESC
	";

	$result = $conn->query($sql);

	if ($result->num_rows > 0) {
		$data = [];
		while ($row = $result->fetch_assoc()) {
			$data[] = $row;
		}
		echo json_encode(['status'=>'success','data'=>$data]);
	} else {
		echo json_encode(['status'=>'failed','data'=>null]);
	}
?>
