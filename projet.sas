/* Importation du dataset du problème 1 */
filename lasvegas temp;

proc http
    url="https://raw.githubusercontent.com/fabien-lcq/Data_Mining/main/LasVegasTripAdvisorReviews-Dataset.csv"
    method="GET"
    out=lasvegas;
run;

proc import
    datafile=lasvegas
    out=work.lasvegas
    dbms=csv
    replace;
    delimiter=";";
    guessingrows=max;
run;

proc contents data=lasvegas ;
run;

/* Description des variables

User country/User continent ->pays et continent de l'utilisateur

Review month/Review weekday -> Mois et Jour de publication de l'avis

Nr. reviews/Nr. hotel reviews ->Nombre total d'avis et nombre d'avis
d'hôtels par un utilisateur

Helpful votes -> nombre de vote utiles recu pour l'avis

Score -> note attribuée à l'hôtel

Period of stay -> Periode du séjour de l'utilisateur

Traveler type -> Type de voyageur(Solo,Business...)

Pool/Gym/Tennis court/Spa/Casino/Free internet -> Variables binaires
concernant la présence ou non des éléments ci-dessus.

Hotel name/Hotel stars/Nr.rooms -> Nom, nombre d'étoiles(3,3.5,4,4.5,5) et nombre de chambre
de l'hôtel.
Attention pour hotel stars des valeurs numériques sont présentes mais arrondi à l'affichage

Member years -> ancienneté de l'utilisateur sur TripAdvisor.
*/




/* Etude de la correlation des variables qualitatives */
proc corresp data=lasvegas  mca noprint;
tables 
'User country'n 
'User continent'n
'Period of stay'n 
'Traveler type'n
'Hotel stars'n
Score
Pool Gym 'Tennis court'n Spa Casino 
'Free internet'n
'Hotel name'n
;
run;
/* La statistique de test vaut 65 130 et on observe une chi2 à 
10 404 degrés de liberté.
Le fractile (seuil de 5%) vaut 10 642.
Clairement on rejette l'hypothèse H0"les variables sont indépendantes"
Reste à étudier les correlations de manière plus specifique
*/

/* Avant de continuer nos études changeons certaines variables pour mieux lire les resultats*/
/* 1-Variables binaires*/
proc format;
value $pool
"YES"="YES_POOL"
"NO"="NO_POOL";
run;

proc format;
value $gym
"YES"="YES_GYM"
"NO"="NO_GYM";
run;

proc format;
value $tennis
"YES"="YES_TENNIS"
"NO"="NO_TENNIS";
run;

proc format;
value $spa
"YES"="YES_SPA"
"NO"="NO_SPA";
run;

proc format;
value $casino
"YES"="YES_CASINO"
"NO"="NO_CASINO";
run;

proc format;
value $wifi
"YES"="YES_WIFI"
"NO"="NO_WIFI";
run;

/*2-Saison*/
proc format;
value $saison
"Dec-Feb"="Winter"
"Mar-May"="Spring"
"Jun-Aug"="Summer"
"Sep-Nov"="Fall";
run;

/*3-Nombres d'étoiles d'un hôtel*/
/*proc format;
value etoiles
3="3-s"
3.5="3.5-s"
4="4-s"
4.5="4.5-s"
5="5-s";
run;
/* s pour star */

/* Application de nos formats */
data lasvegas;
set lasvegas;
format Pool pool.;
format Gym gym.;
format 'Tennis court'n tennis.;
format SPA spa. ;
format Casino casino.;
format 'Free internet'n wifi.;
format 'Period of stay'n saison. ;
run;

/* Peut on voir une correlation entre les differentes equipements 
et le nombre d'étoiles d'un hôtel ?*/ 

proc corresp data=lasvegas observed mca ;
title "Etude du lien entre les equipements et le nombre d'étoiles d'un hôtel";
tables 'Hotel stars'n
Pool Gym 'Tennis court'n Spa Casino 
'Free internet'n;
run;
/* CORRELATION DES VARIABLES*/

/* La statistique de test vaut 5478 et on observe une chi2 à 
196 degrés de liberté.
Le fractile (seuil de 5%) vaut 165.
Clairement on rejette l'hypothèse H0"les variables sont indépendantes"
*/

/*INTERPRETATION */

/* Les terrains de tennis sont interresant en effet, la plupart des 
hôtels 5 étoiles n'ont pas de terrain de tennis:
89% des 5 étoiles
62% des 4 étoiles
75% des 3 étoiles
Cette caractéristique ne semblent pas etre influente dans le nombre d'étoiles d'un hôtel.

Le wifi est présent dans tous les hôtels sauf certains 4 étoiles difficile de faire une conclusion
sur ce sujet(les exceptions pourraient etre expliquées par l'aspect géographique, la politique interne...).

Pour le reste les resultats sont plutot cohérent:
Les 3 étoiles sont les hôtels possédant globalement le moins d'équipements.
Les 5 étoiles sont les hôtels possédant globalement le plus d'équipements, les differences
avec les 4 étoiles sont surtout au niveau des spa et des casinos.
Ces derniers sont plus présent dans les 5 étoiles.
 */


/* recomencons une étude similaire mais pour étudier
le lien entre equipements d'un hôtel et satisfaction clients*/

proc corresp data=lasvegas observed mca ;
title "Etude du lien entre les equipements et le nombre d'étoiles d'un hôtel";
tables Score
Pool Gym 'Tennis court'n Spa Casino 
'Free internet'n;
run;
/* CORRELATION DES VARIABLES*/

/* La statistique de test vaut 5933 et on observe une chi2 à 
256 degrés de liberté.
Le fractile (seuil de 5%) vaut 219.
Clairement on rejette l'hypothèse H0"les variables sont indépendantes"
*/

/*INTERPRETATION */

/* De nouveau les terrains de tennis n'est pas influente dans la note donnée à un hôtel.

Les notes les plus mauvaises (1 et 2) sont grandement influencées par l'absence des equipements.
De la meme maniere les meuilleurs notes(4 et 5)sont grandement influencées par la présence des equipements.

Il est plus difficile d'expliquer la note de 3, en effet pour passer de 2 à 3
la présence d'équipements est significativement plus importante.
Mais pour passer de 3 à 4 il est difficile avec ces variables de donner une raison.
Par exemple 90% des avis 3 concernent des hôtels avec piscine contre 94% pour les 4.
Et ce schéma se répétent pour toutes les caractéristiques.
Ainsi, les équipements semblent permettre de distinguer les expériences très négatives des expériences plus positives,
mais ils ne suffisent pas à expliquer les différences entre les niveaux de satisfaction intermédiaires et élevés.





/*-----------------------------------------------------------------------------------*/
/* Importation du dataset du problème 2 */
filename wholesal temp;

proc http
    url="https://raw.githubusercontent.com/fabien-lcq/Data_Mining/main/Wholesalecustomersdata.csv"
    method="GET"
    out=wholesal;
run;

proc import
    datafile=wholesal
    out=work.wholesale
    dbms=csv
    replace;
    guessingrows=max;
run;

proc contents data=wholesale;
run;
/*-----------------------------------------------------------------------------------*/
/* Importation du dataset du problème 3 */
filename iono temp;

proc http
    url="https://raw.githubusercontent.com/fabien-lcq/Data_Mining/main/ionosphere.data"
    method="GET"
    out=iono;
run;

data work.ionosphere;
    infile iono dlm=',';
    input V1-V34 target $;
    /* V1-V34 -> variables numériques et continues
    	target -> variable binaire "good" ou "bad"
    	*/
run;


proc contents data=ionosphere;
run;
