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
    mail email primary key,
    nom name,
    prenom name  
);

CREATE TABLE  m_envoyes(
    numero serial primary key,
    objet varchar,
    message varchar,
    expediteur email,
    destinataire email,
    date_envoie timestamp DEFAULT current_timestamp,
    del_m int DEFAULT 0
);

CREATE TABLE m_recus(
    numero serial primary key,
    objet varchar,
    message varchar,
    expediteur email,
    destinataire email,
    date_envoie timestamp DEFAULT current_timestamp,
    del_m int DEFAULT 0
);
/*Jeu de Test*/
INSERT INTO membres(utilisateur,mdp,mail,nom,prenom) VALUES ('johny','mdpsecret','testdu38@yu.fr','Hug','John');
INSERT INTO membres(utilisateur,mdp,mail,nom,prenom) VALUES ('franky','franckmdp','franck@iut.fr','MEYER','Franck');
INSERT INTO membres(utilisateur,mdp,mail,nom,prenom) VALUES ('pissaraw','henrimdp','henri@iut.fr','PISSA','Henri');
INSERT INTO m_envoyes(objet,message,expediteur,destinataire)VALUES ('Salut Henri','Comment ça va ?','franck@iut.fr','henri@iut.fr');
INSERT INTO m_recus(objet,message,expediteur,destinataire)VALUES ('Salut Henri','Comment ça va ?','franck@iut.fr','henri@iut.fr');
INSERT INTO m_envoyes(objet,message,expediteur,destinataire)VALUES ('COUCOU','NINJA','testdu38@yu.fr','henri@iut.fr');
INSERT INTO m_recus(objet,message,expediteur,destinataire)VALUES ('COUCOU','NINJA','testdu38@yu.fr','henri@iut.fr');
INSERT INTO m_envoyes(objet,message,expediteur,destinataire)VALUES ('JE SAIS','ahha','testdu38@yu.fr','franck@iut.fr');
INSERT INTO m_recus(objet,message,expediteur,destinataire)VALUES ('JE SAIS','ahha','testdu38@yu.fr','franck@iut.fr');

INSERT INTO mes_messages_recu(expe,mess,dest,obj)VALUES('franck@iut.fr','OVNI','henri@iut.fr','COUCOU HENRI PHP');

/*Toutes les views*/
DROP VIEW mes_messages_recu;
CREATE VIEW mes_messages_recu AS
SELECT numero AS num, expediteur AS expe,date_envoie AS quand,message AS mess,destinataire AS dest,objet AS obj
	FROM m_recus
		WHERE del_m=0
			ORDER BY numero DESC;

CREATE VIEW mes_messages_env AS
SELECT numero AS num, destinataire AS dest,date_envoie AS quand,message AS mess, expediteur AS expe,objet AS obj
	FROM m_envoyes
		WHERE del_m=0
			ORDER BY numero DESC;

CREATE VIEW mes_messages_sup AS 
SELECT numero AS num, destinataire AS dest,date_envoie AS quand,message AS mess, expediteur AS expe,objet AS obj
	FROM m_envoyes
		WHERE del_m=1
UNION
SELECT numero AS num, destinataire AS dest,date_envoie AS quand,message AS mess, expediteur AS expe,objet AS obj
	FROM m_recus
		WHERE del_m=1
ORDER BY num DESC;

/* Regles concernant lenvoi a un utilisateur existant*/
CREATE OR REPLACE RULE post_m_recus
AS ON INSERT to mes_messages_recu 
DO INSTEAD
INSERT INTO m_recus(objet,message,destinataire,expediteur) VALUES(new.obj,new.mess,new.dest,new.expe);
/* Regles concernant lenvoi a un utilisateur inexistant*/
CREATE OR REPLACE RULE post_m_recus
AS ON INSERT to mes_messages_recu
DO INSTEAD
NOTHING;

/* Regles concernant lenvoi a un utilisateur existant*/
CREATE OR REPLACE RULE post_m_envoyes
AS ON INSERT to mes_messages_env 
DO INSTEAD
INSERT INTO m_envoyes(objet,message,destinataire,expediteur) VALUES(new.obj,new.mess,new.dest,new.expe);

/* Regles concernant lenvoi a un utilisateur inexistant*/
CREATE OR REPLACE RULE post_m_envoyes
AS ON INSERT to mes_messages_env 
DO INSTEAD
NOTHING;


CREATE OR REPLACE RULE del_m_envoyes
AS ON DELETE to mes_messages_env
DO INSTEAD
UPDATE m_envoyes SET del_m=1 WHERE numero=old.num;

CREATE OR REPLACE RULE del_m_recus
AS ON DELETE to mes_messages_recu
DO INSTEAD
UPDATE m_recus SET del_m=1 WHERE numero=old.num;

/*Fonction boolean permettant de verifier si un utilisateur existe */
CREATE OR REPLACE FUNCTION connexion_mail_bool(m email,mdp varchar)
AS RETURNS boolean
$$
BEGIN
SELECT utilisateur FROM membres WHERE mail=m AND mdp=mdp;
IF NOT FOUND THEN
	RETURN false;
END IF;

RETURN true;
END;
$$
language plpgsql;

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

CREATE OR REPLACE FUNCTION mailcheck_env()
	RETURNS TRIGGER AS
$$
	DECLARE
		m mail;
	BEGIN
	SELECT mail INTO m FROM membres WHERE mail=new.dest;

	IF NOT (FOUND) THEN
		RETURN NULL;
	END IF;

	RETURN NEW;
	END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER mailcheck_env
	BEFORE INSERT ON mes_messages_env
	FOR EACH statement
	EXECUTE PROCEDURE mailcheck_env();

CREATE OR REPLACE FUNCTION mailcheck_recu()
	RETURNS TRIGGER AS
$$
	DECLARE
		m mail;
	BEGIN
	SELECT mail INTO m FROM membres WHERE mail=new.dest;
	 
	IF NOT (FOUND) THEN
		RETURN NULL;
	END IF;

	RETURN NEW;
	END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER mailcheck_recu
	BEFORE INSERT ON mes_messages_recu
	FOR EACH statement
	EXECUTE PROCEDURE mailcheck_recu();



