<?php

// Configurazione database
$servername = "localhost";
$username = "username";
$password = "password";
$dbname = "database";

function connectDB() {
    global $servername, $username, $password, $dbname;
    $conn = new mysqli($servername, $username, $password, $dbname);

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    return $conn;
}

// Funzione per verificare se l'utente è registrato
function isUserRegistered($email, $id_vekn) {
    $conn = connectDB();
    $stmt = $conn->prepare("SELECT COUNT(*) FROM users WHERE email = ? OR id_vekn = ?");
    $stmt->bind_param("ss", $email, $id_vekn);
    $stmt->execute();
    $stmt->bind_result($count);
    $stmt->fetch();
    $stmt->close();
    $conn->close();

    return $count > 0;
}

// Funzione per aggiornare la decklist
function updateDecklist($email, $decklist) {
    $conn = connectDB();
    $stmt = $conn->prepare("UPDATE users SET decklist = ? WHERE email = ?");
    $stmt->bind_param("ss", $decklist, $email);
    $stmt->execute();
    $stmt->close();
    $conn->close();
}

// Funzione per registrare un nuovo utente
function registerUser($data) {
    $conn = connectDB();
    $stmt = $conn->prepare("INSERT INTO users (name, surname, id_vekn, email, decklist, subscription_type) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->bind_param(
        "sssssi",
        $data["name"],
        $data["surname"],
        $data["id_vekn"],
        $data["email"],
        $data["decklist"],
        $data["subscription_type"]
    );
    $stmt->execute();
    $stmt->close();
    $conn->close();
}

// Funzione per verificare il pagamento PayPal
function verifyPaypalPayment($orderId) {
    $clientId = "IL_TUO_CLIENT_ID";
    $clientSecret = "IL_TUO_CLIENT_SECRET";

    $url = "https://api-m.sandbox.paypal.com/v2/checkout/orders/$orderId";

    $curl = curl_init();
    curl_setopt_array($curl, [
        CURLOPT_URL => $url,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_HTTPHEADER => [
            "Authorization: Basic " . base64_encode("$clientId:$clientSecret"),
        ],
    ]);

    $response = curl_exec($curl);
    $status = curl_getinfo($curl, CURLINFO_HTTP_CODE);
    curl_close($curl);

    if ($status == 200) {
        $order = json_decode($response, true);
        return $order["status"] === "COMPLETED";
    } else {
        throw new Exception("Errore nella verifica del pagamento PayPal");
    }
}

// Logica principale
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $input = json_decode(file_get_contents("php://input"), true);

    // Verifica se l'utente è registrato
    if (isset($input["check_registration"])) {
        $email = $input["email"];
        $id_vekn = $input["id_vekn"];
        $isRegistered = isUserRegistered($email, $id_vekn);

        echo json_encode([
            "status" => "success",
            "is_registered" => $isRegistered,
        ]);
        exit;
    }

    // Aggiornamento della decklist
    if (isset($input["update_decklist"])) {
        $email = $input["email"];
        $decklist = $input["decklist"];

        updateDecklist($email, $decklist);
        echo json_encode(["status" => "success", "message" => "Decklist aggiornata"]);
        exit;
    }

    // Registrazione di un nuovo utente
    if (isset($input["register_user"])) {
        $isRegistered = isUserRegistered($input["email"], $input["id_vekn"]);

        if (!$isRegistered) {
            $orderId = $input["paypal_order_id"];
            $isPaymentVerified = verifyPaypalPayment($orderId);

            if ($isPaymentVerified) {
                registerUser($input["user_data"]);
                echo json_encode(["status" => "success", "message" => "Registrazione completata"]);
            } else {
                echo json_encode(["status" => "error", "message" => "Pagamento non verificato"]);
            }
        } else {
            echo json_encode(["status" => "error", "message" => "Utente già registrato"]);
        }
        exit;
    }

    echo json_encode(["status" => "error", "message" => "Richiesta non valida"]);
}
