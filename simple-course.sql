-----------------	BDD - Illustrative examples	 	-----------------
----------- version 31 mars 2013, mise à jour le 09 février 2015 ----------------

-----------------------------------------------------------------------------
-- Clear previous information.
-----------------------------------------------------------------------------
DROP TABLE IF EXISTS CLIENT CASCADE;
DROP TABLE IF EXISTS TYPE_PRODUIT CASCADE;
DROP TABLE IF EXISTS COMMANDE CASCADE;
DROP TABLE IF EXISTS PRODUIT CASCADE;
DROP TABLE IF EXISTS METHODE_PAIEMENT CASCADE;
DROP TABLE IF EXISTS DETAILS_COMMANDE CASCADE;
DROP TABLE IF EXISTS ADRESSE_LIVRAISON CASCADE;
DROP TABLE IF EXISTS LIVRAISON CASCADE;
DROP TABLE IF EXISTS COMMANDE_PAYEE CASCADE;
DROP TYPE IF EXISTS SEXE;
DROP TYPE IF EXISTS CARTE;


-----------------------------------------------------------------------------
-- Initialize the structure.
-----------------------------------------------------------------------------

CREATE type SEXE as enum('Male', 'Female', 'Other');
CREATE type CARTE as enum('visa', 'mastercard', 'americanexpress', 'jcb', 'instapayment');


CREATE TABLE CLIENT(
  id SERIAL NOT NULL,
  prenom VARCHAR(100) NOT NULL,
  nom VARCHAR(100) NOT NULL,
  motdepasse VARCHAR(100) NOT NULL,
  sexe SEXE NOT NULL,
  email VARCHAR(100) NOT NULL,
  tel VARCHAR(20) NOT NULL,
  date_naissance DATE NOT NULL CHECK (date_naissance > '1900-01-01'),
  PRIMARY KEY (id),
  CONSTRAINT email_chk CHECK (((email)::text ~* '^[0-9a-zA-Z._-]+@[0-9a-zA-Z._-]{2,}[.][a-zA-Z]{2,4}$'::text))
);

CREATE TABLE TYPE_PRODUIT (
  ref_type_produit SERIAL NOT NULL,
  nom VARCHAR(100) NOT NULL,
  PRIMARY KEY(ref_type_produit)
);

CREATE TABLE COMMANDE(
  ref_commande SERIAL NOT NULL,
  date DATE NOT NULL,
  id_client INTEGER REFERENCES CLIENT(id) NOT NULL,
  PRIMARY KEY(ref_commande)
);

CREATE TABLE PRODUIT(
  ref_produit SERIAL NOT NULL,
  nom VARCHAR(100) NOT NULL,
  prix NUMERIC(6,2) NOT NULL,
  nb INTEGER NOT NULL,
  ref_type_produit INTEGER REFERENCES TYPE_PRODUIT(ref_type_produit) NOT NULL,
  PRIMARY KEY(ref_produit)
);

CREATE TABLE METHODE_PAIEMENT(
  ref_methode_paiement SERIAL NOT NULL,
  num_carte VARCHAR(100) NOT NULL,
  date_expiration DATE not null,
  code_carte VARCHAR(3) not null,
  type_carte CARTE not null,
  PRIMARY KEY(ref_methode_paiement)
);

CREATE TABLE COMMANDE_PAYEE(
  ref_commande INTEGER REFERENCES COMMANDE(ref_commande) NOT NULL,
  ref_methode_paiement INTEGER REFERENCES METHODE_PAIEMENT(ref_methode_paiement) NOT NULL,
  date_paiement DATE NOT NULL,
  PRIMARY KEY (ref_commande, ref_methode_paiement)
);

CREATE TABLE DETAILS_COMMANDE(
  ref_commande INTEGER REFERENCES COMMANDE(ref_commande) NOT NULL,
  ref_produit INTEGER REFERENCES PRODUIT(ref_produit) NOT NULL,
  nb_produit_commande INTEGER NOT NULL,
  PRIMARY KEY (ref_commande, ref_produit)
);

CREATE TABLE ADRESSE_LIVRAISON(
  ref_adresse_livraison SERIAL NOT NULL,
  num_rue VARCHAR(100) NOT NULL,
  nom_rue VARCHAR(100) NOT NULL,
  code_postal VARCHAR(5) NOT NULL,
  ville VARCHAR(100) NOT NULL,
  pays VARCHAR(100) NOT NULL,
  PRIMARY KEY (ref_adresse_livraison)
);

CREATE TABLE LIVRAISON (
  ref_livraison SERIAL NOT NULL,
  date_livraison DATE NOT NULL,
  ref_adresse INTEGER REFERENCES ADRESSE_LIVRAISON(ref_adresse_livraison) NOT NULL,
  ref_cde INTEGER REFERENCES COMMANDE(ref_commande) NOT NULL,
  PRIMARY KEY (ref_livraison)
);


-----------------------------------------------------------------------------
-- AJOUT DE DATA .
-----------------------------------------------------------------------------



insert into CLIENT (prenom, nom, motdepasse, sexe, email, tel, date_naissance) values ('Mélys', 'Mifflin', 'IrEDEe', 'Female', 'dmifflin0@cnbc.com', '+33 324 358 6379', '1983-12-29');
insert into CLIENT (prenom, nom, motdepasse, sexe, email, tel, date_naissance) values ('Méng', 'Stannis', 'lFwlePEo', 'Female', 'astannis1@livejournal.com', '+86 262 538 8666', '1992-12-08');
insert into CLIENT (prenom, nom, motdepasse, sexe, email, tel, date_naissance) values ('Ruì', 'Klaessen', 'Bc24amAVNwM', 'Male', 'hklaessen2@dedecms.com', '+351 247 324 9039', '1992-03-05');
insert into CLIENT (prenom, nom, motdepasse, sexe, email, tel, date_naissance) values ('Céline', 'Lightwing', '10FU4WFvgqE', 'Female', 'alightwing3@acquirethisname.com', '+33 559 405 2375', '1985-06-04');
insert into CLIENT (prenom, nom, motdepasse, sexe, email, tel, date_naissance) values ('Mélia', 'Brightwell', 'cNAF6CE6InpA', 'Male', 'sbrightwell4@mozilla.org', '+62 985 218 6368', '1913-05-16');
insert into CLIENT (prenom, nom, motdepasse, sexe, email, tel, date_naissance) values ('Esbjörn', 'Daouse', 'Jl3IQOZo', 'Male', 'cdaouse5@fda.gov', '+63 215 767 3537', '1916-06-28');
insert into CLIENT (prenom, nom, motdepasse, sexe, email, tel, date_naissance) values ('Félicie', 'Domokos', 'bIQ4zjt', 'Female', 'adomokos6@paypal.com', '+64 148 215 9466', '1957-07-04');
insert into CLIENT (prenom, nom, motdepasse, sexe, email, tel, date_naissance) values ('Marie-josée', 'Bickerdicke', 'yeEMWk', 'Male', 'ebickerdicke7@ed.gov', '+52 173 677 8517', '1935-03-09');


insert into TYPE_PRODUIT (nom) values ('Kellogs All Bran Bars');
insert into TYPE_PRODUIT (nom) values ('Spice - Peppercorn Melange');
insert into TYPE_PRODUIT (nom) values ('Flour - Strong Pizza');
insert into TYPE_PRODUIT (nom) values ('Hold Up Tool Storage Rack');
insert into TYPE_PRODUIT (nom) values ('Bagel - Everything Presliced');
insert into TYPE_PRODUIT (nom) values ('Coffee - French Vanilla Frothy');
insert into TYPE_PRODUIT (nom) values ('Rabbit - Legs');

insert into METHODE_PAIEMENT (num_carte, date_expiration, code_carte, type_carte) values ('3542967308315125', '2018-08-30', '006', 'jcb');
insert into METHODE_PAIEMENT (num_carte, date_expiration, code_carte, type_carte) values ('3550137548869047', '2018-05-11', '840', 'jcb');
insert into METHODE_PAIEMENT (num_carte, date_expiration, code_carte, type_carte) values ('374283526062740', '2018-01-12', '725', 'americanexpress');
insert into METHODE_PAIEMENT (num_carte, date_expiration, code_carte, type_carte) values ('5100173590046283', '2018-03-23', '282', 'mastercard');
insert into METHODE_PAIEMENT (num_carte, date_expiration, code_carte, type_carte) values ('3564141919221956', '2018-11-08', '279', 'jcb');
insert into METHODE_PAIEMENT (num_carte, date_expiration, code_carte, type_carte) values ('3569813255505649', '2018-01-22', '228', 'jcb');
insert into METHODE_PAIEMENT (num_carte, date_expiration, code_carte, type_carte) values ('3560515937038662', '2018-07-17', '179', 'jcb');


insert into PRODUIT (nom, prix, nb, ref_type_produit) values ('Collared lizard', 121.32, 500, 1);
insert into PRODUIT (nom, prix, nb, ref_type_produit) values ('Eagle, long-crested hawk',  12.32, 500, 2); 
insert into PRODUIT (nom, prix, nb, ref_type_produit) values ('Yellow-throated sandgrouse',  1.32, 50, 3);
insert into PRODUIT (nom, prix, nb, ref_type_produit) values ('Macaw, green-winged',  131.32, 500, 3);
insert into PRODUIT (nom, prix, nb, ref_type_produit) values ('Cat, long-tailed spotted',  121.32, 50, 1);
insert into PRODUIT (nom, prix, nb, ref_type_produit) values ('Black-backed magpie',15.32,12, 4); 
insert into PRODUIT (nom, prix, nb, ref_type_produit) values ('Sambar',  21.32, 500, 1);
insert into PRODUIT (nom, prix, nb, ref_type_produit) values ('Black-winged stilt', 21.32, 500, 2);
insert into PRODUIT (nom, prix, nb, ref_type_produit) values ('Gull, silver', 21.32, 5000, 1); 
insert into PRODUIT (nom, prix, nb, ref_type_produit) values ('Black rhinoceros', 21.32, 50, 1);


insert into ADRESSE_LIVRAISON (num_rue, nom_rue, code_postal, ville, pays) values ('01', 'Rue des chemins', '83000', 'Toulon', 'France');
insert into ADRESSE_LIVRAISON (num_rue, nom_rue, code_postal, ville, pays) values ('01', 'Rue des pietons', '83100', 'Toulonne', 'France');
insert into ADRESSE_LIVRAISON (num_rue, nom_rue, code_postal, ville, pays) values ('01', 'Rue des codes', '83300', 'Toulonyx', 'France');
insert into ADRESSE_LIVRAISON (num_rue, nom_rue, code_postal, ville, pays) values ('01', 'Rue des dylans', '83200', 'Toulonus', 'France');
insert into ADRESSE_LIVRAISON (num_rue, nom_rue, code_postal, ville, pays) values ('01', 'Rue des alazar', '83100', 'Toulona', 'France');



insert into COMMANDE (date, id_client) values ('2018-01-01', 1);
insert into COMMANDE (date, id_client) values ('2018-01-02', 2);
insert into COMMANDE (date, id_client) values ('2018-01-05', 3);
insert into COMMANDE (date, id_client) values ('2018-01-06', 6);
insert into COMMANDE (date, id_client) values ('2018-01-11', 5);
insert into COMMANDE (date, id_client) values ('2018-01-12', 1);
insert into COMMANDE (date, id_client) values ('2018-01-12', 2);


insert into DETAILS_COMMANDE (ref_commande, ref_produit, nb_produit_commande) values (1, 2, 1);
insert into DETAILS_COMMANDE (ref_commande, ref_produit, nb_produit_commande) values (1, 1, 2);
insert into DETAILS_COMMANDE (ref_commande, ref_produit, nb_produit_commande) values (1, 3, 5);
insert into DETAILS_COMMANDE (ref_commande, ref_produit, nb_produit_commande) values (1, 4, 4);
insert into DETAILS_COMMANDE (ref_commande, ref_produit, nb_produit_commande) values (2, 2, 3);
insert into DETAILS_COMMANDE (ref_commande, ref_produit, nb_produit_commande) values (2, 1, 1);

insert into LIVRAISON (date_livraison, ref_adresse,ref_cde) values ('2018-02-12',1, 1);
insert into LIVRAISON (date_livraison, ref_adresse,ref_cde) values ('2018-02-13',2, 2);
insert into LIVRAISON (date_livraison, ref_adresse,ref_cde) values ('2018-02-14',3, 3);
insert into LIVRAISON (date_livraison, ref_adresse,ref_cde) values ('2018-02-15',3, 4);

insert into COMMANDE_PAYEE (ref_commande, ref_methode_paiement,date_paiement) values (1, 1, '2018-02-07');
insert into COMMANDE_PAYEE (ref_commande, ref_methode_paiement,date_paiement) values (2, 1, '2018-02-08');
insert into COMMANDE_PAYEE (ref_commande, ref_methode_paiement,date_paiement) values (3, 3, '2018-02-08');
insert into COMMANDE_PAYEE (ref_commande, ref_methode_paiement,date_paiement) values (6, 6, '2018-02-09');





-----------------------------------------------------------------------------
-- AJOUT DE FONCTIONS.
-----------------------------------------------------------------------------

-- Liste des identifiants de tous les clients
CREATE OR REPLACE FUNCTION get_clients_ids()
 RETURNS SETOF INTEGER AS 
$$
    SELECT id FROM CLIENT;
$$
LANGUAGE SQL;

-- Liste des identifiants des clients qui ont commandé à une certaine date
CREATE OR REPLACE FUNCTION get_clients_commande_date(xdate DATE)
returns SETOF INTEGER as 
$$
  SELECT ID FROM CLIENT 
  INNER JOIN COMMANDE
  ON CLIENT.ID = COMMANDE.ID_CLIENT
  WHERE COMMANDE.DATE = xdate;
$$
LANGUAGE SQL;

-- Liste identifiants des commandes qui n'ont pas encore été payées
CREATE OR REPLACE FUNCTION get_commandes_non_payees()
returns SETOF INTEGER as 
$$
SELECT REF_COMMANDE FROM COMMANDE
WHERE REF_COMMANDE NOT IN (SELECT REF_COMMANDE FROM COMMANDE_PAYEE);
$$
LANGUAGE SQL;

-- Liste identifiants des commandes qui n'ont pas encore été payées
CREATE OR REPLACE FUNCTION get_commandes_non_livrees()
returns SETOF INTEGER as 
$$
SELECT REF_COMMANDE FROM COMMANDE
WHERE REF_COMMANDE NOT IN (SELECT REF_COMMANDE FROM LIVRAISON);
$$
LANGUAGE SQL;


-- Liste noms de produits commandés par un client en particulier
CREATE OR REPLACE FUNCTION get_nom_produit_commandes_par(xid INTEGER)
returns SETOF TEXT as 
$$
SELECT PRODUIT.NOM FROM CLIENT
INNER JOIN COMMANDE ON
CLIENT.ID = COMMANDE.ID_CLIENT
INNER JOIN DETAILS_COMMANDE
ON COMMANDE.REF_COMMANDE = DETAILS_COMMANDE.REF_COMMANDE
INNER JOIN PRODUIT 
ON DETAILS_COMMANDE.REF_PRODUIT = PRODUIT.REF_PRODUIT
WHERE CLIENT.ID = xid;
$$
LANGUAGE SQL;


-- LE CLIENT LE PLUS FIDELE
CREATE OR REPLACE FUNCTION get_client_fidele()
returns SETOF INTEGER as 
$$
SELECT CLIENT.ID FROM CLIENT 
INNER JOIN
COMMANDE ON CLIENT.ID = COMMANDE.ID_CLIENT
INNER JOIN COMMANDE_PAYEE 
ON COMMANDE.REF_COMMANDE = COMMANDE_PAYEE.REF_COMMANDE
GROUP BY CLIENT.ID
HAVING COUNT(*) =
(SELECT MAX(C) FROM (SELECT COUNT(*) AS C 
  FROM CLIENT 
  INNER JOIN
  COMMANDE ON CLIENT.ID = COMMANDE.ID_CLIENT
  INNER JOIN COMMANDE_PAYEE 
  ON COMMANDE.REF_COMMANDE = COMMANDE_PAYEE.REF_COMMANDE
  GROUP BY CLIENT.ID) t);
$$
LANGUAGE SQL;





-- Trigger reduce nb Stock
  CREATE OR REPLACE FUNCTION REDUCE_NB_PRODUCT()
  RETURNS trigger 
  LANGUAGE PLPGSQL
  as 
  $BODY$
  DECLARE nb INTEGER := false;
  BEGIN
  nb := (SELECT NB FROM PRODUIT WHERE REF_PRODUIT = NEW.REF_PRODUIT);
  IF nb > -100 THEN
    UPDATE PRODUIT SET NB = NB + -1 WHERE PRODUIT.REF_PRODUIT = NEW.REF_PRODUIT;    
  END IF;
  END;
  $BODY$;
----
CREATE TRIGGER REDUCE_NB_PRODUCT_TRG
AFTER INSERT 
ON DETAILS_COMMANDE
FOR EACH ROW
EXECUTE PROCEDURE REDUCE_NB_PRODUCT();




-- Stats le produit le plus acheté depuis un certain Pays


SELECT max(DETAILS_COMMANDE.NB_PRODUIT_COMMANDE)
FROM DETAILS_COMMANDE INNER JOIN PRODUIT
ON DETAILS_COMMANDE.REF_PRODUIT = PRODUIT.REF_PRODUIT
INNER JOIN LIVRAISON 
ON DETAILS_COMMANDE.REF_COMMANDE = LIVRAISON.REF_CDE
INNER JOIN ADRESSE_LIVRAISON
ON LIVRAISON.REF_ADRESSE= ADRESSE_LIVRAISON.REF_ADRESSE_LIVRAISON
GROUP BY NB_PRODUIT_COMMANDE, ville
HAVING ville like 'Toulon';





