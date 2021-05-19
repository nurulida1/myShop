<?php
include_once("dbconnect.php");
$prname = $_POST['prname'];
$prprice = $_POST['prprice'];
$prqty = $_POST['prqty'];
$prid = $_POST['prid'];
$prtype = $_POST['prtype'];
$encoded_string = $_POST["encoded_string"];


    $sqlregister = "INSERT INTO tbl_products(prid,prname,prtype,prprice,prqty) VALUES('$prid','$prname','$prtype','$prprice','$prqty')";
    if ($conn->query($sqlregister) === TRUE){
        $decoded_string = base64_decode($encoded_string);
        $filename = mysqli_insert_id($conn);
        $path = '../images/productimages/'.$imagename.'.jpg';
        $is_written = file_put_contents($path, $decoded_string);
        echo "success";
    }else{
        echo "failed";
    }


?>