<?php
function save_decklist_to_file($decklist, $id_vekn, $name, $surname) {
    $decklist_dir = '../decklists/';
    if (!is_dir($decklist_dir)) {
        mkdir($decklist_dir, 0777, true);
    }

    $decklist_filename = $decklist_dir . $surname . '_' . $name . '_' . $id_vekn . '.txt';

    if (file_put_contents($decklist_filename, $decklist) === false) {
        throw new Exception("Failed to save decklist to file.");
    }

    return $decklist_filename;
}
?>