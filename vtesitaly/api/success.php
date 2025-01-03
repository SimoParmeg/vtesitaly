<?php
require_once 'check_and_register.php';

// Registra nuovo utente nel database
$sql_insert = "INSERT INTO registrations (name, surname, id_vekn, email, decklist, subscription_type) VALUES (?, ?, ?, ?, ?, ?)";
$stmt_insert = $conn->prepare($sql_insert);
$stmt_insert->bind_param("sssssi", $name, $surname, $id_vekn, $email, $decklist, $subscription_type);

if ($stmt_insert->execute()) {
    echo json_encode(["status" => "success", "message" => "Registration Complete!"]);
} else {
    echo json_encode(["status" => "error", "message" => $stmt_insert->error]);
}

$stmt_insert->close();

?>