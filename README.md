# SQL-database-creation
Conception de bases de données SQL avec MySQL dans un environnement de développement VS Code

**Conception et Requêtage de Base de Données SQL - Projet Laplace Immo**

**Description**
Ce projet est un Proof of Concept réalisé pour Laplace Immo, un réseau national d’agences immobilières. Il vise à concevoir et exploiter une base de données SQL pour analyser le marché immobilier.

**Structure du Projet**

**1-Collecte et Structure des Données**
Données communes (codes régionaux, départementaux, communaux)
Données de référence géographiques
Données de valeur foncière (prix, surface, type de bien, transactions)

**2-Implémentation de la Base SQL**

**Création du schéma relationnel normalisé et des tables principales :**
Région : Stocke les informations des régions
Commune : Stocke les informations des communes
Bien : Stocke les informations des biens immobiliers
Vente : Stocke les transactions immobilières

**3️-Analyse du Marché Immobilier via SQL**

Requêtes SQL permettant :
Nombre total d’appartements vendus sur une période donnée
- Classement des régions par nombre de ventes
- Proportion des ventes par type de bien
- Classement des départements par prix au m²
- Évolution du marché immobilier

**Technologies Utilisées**

SQL (création de bases, requêtes analytiques)
SGBD : MySQL avec VSCODE
Data Cleaning & Normalisation
 
**Résultats et Insights**
Identification des régions et communes les plus dynamiques
Analyse des tendances du marché immobilier
Segmentation par prix, type de bien et localisation
