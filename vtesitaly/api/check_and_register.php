<?php
require_once 'conn.php';
require_once 'config.php';
session_start();

// Abilita CORS
header("Access-Control-Allow-Origin: *");
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

if ($stmt_check->num_rows > 0) {
    // Se l'utente esiste, aggiorna solo la decklist
    $sql_update = "UPDATE registrations SET decklist = ? WHERE id_vekn = ?";
    $stmt_update = $conn->prepare($sql_update);
    $stmt_update->bind_param("ss", $decklist, $id_vekn);

    if ($stmt_update->execute()) {
        // prendi i dati della registrazione già presenti a database
        $sql_check2 = "SELECT name, surname, id_vekn, email, decklist, subscription_type
                      FROM registrations 
                      WHERE id_vekn = ? AND email = ?";
        $stmt_check2 = $conn->prepare($sql_check2);
        $stmt_check2->bind_param("ss", $id_vekn, $email);
        $stmt_check2->execute();
        $stmt_check2->bind_result($name, $surname, $id_vekn, $email, $decklist, $subscription_type);
        $stmt_check2->fetch();

        // Logica per comunicazione via mail di avvenuta registrazione
        $subject = "GP Modena 2025 - Decklist updated";
        $message = "
        Hello fellow Metuselah,

        This is to confirm you we updated 
        the decklist on our system.
        We will consider valid only the last 
        decklist subscribed.


        Here are the details of your registration:
        
        name: $name 
        surname: $surname
        VEKN ID: $id_vekn
        Email: $email
        Subscription: " . ($subscription_type == 1 ? "GP Saturday" : "GP Saturday + Redemption Event Sunday") . "
        
        Your Decklist:
        $decklist

        Don't hesitate to contact us 
        if you need clarifications.

        Bleed for 9, see you in Modena
        Vtes Italy
        ";
        $headers = "From: 	info@vtesitaly.com\r\n" .
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
        $price = 60.00;
    } elseif ($subscription_type == 2) {
        $price = 95.00;
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
