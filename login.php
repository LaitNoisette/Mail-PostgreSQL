<?php
session_start(); // Début Session
$error='';
if (isset($_POST['submit'])) {
    if (empty($_POST['username']) || empty($_POST['password'])) {
        $error = "Username or Password is invalid";
    }
    else
    {
// Definition du mail et du mdp
        $username=$_POST['username'];
        $password=$_POST['password'];

        $connection = mysql_connect("localhost", "root", "");

        $username = stripslashes($username);
        $password = stripslashes($password);
        $username = pgsql_real_escape_string($username);
        $password = pgsql_real_escape_string($password);
// Choix de la base
        $db = pgsql_select_db("postgres", $connection);


        $query = pgsql_query("select mail, mdp from membres where mdp='$password' AND mail='$username'", $connection);
        $rows = pgsql_num_rows($query);
        if ($rows == 1) {
            $_SESSION['login_user']=$username; // Debut session
            header("location: accueil.php"); // Redirection vers accueil
        } else {
            $error = "Username ou Password invalide";
        }
        pgsql_close($connection); // Closing Connection
    }
}
?>
