<?php
require_once 'conn.php';
require_once 'config.php';
require_once 'save_decklist.php';
session_start();

// Debug per verificare la sessione
error_log("Session ID in check_and_register.php: " . session_id());
error_log("Session data: " . print_r($_SESSION, true));

$allowed_origins = [
    "https://vtesitaly.com",
    "https://www.vtesitaly.com"
];

// Abilita CORS
if (isset($_SERVER['HTTP_ORIGIN']) && in_array($_SERVER['HTTP_ORIGIN'], $allowed_origins)) {
    header("Access-Control-Allow-Origin: " . $_SERVER['HTTP_ORIGIN']);
}
// header("Access-Control-Allow-Origin: https://vtesitaly.com");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Access-Control-Max-Age: 86400");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Ottieni i dati dal POST
$data = json_decode(file_get_contents("php://input"), true);

$name = $data["name"];
$surname = $data["surname"];
$id_vekn = $data["id_vekn"];
$email = $data["email"];
$decklist = $data["decklist"];
$subscription_type = (int)$data["subscription_type"];

// Controlla se l'utente esiste già
$sql_check = "SELECT id FROM registrations WHERE id_vekn = ? AND email = ?";
$stmt_check = $conn->prepare($sql_check);
$stmt_check->bind_param("ss", $id_vekn, $email);
$stmt_check->execute();
$stmt_check->store_result();

if ($stmt_check->num_rows > 0 and $subscription_type == 3) {
    // Se l'utente esiste, aggiorna solo la decklist

    $decklist_filename = save_decklist_to_file($decklist, $id_vekn, $name, $surname);

    $sql_update = "UPDATE registrations SET decklist = ? WHERE id_vekn = ?";
    $stmt_update = $conn->prepare($sql_update);
    $stmt_update->bind_param("ss",  $decklist_filename, $id_vekn);

    if ($stmt_update->execute()) {
        // prendi i dati della registrazione già presenti a database
        $sql_check2 = "SELECT name, surname, id_vekn, email, subscription_type
                      FROM registrations 
                      WHERE id_vekn = ? AND email = ?";
        $stmt_check2 = $conn->prepare($sql_check2);
        $stmt_check2->bind_param("ss", $id_vekn, $email);
        $stmt_check2->execute();
        $stmt_check2->bind_result($name, $surname, $id_vekn, $email, $subscription_type);
        $stmt_check2->fetch();


        // Logica per comunicazione via mail di avvenuta registrazione
        $subject = "GP Modena 2025 - Decklist updated";

        $message = "Hello fellow Metuselah,\n\n" .
            "This is to confirm that we updated your decklist in our system. " .
            "We will only consider valid the last decklist you submitted.\n\n" .
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

        if (mail($email, $subject, $message, $headers)) {
            echo json_encode(["status" => "success", "message" => "Registration Complete!"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Email sending failed."]);
        }
        $stmt_update->close();
        $stmt_check->close();
        $conn->close();
        exit();
    } else {
        echo json_encode(["status" => "error", "message" => $stmt_update->error]);
        $stmt_update->close();
        $stmt_check->close();
        $conn->close();
        exit();
    }


} else {
    // Effettua un pagamento con PayPal
    if ($subscription_type == 1) {
        $price = 90.00;
    } elseif ($subscription_type == 2) {
        $price = 125.00;
    } else {
        echo json_encode(["status" => "error", "message" => "Bad Parameters"]);
        $stmt_check->close();
        $conn->close();
        exit();
    }

    // Salva i dati nella sessione
    $_SESSION['user_data'] = [
        'name' => $name,
        'surname' => $surname,
        'id_vekn' => $id_vekn,
        'email' => $email,
        'decklist' => $decklist,
        'subscription_type' => $subscription_type
    ];

    try {
        $response = $gateway->purchase([
            'amount' => $price,
            'currency' => PAYPAL_CURRENCY,
            'returnUrl' => PAYPAL_RETURN_URL,
            'cancelUrl' => PAYPAL_CANCEL_URL,
        ])->send();

        if ($response->isRedirect()) {
            echo json_encode(["status" => "redirect", "url" => $response->getRedirectUrl()]);
        } else {
            echo json_encode(["status" => "error", "message" => $response->getMessage()]);
        }
    } catch (Exception $e) {
        echo json_encode(["status" => "error", "message" => $e->getMessage()]);
    }
}

$stmt_check->close();
$conn->close();
?>
