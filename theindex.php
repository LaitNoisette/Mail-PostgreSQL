<?php

include('login.php');

if(isset($_SESSION['login_user'])){
    header("location: profile.php");
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Bienvenue</title>
    <link href="css/style1.css" rel="stylesheet" type="text/css">
</head>
<body>
<div id="main">
    <div id="login">
        <form action="" method="post">
            <label>UserName :</label>
            <input id="name" name="username" placeholder="username" type="text">
            <label>Password :</label>
            <input id="password" name="password" placeholder="**********" type="password">
            <input name="submit" type="submit" value=" Login ">
            <span><?php echo $error; ?></span>
        </form>
    </div>
</div>
</body>
</html>
