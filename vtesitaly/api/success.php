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
        // Logica per comunicazione via mail di avvenuta registrazione
        $subject = "GP Modena 2025 - Registration confirmed";
        $message = "
        Hello fellow Metuselah,

        Thanks for registering to GP Modena 2025.

        If you registered without a valid decklist it's fine, 
        just remember to upload the decklist 12 hours before the tournament starts.
        To change your decklist you can re-compile the form using the same vekn and email (see below), 
        in this case your decklist will be updated and you will not charged for subscription again.
        We will consider valid only the last decklist subscribed.


        Here are the details of your registration:
        
        Name: $name 
        Surname: $surname
        VEKN ID: $id_vekn
        Email: $email
        Subscription: " . ($subscription_type == 1 ? "GP Saturday" : "GP Saturday + Redemption Event Sunday") . "
        
        Your Decklist:
        $decklist

        Don't hesitate to contact us if you need clarifications.

        Bleed for 9, see you in Modena
        Vtes Italy
        ";
        $headers = "From: info@vtesitaly.com\r\n" .
                   "Reply-To: info@vtesitaly.com\r\n" .
                   "Content-Type: text/plain; charset=UTF-8";

        if (mail($email, $subject, strip_tags($message), $headers)) {
            echo "
            <html>
            <head>
                <title>Registration Confirmed</title>
            </head>
            <body style='font-family: Arial, sans-serif; margin: 20px;'>
                <h2>Registration Complete!</h2>
                <p>Your registration for GP Modena 2025 has been successfully completed.</p>
                <p style='white-space: pre-line;'>$message</p>
            </body>
            </html>
            ";
        } else {
            echo json_encode(["status" => "error", "message" => "Email sending failed."]);
        }
    } else {
        // Gestione errore inserimento nel database
        echo json_encode(["status" => "error", "message" => "Failed to register user in the database."]);
    }
} else {
    // Gestione sessione non trovata
    echo json_encode(["status" => "error", "message" => "User session data not found."]);
}

?>
