<meta http-equiv="Cache-control" content="no-cache">
<?php
//! A faire avnt toute chose !
// Manip sur le site suivant pour faire fonction pgsql avec wamp (à voir sur google pour lamp) :
// http://jc.etiemble.free.fr/abc/index.php/realisations/trucs-astuces/postgresql-wamp




//Connexion à la base de donnée pgsql appelé postgres, avec l'utuilisateur julien et mot de passe Morasin
$dsn = "pgsql:host=localhost;port=5432;dbname=meyer;user=postgres;password=";
try{
	// create a PostgreSQL database connection
	$conn = new PDO($dsn);

	// display a message if connected to the PostgreSQL successfully
	if($conn){
		echo "Connected to the <strong>$dsn</strong> database successfully! <br />";
	}
}catch (PDOException $e){
	// report error message
	echo $e->getMessage();
}

//Test d'une première requete qui récupère les info de la table membres ou le nom
   $r=$conn->query('SELECT * from membres');
  
  
while ($donnees = $r->fetch())

{

    echo $donnees['nom'] . '<br />';

}


/*Exemple vue + where */
$r=$conn->query('SELECT * from mes_messages_recu WHERE mes_messages_recu.destinataire=\'franck@iut.fr\'');
 
while ($donnees = $r->fetch())

{

    echo $donnees['mess'] . '<br />';

}


$r->closeCursor();

 ?>
