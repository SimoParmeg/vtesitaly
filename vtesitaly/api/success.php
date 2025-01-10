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
                        $message = "
                        Hello fellow Metuselah,

                        Thanks for registering to GP Modena 2025.

                        If you registered without a valid decklist it's fine, 
                        just remember to upload the decklist 12 hours before the tournament starts.
                        To change your decklist you can re-compile the form using the same VEKN ID and email (see below), 
                        in this case your decklist will be updated and you will not be charged for subscription again.
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
