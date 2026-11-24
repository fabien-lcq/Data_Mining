/* Importation du dataset du problème 1 */
filename lasvegas temp;

proc http
    url="https://raw.githubusercontent.com/fabien-lcq/Data_Mining/main/LasVegasTripAdvisorReviews-Dataset.csv"
    method="GET"
    out=lasvegas;/* Importation du dataset du problème 1 */
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

proc contents data=lasvegas;
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

Hotel name/Hotel stars/Nr.rooms -> Nom, nombre d'étoiles(3,4,5) et nombre de chambre
de l'hôtel.

Member years -> ancienneté de l'utilisateur sur TripAdvisor.
*/


/* Petit changement sur la variable Periode of stay
	->pour améliorer la visiblité, on passe de :
	Dec-Feb à Winter par exemple   */
proc format;
value $saison
"Dec-Feb"="Winter"
"Mar-May"="Spring"
"Jun-Aug"="Summer"
"Sep-Nov"="Fall";
run;

data lasvegas;
set lasvegas;
format 'Period of stay'n saison. ;
run;
/* Etude de la correlation des variables qualitatives */
proc corresp data=lasvegas  mca;
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


/* Avant de continuer nos études changeons les YES et NO pour mieux lire les resultats*/
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


/* Application de nos format */
data lasvegas;
set lasvegas;
format Pool pool.;
format Gym gym.;
format 'Tennis court'n tennis.;
format SPA spa. ;
format Casino casino.;
format 'Free internet'n wifi.;
run;

/* Peut on voir une correlation entre les differentes variables binaires
et le nombre d'étoiles d'un hôtel ?*/ 

proc corresp data=lasvegas observed mca ;
title "Etude du lien entre les equipements et le nombre d'étoiles d'un hôtel";
tables 'Hotel stars'n
Pool Gym 'Tennis court'n Spa Casino 
'Free internet'n;
run;
/* Les terrains de tennis sont interresant -> A DEVELOPPER */










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
run;

proc import
    datafile=lasvegas
    out=work.lasvegas
    dbms=csv
    replace;
    delimiter=";";
    guessingrows=max;
run;

proc contents data=lasvegas;
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

Hotel name/Hotel stars/Nr.rooms -> Nom, nombre d'étoiles et nombre de chambre
de l'hôtel.

Member years -> ancienneté de l'utilisateur sur TripAdvisor.
*/

/* Etude de la correlation des variables qualitatives */
proc corresp data=lasvegas  mca;
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

/* Peut on voir une correlation entre les differentes variables binaires
et le nombre d'étoiles d'un hôtel*/

proc corresp data=lasvegas observed mca;
tables 'Hotel stars'n
Pool Gym 'Tennis court'n Spa Casino 
'Free internet'n;
run;
/* On va devoir changer les YES et NO pour mieux lire les resultats*/






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
