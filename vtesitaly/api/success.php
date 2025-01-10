<?php
require_once 'conn.php';
require_once 'config.php';
require_once 'save_decklist.php';
session_start();

if (isset($_GET['paymentId']) && isset($_GET['PayerID'])) {
    if (isset($_SESSION['user_data'])) {
        $user_data = $_SESSION['user_data'];

        $name = $user_data['name'];
        $surname = $user_data['surname'];
        $id_vekn = $user_data['id_vekn'];
        $email = $user_data['email'];
        $decklist = $user_data['decklist'];
        $subscription_type = $user_data['subscription_type'];

        try {
            // Ottieni i parametri di ritorno da PayPal
            $paymentId = $_GET['paymentId'];
            $payerId = $_GET['PayerID'];

            // Configura la richiesta di completamento della transazione
            $transaction = $gateway->completePurchase([
                'transactionReference' => $paymentId, // Il paymentId è il riferimento della transazione
                'payerId' => $payerId,
                'amount' => ($subscription_type == 1) ? 60.00 : 95.00,
                'currency' => PAYPAL_CURRENCY,
            ]);

            $response = $transaction->send();

            if ($response->isSuccessful()) {
                $data = $response->getData(); // Dati della transazione
                $payment_status = $data['state'];

                if ($payment_status === 'approved') {
                    // Salva la decklist come file di testo
                    
                    $decklist_filename = save_decklist_to_file($decklist, $id_vekn, $name, $surname);

                    // Registra nuovo utente nel database
                    $sql_insert = "INSERT INTO registrations (name, surname, id_vekn, email, decklist, subscription_type) VALUES (?, ?, ?, ?, ?, ?)";
                    $stmt_insert = $conn->prepare($sql_insert);
                    $stmt_insert->bind_param("sssssi", $name, $surname, $id_vekn, $email, $decklist_filename, $subscription_type);

                    if ($stmt_insert->execute()) {
                        // Logica per comunicazione via mail di avvenuta registrazione
                        $subject = "GP Modena 2025 - Registration confirmed";

                        $message = "Hello fellow Metuselah,\n\n" .
                            "Thanks for registering to GP Modena 2025.\n\n" .
                            "If you registered without a valid decklist, it's fine. Just remember to upload the decklist 12 hours before the tournament starts.\n" .
                            "To change your decklist, you can re-submit the form using the same VEKN ID and email (see below). In this case, your decklist will be updated, and you will not be charged for subscription again.\n" .
                            "We will only consider the last decklist submitted as valid.\n\n" .
                            "Here are the details of your registration:\n\n" .
                            "Name: $name\n" .
                            "Surname: $surname\n" .
                            "VEKN ID: $id_vekn\n" .
                            "Email: $email\n" .
                            "Subscription: " . ($subscription_type == 1 ? "GP Saturday" : "GP Saturday + Redemption Event Sunday") . "\n\n" .
                            "Your Decklist:\n" .
                            "$decklist\n\n" .
                            "Don't hesitate to contact us if you need clarifications.\n\n" .
                            "Bleed for 9, see you in Modena.\n\n" .
                            "Best regards,\n" .
                            "Vtes Italy";
                       

                        $headers = "From: info@vtesitaly.com\r\n" .
                                   "Reply-To: info@vtesitaly.com\r\n" .
                                   "Content-Type: text/plain; charset=UTF-8";

                        if (mail($email, $subject, strip_tags($message), $headers)) {
                            echo "
                            <html>
                            <head>
                                <title>Registration Confirmed</title>
                                <style>
                                    body {
                                        font-family: Arial, sans-serif;
                                        margin: 20px;
                                        line-height: 1.6;
                                    }
                                    h2 {
                                        color: #333;
                                    }
                                    .details {
                                        background: #f9f9f9;
                                        padding: 15px;
                                        border: 1px solid #ddd;
                                        border-radius: 5px;
                                        margin-top: 20px;
                                    }
                                    .details p {
                                        margin: 5px 0;
                                    }
                                    .footer {
                                        margin-top: 30px;
                                        font-size: 0.9em;
                                        color: #555;
                                    }
                                </style>
                            </head>
                            <body>
                                <h2>Registration Complete!</h2>
                                <p>Thank you for registering for GP Modena 2025. Your registration has been successfully completed.</p>
                                <div class='details'>
                                    <h4>Registration Details:</h4>
                                    <p><strong>Name:</strong> $name</p>
                                    <p><strong>Surname:</strong> $surname</p>
                                    <p><strong>VEKN ID:</strong> $id_vekn</p>
                                    <p><strong>Email:</strong> $email</p>
                                    <p><strong>Subscription:</strong> " . ($subscription_type == 1 ? "GP Saturday" : "GP Saturday + Redemption Event Sunday") . "</p>
                                </div>
                                <div class='details'>
                                    <h4>Your Decklist:</h4>
                                    <pre style='background: #f4f4f4; padding: 10px; border: 1px solid #ddd;'>$decklist</pre>
                                </div>
                                <p>If you registered without a valid decklist, that's fine. Just remember to upload the decklist 12 hours before the tournament starts.</p>
                                <p>To update your decklist, re-submit the form using the same VEKN ID and email. Only the last decklist submitted will be considered valid.</p>
                                <p class='footer'>Bleed for 9, see you in Modena.<br>Best regards,<br>Vtes Italy</p>
                            </body>
                            </html>
                            ";
                        } else {
                            echo json_encode(["status" => "error", "message" => "Email sending failed."]);
                        }
                    } else {
                        echo json_encode(["status" => "error", "message" => "Failed to register user in the database."]);
                    }
                } else {
                    echo "Payment not approved. Status: " . $payment_status;
                }
            } else {
                echo "Payment verification failed: " . $response->getMessage();
            }
        } catch (Exception $e) {
            echo "Exception caught during payment verification: " . $e->getMessage();
        }
    } else {
        echo json_encode(["status" => "error", "message" => "User session data not found."]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Missing payment parameters."]);
}

?>
