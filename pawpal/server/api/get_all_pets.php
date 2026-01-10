 <?php
    header("Access-Control-Allow-Origin: *");
    include 'dbconnect.php';

    if ($_SERVER['REQUEST_METHOD'] != 'GET') {
        sendJsonResponse(array('status'=>'failed','message'=>'Method Not Allowed'));
        exit();
    }

    $sql = "SELECT * FROM tbl_pets WHERE 1";

    if (isset($_GET['search']) && !empty($_GET['search'])) {
        $search = $conn->real_escape_string($_GET['search']);
        $sql .= " AND pet_name LIKE '%$search%'";
    }
    if (isset($_GET['type']) && $_GET['type'] != "all") {
        $type = $conn->real_escape_string($_GET['type']);
        $sql .= " AND pet_type = '$type'";
    }
    $sql .= " ORDER BY pet_id DESC";

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
