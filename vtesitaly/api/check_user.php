<?php
require_once 'db_connection.php';

try {
    // Create a new PDO instance for the database connection
    $pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Decode the incoming JSON request
    $data = json_decode(file_get_contents('php://input'), true);

    // Get email and VEKN ID from the request
    $email = $data['email'];
    $id_vekn = $data['id_vekn'];

    // Prepare the SQL query to check if the user exists
    $query = "SELECT * FROM users WHERE email = ? OR id_vekn = ?";
    $stmt = $pdo->prepare($query);
    $stmt->execute([$email, $id_vekn]);

    // Check if any rows were returned
    if ($stmt->rowCount() > 0) {
        echo json_encode(["exists" => true]);
    } else {
        echo json_encode(["exists" => false]);
    }
} catch (PDOException $e) {
    // Handle database connection errors
    echo json_encode(["error" => "Database connection failed: " . $e->getMessage()]);
}
?>
?>