<?php
require_once 'check_and_register.php';

echo json_encode(["status" => "error", "message" => "Payment failed"]);

$stmt_insert->close();

?>