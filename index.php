<?php
//! A faire avnt toute chose !
// Manip sur le site suivant pour faire fonction pgsql avec wamp (à voir sur google pour lamp) :
// http://jc.etiemble.free.fr/abc/index.php/realisations/trucs-astuces/postgresql-wamp




//Connexion à la base de donnée pgsql appelé postgres, avec l'utuilisateur julien et mot de passe Morasin
  $c=pg_connect ("dbname=postgres user=julien password=Morasin");

  if($c==true)
  {
    echo "julien ok";
  }


//Test d'une première requete qui récupère les info de la table membres ou le nom = julien

   $r=pg_exec ($c , "SELECT * from membres where nom='julien' ");
   for ($i=0; $i<pg_numrows($r); $i++) {
     $l=pg_fetch_array($r,$i);
     echo $l["utilisateur"]." <B>".$l["mail"]."</B>.\n";
   }

 ?>
