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
        echo json_encode(["status" => "success", "message" => "Decklist Updated!"]);
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
