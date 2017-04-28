/*Permet de créer un type acceptant uniquement des adresses mail (source : https://hashrocket.com/blog/posts/working-with-email-addresses-in-postgresql) */ 
/*CREATE EXTENSION citext;
CREATE DOMAIN email AS citext
  CHECK ( value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' );
*/
  /* Source pour sécuriser mot de passe : http://stackoverflow.com/questions/1200326/what-is-the-datatype-for-a-password-in-postgresql*/
DROP TABLE membres;
DROP TABLE m_envoyes;
DROP TABLE m_recus;
DROP TABLE m_supprimes;

CREATE TABLE membres(
    utilisateur name,
    mdp varchar,
    mail citext primary key,
    nom name,
    prenom name  
);

CREATE TABLE  m_envoyes(
    numero serial primary key,
    objet varchar,
    message varchar,
    expediteur citext,
    destinataire citext,
    date_envoie timestamp DEFAULT current_timestamp
);

CREATE TABLE m_recus(
    numero serial primary key,
    objet varchar,
    message varchar,
    expediteur citext,
    destinataire citext,
    date_envoie timestamp DEFAULT current_timestamp
);

CREATE TABLE m_supprimes(
    numero serial primary key,
    objet varchar,
    message varchar,
    expediteur citext,
    destinataire citext,
    date_envoie timestamp DEFAULT current_timestamp
);

INSERT INTO membres(utilisateur,mdp,mail,nom,prenom) VALUES ('johny','mdpsecret','testdu38@yu.fr','Hug','John');




