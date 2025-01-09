<?php
require_once 'conn.php';
session_start();

if (isset($_SESSION['user_data'])) {
    $user_data = $_SESSION['user_data'];

    $name = $user_data['name'];
    $surname = $user_data['surname'];
    $id_vekn = $user_data['id_vekn'];
    $email = $user_data['email'];
    $decklist = $user_data['decklist'];
    $subscription_type = $user_data['subscription_type'];

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
} else {
    echo json_encode(["status" => "error", "message" => "Session data not found."]);
}

$conn->close();
?>
