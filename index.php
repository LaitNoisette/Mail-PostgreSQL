<?php
//! A faire avnt toute chose !
// Manip sur le site suivant pour faire fonction pgsql avec wamp (à voir sur google pour lamp) :
// http://jc.etiemble.free.fr/abc/index.php/realisations/trucs-astuces/postgresql-wamp


echo phpinfo();

//Connexion à la base de donnée pgsql appelé postgres, avec l'utuilisateur julien et mot de passe Morasin
 /* $c=pg_connect ("host=localhost dbname=meyer user=meyer");

  if($c==true)
  {
    echo "julien ok";
  }*/

$dsn = "pgsql:host=localhost;port=5432;dbname=meyer;user=meyer";
try{
	// create a PostgreSQL database connection
	$conn = new PDO($dsn);

	// display a message if connected to the PostgreSQL successfully
	if($conn){
		echo "Connected to the <strong>$dsn</strong> database successfully!";
	}
}catch (PDOException $e){
	// report error message
	echo $e->getMessage();
}

//Test d'une première requete qui récupère les info de la table membres ou le nom = julien
/*
   $r=pg_exec ($c , "SELECT * from membres where nom='Hug' ");
   for ($i=0; $i<pg_numrows($r); $i++) {
     $l=pg_fetch_array($r,$i);
     echo $l["utilisateur"]." <B>".$l["mail"]."</B>.\n";
   }
*/
 ?>
