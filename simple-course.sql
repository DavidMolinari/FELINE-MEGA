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



-----------------------------------------------------------------------------
-- Initialize the structure.
-----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;


CREATE TABLE CLIENT (
  id SERIAL NOT NULL,
  prenom INTEGER NOT NULL,
  nom INTEGER NOT NULL,
  motdepasse VARCHAR(100) NOT NULL,
  sexe { "Homme", "Femme", "Autre"} NOT NULL,
  tel VARCHAR(10) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT email_chk CHECK (((email)::text ~* '^[0-9a-zA-Z._-]+@[0-9a-zA-Z._-]{2,}[.][a-zA-Z]{2,4}$'::text))
)

CREATE TABLE TYPE_PRODUIT(
  ref_type_produit SERIAL NOT NULL,
  nom VARCHAR(100) NOT NULL
)

CREATE TABLE COMMANDE(
  ref_commande SERIAL NOT NULL,
  date DATE NOT NULL,
  id_client INTEGER REFERENCES CLIENT(id),
  PRIMARY KEY(ref_commande)
)

CREATE TABLE PRODUIT(
  ref_produit SERIAL NOT NULL,
  nom VARCHAR(100) NOT NULL,
  prix NUMERIC(6,2) NOT NULL,
  nb INTEGER NOT NULL,
  ref_type_produit INTEGER REFERENCES TYPE_PRODUIT(ref_type_produit),
  PRIMARY KEY(ref_produit)
)

CREATE TABLE METHODE_PAIEMENT(
  ref_methode_paiement SERIAL NOT NULL,
  num_carte VARCHAR(100) NOT NULL,
  date_expiration DATE not null,
  code_carte VARCHAR(3) not null,
  PRIMARY KEY(ref_methode_paiement)
)

CREATE TABLE COMMANDE_PAYEE(
  ref_commande INTEGER REFERENCES COMMANDE(ref_commande),
  ref_methode_paiement INTEGER REFERENCES METHODE_PAIEMENT(ref_methode_paiement),
  date_paiement DATE NOT NULL,
  PRIMARY KEY (ref_commande, ref_methode_paiement)
)
CREATE TABLE DETAILS_COMMANDE(
  ref_commande INTEGER REFERENCES COMMANDE(ref_commande),
  ref_produit INTEGER REFERENCES PRODUIT(ref_produit),
  nb_produit_commande INTEGER NOT NULL
)

CREATE TABLE ADRESSE_LIVRAISON(
  ref_adresse_livraison SERIAL NOT NULL,
  num_rue VARCHAR(4) NOT NULL,
  nom_rue VARCHAR(100) NOT NULL,
  code_postal VARCHAR(5) NOT NULL,
  ville VARCHAR(100) NOT NULL,
  pays VARCHAR(100) NOT NULL,
  PRIMARY KEY (ref_adresse_livraison)
)

CREATE TABLE LIVRAISON (
  ref_livraison SERIAL NOT NULL,
  date_livraison DATE NOT NULL,
  ref_adresse_livraison REFERENCES ADRESSE_LIVRAISON(ref_adresse_livraison)
)
