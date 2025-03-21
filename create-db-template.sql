CREATE DATABASE immobilier;
USE immobilier;

-- Table Region
CREATE TABLE Region (
    Id_region INTEGER UNSIGNED NOT NULL PRIMARY KEY,
    Nom_Region VARCHAR(50) NOT NULL,
    Nom_regroup VARCHAR(50) NOT NULL
);

-- Table Commune
CREATE TABLE Commune (
    id_codedep_codecommune VARCHAR(50) NOT NULL PRIMARY KEY,
    Id_region INTEGER UNSIGNED NOT NULL,
    Code_departement VARCHAR(10) NOT NULL,
    Code_commune INTEGER UNSIGNED NOT NULL,
    Nom_commune VARCHAR(50) NOT NULL,
    Nbre_habitant_2019 INTEGER UNSIGNED NOT NULL,
    FOREIGN KEY (Id_region) REFERENCES Region(Id_region)
);

-- Table Bien
CREATE TABLE Bien (
    Id_bien INTEGER UNSIGNED NOT NULL PRIMARY KEY,
    id_codedep_codecommune VARCHAR(50) NOT NULL,
    No_voie VARCHAR (50) DEFAULT '',
    BTQ VARCHAR(1) DEFAULT '',
    Type_voie VARCHAR(4) DEFAULT '',
    Voie VARCHAR(50) DEFAULT '',
    Total_piece INTEGER UNSIGNED,
    Surface_carrez FLOAT UNSIGNED,
    Surface_local INTEGER UNSIGNED,
    Type_local VARCHAR(50),
    FOREIGN KEY (id_codedep_codecommune) REFERENCES Commune(id_codedep_codecommune)
);

-- Table Vente
CREATE TABLE Vente (
    Id_vente INTEGER UNSIGNED NOT NULL PRIMARY KEY,
    Id_bien INTEGER UNSIGNED NOT NULL,
    Date DATE NOT NULL,
    Valeur INTEGER UNSIGNED,
    FOREIGN KEY (Id_bien) REFERENCES Bien(Id_bien)
);

-- Step 1: Modify the Id_region column in the commune table to BIGINT

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/vente.csv'
INTO TABLE vente
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/region.csv'
INTO TABLE region
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/commune.csv'
INTO TABLE commune
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bien.csv'
INTO TABLE bien
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/vente.csv'
INTO TABLE vente
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS

/*REQUETES*/

-----------QUESTION 1 : Nombre total d’appartements vendus au 1er semestre 2020.-------------
SELECT COUNT(*) AS Nb_appartements_vendus
FROM vente v
JOIN bien b ON v.Id_bien = b.Id_bien
WHERE v.Date BETWEEN '2020-01-01' AND '2020-06-30'
AND b.Type_local = 'Appartement';

------------QUESTION 2 : Le nombre de ventes d’appartement par région pour le 1er semestre 2020----
SELECT r.Nom_region, COUNT(*) AS Nb_ventes
FROM vente v
JOIN bien b ON v.Id_bien = b.Id_bien
JOIN commune c ON b.id_codedep_codecommune = c.id_codedep_codecommune
JOIN region r ON c.Id_region = r.Id_region
WHERE v.Date BETWEEN '2020-01-01' AND '2020-06-30'
AND b.Type_local = 'Appartement'
GROUP BY r.Nom_region
ORDER BY Nb_ventes DESC;

----------QUESTION 3 : Proportion des ventes d’appartements par le nombre de pièces----------
SELECT b.Total_piece, COUNT(*) * 100.0 / (SELECT COUNT(*) FROM vente v JOIN bien b ON v.Id_bien = b.Id_bien
WHERE b.Type_local = 'Appartement') AS Proportion
FROM vente v
JOIN bien b ON v.Id_bien = b.Id_bien
WHERE b.Type_local = 'Appartement'
GROUP BY b.Total_piece
ORDER BY Total_piece ASC;

--------QUESTION 4: Liste des 10 départements où le prix du mètre carré est le plus élevé-----
SELECT c.Code_departement, AVG(v.Valeur / b.Surface_carrez) AS Prix_m2
FROM vente v
JOIN bien b ON v.Id_bien = b.Id_bien
JOIN commune c ON b.id_codedep_codecommune = c.id_codedep_codecommune
WHERE b.Surface_carrez > 0
GROUP BY c.Code_departement
ORDER BY Prix_m2 DESC
LIMIT 10;

------------QUESTION 5 : Prix moyen du mètre carré d’une maison en Île-de-France----------------
SELECT AVG(v.Valeur / b.Surface_carrez) AS prix_m2_moyen
FROM vente v
JOIN bien b ON v.Id_bien = b.Id_bien
JOIN commune c ON b.Id_codedep_codecommune = c.Id_codedep_codecommune
JOIN region r ON c.Id_region = r.Id_region
WHERE b.Type_local = 'maison'
AND r.Nom_Region = 'Île-de-France';

----------Question 6---------------------------

SELECT b.Id_bien, v.Valeur, b.Surface_carrez, r.Nom_region
FROM vente v
JOIN bien b ON v.Id_bien = b.Id_bien
JOIN Commune c ON b.id_codedep_codecommune = c.id_codedep_codecommune
JOIN region r ON c.Id_region = r.Id_region
WHERE b.Type_local = 'Appartement'
ORDER BY v.Valeur DESC
LIMIT 10;

--Question7 :----------------------------
SELECT
  (COUNT(CASE WHEN v.Date BETWEEN '2020-04-01' AND '2020-06-30' THEN 1 END) * 100) /
  COUNT(CASE WHEN v.Date BETWEEN '2020-01-01' AND '2020-03-31' THEN 1 END) AS Evolution
FROM vente v
WHERE v.Date BETWEEN '2020-01-01' AND '2020-06-30';

--Question 8 :
SELECT r.Nom_region, AVG(v.Valeur / b.Surface_carrez) AS Prix_m2
FROM vente v
JOIN bien b ON v.Id_bien = b.Id_bien
JOIN commune c ON b.id_codedep_codecommune = c.id_codedep_codecommune
JOIN region r ON c.Id_region = r.Id_region
WHERE b.Type_local = 'Appartement'
AND b.Total_piece > 4
AND b.Surface_carrez > 0
GROUP BY r.Nom_region
ORDER BY Prix_m2 DESC;

--Question9 :

SELECT c.Nom_commune, COUNT(*) AS Nb_ventes
FROM vente v
JOIN bien b ON v.Id_bien = b.Id_bien
JOIN commune c ON b.id_codedep_codecommune = c.id_codedep_codecommune
WHERE v.Date BETWEEN '2020-01-01' AND '2020-03-31'
GROUP BY c.Nom_commune
HAVING COUNT(*) >= 50;

--Question 10 :

WITH Prix_2_pieces AS (
  SELECT AVG(v.Valeur / b.Surface_carrez) AS Prix_m2_2_pieces
  FROM vente v
  JOIN bien b ON v.Id_bien = b.Id_bien
  WHERE b.Type_local = 'Appartement' AND b.Total_piece = 2 AND b.Surface_carrez > 0
),
Prix_3_pieces AS (
  SELECT AVG(v.Valeur / b.Surface_carrez) AS Prix_m2_3_pieces
  FROM vente v
  JOIN bien b ON v.Id_bien = b.Id_bien
  WHERE b.Type_local = 'Appartement' AND b.Total_piece = 3 AND b.Surface_carrez > 0
)
SELECT
  ((Prix_3_pieces.Prix_m2_3_pieces - Prix_2_pieces.Prix_m2_2_pieces) / Prix_2_pieces.Prix_m2_2_pieces) * 100 AS Diff_percentage
FROM Prix_2_pieces, Prix_3_pieces;

----Question11:----------

SELECT 
    c.Code_departement, 
    c.Nom_commune, 
    AVG(v.Valeur) AS Moyenne_valeur_fonciere
FROM 
    Vente v
JOIN 
    Bien b ON v.Id_bien = b.Id_bien
JOIN 
    Commune c ON b.id_codedep_codecommune = c.id_codedep_codecommune
WHERE 
    c.Code_departement IN ('06', '13', '33', '59', '69')
GROUP BY 
    c.Code_departement, c.Nom_commune
ORDER BY 
    Moyenne_valeur_fonciere DESC
LIMIT 3;


--Question12 :

SELECT c.Nom_commune, COUNT(*) * 1000.0 / c.Nbre_habitant_2019 AS Transactions_par_1000_habitants
FROM vente v
JOIN bien b ON v.Id_bien = b.Id_bien
JOIN commune c ON b.id_codedep_codecommune = c.id_codedep_codecommune
WHERE c.Nbre_habitant_2019 > 10000
GROUP BY c.Nom_commune, c.Nbre_habitant_2019
ORDER BY Transactions_par_1000_habitants DESC
LIMIT 20;

