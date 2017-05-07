<?
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
}
?>
