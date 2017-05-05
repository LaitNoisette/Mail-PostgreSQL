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

CREATE VIEW mes_messages AS
SELECT numero AS num, expediteur AS expe,date_envoie AS quand,message AS mess
	FROM m_recus
		WHERE destinataire= /*utilisateur courant */
			ORDER BY numero DESC;

INSERT INTO membres(utilisateur,mdp,mail,nom,prenom) VALUES ('johny','mdpsecret','testdu38@yu.fr','Hug','John');

/*Fonction permettant de poster un message d'un destinataire vers un expediteur*/
create or replace function  post(expediteur varchar,destinataire varchar, message text)
RETURNS boolean AS
$$
DECLARE 
u varchar;
BEGIN

select usename into u from pg_user where usename=destinataire;

IF NOT FOUND THEN
	RETURN false;
END IF;

INSERT INTO m_envoyes(message, expediteur, destinataire) VALUES (message,expediteur,u);
INSERT INTO m_recus(message, expediteur, destinataire) VALUES(message,expediteur,u);

RETURN true;
END;
$$
language plpgsql SECURITY DEFINER;

/*Fonction permettant de recupérer les messages d'un utilisateur*/
CREATE OR REPLACE function get(
    in dest citext,
	out num int,
	out expe name,
	out quand timestamp,
	out mess text
)
RETURNS SETOF RECORD AS
$$
DECLARE 
c cursor FOR SELECT numero, expediteur, date_envoie, message 
	 FROM m_recus WHERE destinataire=dest ORDER BY date_envoie DESC;

BEGIN
	OPEN c;
	LOOP
		FETCH c INTO num, expe, quand, mess;
			EXIT WHEN NOT FOUND;
		RETURN NEXT;
	END LOOP;

	CLOSE c;
RETURN;
END;
$$
language plpgsql SECURITY DEFINER;





