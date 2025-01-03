<?php
require_once 'db_connection.php';
require_once 'config.php';
// require_once 'charge.php';


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
    } else {
        echo json_encode(["status" => "error", "message" => $stmt_update->error]);
    }

    $stmt_update->close();
} else {
    // EFFETTUA UN PAGAMENTO CON PAYPAL
    if ($subscription_type == 1) {
        $price = 60.00;
    } else if ($subscription_type == 2) {
        $price = 95.00;
    } else {
        echo json_encode(["status" => "error", "message" => "Bad Parameters"]);
        return;
    }

    try {
        $response = $gateway->purchase(array(
            'amount' =>  $price,
            'currency' => PAYPAL_CURRENCY,
            'returnUrl' => PAYPAL_RETURN_URL,
            'cancelUrl' => PAYPAL_CANCEL_URL,
        ))->send();

        if ($response->isRedirect()) {
            $response->redirect(); // this will automatically forward the customer
        } else {
            // not successful
            echo "sono in else";
            echo $response->getMessage();
        }
    } catch(Exception $e) {
        echo "sono in catch";
        echo $e->getMessage();
    }
}

// chiudi la connessione
$stmt_check->close();
$conn->close();
?>
