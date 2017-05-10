<?

define('BDD_HOST', 'localhost'); 
define('BDD_LOGIN', 'postgres');       
define('BDD_MDP', '');             
define('BDD_DATABASE', 'meyer');    
define('BDD_DRIVER', 'pgsql');

function getBD(){
    try {
        $pdo = new PDO(BDD_DRIVER.':dbname='.BDD_DATABASE.';host='.BDD_HOST, BDD_LOGIN, BDD_MDP);
        $pdo->query('SET NAMES utf8');
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    }
    catch (PDOException $e){
        die('<p>La connexion a échouée. Erreur['.$e->getCode().'] : '.$e->getMessage().'</p>');
    }
    echo 'connect reussi';
    return $pdo;
}
/*
function ins_mess_recu($dest){
    $pdo = getBD();
    $req = 'INSERT INTO sejour(type, date_debut, date_fin) VALUES (:type, :date_debut, :date_fin)';
    $stmt = $pdo->prepare($req);
    $stmt->bindValue(':type', $type);
    $stmt->bindValue(':date_debut', $date_debut);
    $stmt->bindValue(':date_fin', $date_fin);
    if($stmt->execute())
        return $pdo->lastInsertId();
    else
        throw new exception(__FUNCTION__.' Erreur SQL : '.$req);
}
*/
function mess_recu($dest){
    $pdo=getBD();
    $req='SELECT * from mes_messages_recu WHERE mes_messages_recu.dest=:dest';
    $stmt=$pdo->prepare($req);
    $stmt->bindValue(':dest',$dest);
     if($stmt->execute()){
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }else
        throw new exception(__FUNCTION__.' Erreur SQL : '.$req);
}
/*
function listedesmembres()
{
    $pdo = SPDO::getBD(); //connexion base de donnée
    $req = "SELECT * FROM membres";
    $stmt = $pdo->prepare($req);
    if ($stmt->execute()) {
        if ($row = $stmt->fetch(PDO::FETCH_NUM)) { //:: Requete Statitique
            return $row[0];
        } else {
            return false;
        }
    } else {
        throw new Exception(__FUNCTION__ . ' Erreur SQL : ' . $req);
    }
}
function envoyer_message($expe, $dest, $mess, $objet)
{
    $pdo = SPDO::getBD();
    $req = "INSERT INTO mes_messages (destinataire,expediteur,message, objet) VALUES (:dest,:expe,:mess,:objet)";
    $stmt = $pdo->prepare($req);
    $stmt->bindValue(':dest', $dest);
    $stmt->bindValue(':expe', $expe);
    $stmt->bindValue(':mess', $mess);
    $stmt->bindValue(':objet', $objet);
    if ($stmt->execute()) {
        return true;
    } else {
        throw new Exception(__FUNCTION__ . ' Erreur SQL : ' . $req);
    }
}
//fonction pour le lecteur de messages de la page mail, prend en paramètre l'user connecté
function lire_message($moi)
{
    $pdo = SPDO::getBD();
    $req = "SELECT expe, quand, mess FROM mes_messages order by quand";
    $stmt = $pdo->prepare($req);
    if ($stmt->execute()) {
        return $stmt->fetchall(PDO::FETCH_ASSOC);
    } else {
        throw new Exception(__FUNCTION__ . ' Erreur SQL : ' . $req);
    }
}*/
?>
