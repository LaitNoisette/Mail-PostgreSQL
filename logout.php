<?php
session_start();
if(session_destroy()) // Détruit toute connexion
{
    header("Location: index.php"); // Redirige vers l'index
}
?>
