<?php 
    if (isset($_POST["value"])) {
        $servername = "1&db";
        $user = "studi181_mafia-scan";
        $pw = "qwe700700";
        $db = "studi181_mafia-scan";
        #Connect to Server
        $con = new Mysqli($servername, $user, $pw, $db) or die(Mysqli_errno());

        $value =htmlspecialchars(stripslashes(trim($_POST["value"])));

        $sql = $con->prepare("INSERT INTO tableName (value) VALUES ('$value')");
        $result = $sql->execute();
        if ($result) {
            echo "Success";
        }
        else {
            echo "Failed";
        }
        $con->close();
    } 
    else {
       echo "Not found";
    } 
?>