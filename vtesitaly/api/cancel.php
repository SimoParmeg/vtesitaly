<?php
require_once 'conn.php';

echo json_encode(["status" => "error", "message" => "Payment failed"]);

$stmt_insert->close();

?>