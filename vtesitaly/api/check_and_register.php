<?php
require_once 'db_connection.php';

// Connessione al database
$conn = new mysqli($servername, $username, $password, $dbname);

// Controlla la connessione
if ($conn->connect_error) {
    die("Connessione al database fallita: " . $conn->connect_error);
}

// Ottieni i dati dal POST
$data = json_decode(file_get_contents("php://input"), true);

$name = $data["name"];
$surname = $data["surname"];
$id_vekn = $data["id_vekn"];
$email = $data["email"];
$decklist = $data["decklist"];
$subscription_type = $data["subscription_type"];

// Controlla se l'utente esiste già
$sql_check = "SELECT id FROM registrations WHERE id_vekn = ? AND email = ?";
$stmt_check = $conn->prepare($sql_check);
$stmt_check->bind_param("ss", $id_vekn, $email);
$stmt_check->execute();
$stmt_check->store_result();

if ($stmt_check->num_rows > 0) {
    // Se l'utente esiste, aggiorna solo la decklist
    $sql_update = "UPDATE registrations SET decklist = ? WHERE id_vekn = ?";
    $stmt_update = $conn->prepare($sql_update);
    $stmt_update->bind_param("ss", $decklist, $id_vekn);

    if ($stmt_update->execute()) {
        echo json_encode(["status" => "success", "message" => "Decklist Updated!"]);
    } else {
        echo json_encode(["status" => "error", "message" => $stmt_update->error]);
    }

    $stmt_update->close();
} else {
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
}

// chiudi la connessione
$stmt_check->close();
$conn->close();
?>
