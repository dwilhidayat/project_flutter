<?php
	header("Access-Control-Allow-Origin: *");
	include 'dbconnect.php';

	if ($_SERVER['REQUEST_METHOD'] != 'POST') {
		http_response_code(405);
		echo json_encode(array('status' => 'failed', 'message' => 'Method Not Allowed'));
		exit();
	}

	$user_id     = $_POST['user_id'];
	$user_name   = addslashes($_POST['user_name']);
	$user_phone  = $_POST['user_phone'];
	$imageBase64 = $_POST['image'] ?? '';

	try {

		$sqlupdate = "UPDATE tbl_users 
					  SET user_name='$user_name', user_phone='$user_phone' 
					  WHERE user_id='$user_id'";

		if ($conn->query($sqlupdate) === TRUE) {

			if (!empty($imageBase64)) {

				$decodedImage = base64_decode($imageBase64);

				$path = "../uploads/profile/profile_user_" . $user_id . ".png";
				file_put_contents($path, $decodedImage);

				$imagepath = "uploads/profile/profile_user_" . $user_id . ".png";
				$sqlimg = "UPDATE tbl_users SET user_image='$imagepath' WHERE user_id='$user_id'";
				$conn->query($sqlimg);
			}

			sendJsonResponse(array(
				'status' => 'success',
				'message' => 'Profile updated successfully'
			));

		} else {
			sendJsonResponse(array(
				'status' => 'failed',
				'message' => 'Profile update failed'
			));
		}

	} catch (Exception $e) {
		sendJsonResponse(array(
			'status' => 'failed',
			'message' => $e->getMessage()
		));
	}

	function sendJsonResponse($sentArray)
	{
		header('Content-Type: application/json');
		echo json_encode($sentArray);
	}
?>
