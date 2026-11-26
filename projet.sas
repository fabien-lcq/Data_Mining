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

Helpful votes -> nombre de vote utiles reçus pour l'avis

Score -> note attribuée à l'hôtel

Period of stay -> Période du séjour de l'utilisateur

Traveler type -> Type de voyageur (Solo,Business...)

Pool/Gym/Tennis court/Spa/Casino/Free internet -> Variables binaires
concernant la présence ou non des éléments ci-dessus.

Hotel name/Hotel stars/Nr.rooms -> Nom, nombre d'étoiles(3,3.5,4,4.5,5) et nombre de chambres
de l'hôtel.
Attention, pour hotel stars des valeurs numériques sont présentes mais arrondies à l'affichage

Member years -> ancienneté de l'utilisateur sur TripAdvisor.
*/




/* Étude de la corrélation des variables qualitatives */
proc corresp data=lasvegas  mca noprint;
title "Première étude avec l'ensemble des variables qualitatives";
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
Le fractile (seuil à 5%) vaut 10 642.
Clairement, on rejette l'hypothèse H0"les variables sont indépendantes"
Reste à étudier les corrélations de manière plus spécifique
*/

/* Avant de continuer nos études, changeons certaines variables pour mieux lire les résultats*/

/* 1 - Variables binaires*/
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

/*2 - Saison*/
proc format;
value $saison
"Dec-Feb"="Winter"
"Mar-May"="Spring"
"Jun-Aug"="Summer"
"Sep-Nov"="Fall";
run;

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

/* Peut-on voir une corrélation entre les différentes équipements 
et le nombre d'étoiles d'un hôtel ?*/ 

proc corresp data=lasvegas observed mca ;
title "Etude du lien entre les équipements et le nombre d'étoiles d'un hôtel.";
tables 'Hotel stars'n
Pool Gym 'Tennis court'n Spa Casino 
'Free internet'n;
run;
/* CORRELATION DES VARIABLES*/

/* La statistique de test vaut 5478 et on observe une chi2 à 
196 degrés de liberté.
Le fractile (seuil à 5%) vaut 165.
Clairement, on rejette l'hypothèse H0"les variables sont indépendantes"
*/

/*INTERPRÉTATION */

/* Les terrains de tennis sont intérresant en effet, la plupart des 
hôtels 5 étoiles n'ont pas de terrain de tennis:
89% des 5 étoiles
62% des 4 étoiles
75% des 3 étoiles
Cette caractéristique ne semblent pas etre influente dans le nombre d'étoiles d'un hôtel.

Le wifi est présent dans tous les hôtels sauf certains 4 étoiles difficile de faire une conclusion
sur ce sujet(les exceptions pourraient être expliquées par l'aspect géographique, la politique interne...).

Pour le reste, les résultats sont plutôt cohérents:
Les 3 étoiles sont les hôtels possédant globalement le moins d'équipements.
Les 5 étoiles sont les hôtels possédant globalement le plus d'équipements, les différences
avec les 4 étoiles sont surtout au niveau des spas et des casinos.
Ces derniers sont plus présents dans les 5 étoiles.
 */


/* Recomençons une étude similaire, mais pour étudier
le lien entre équipements d'un hôtel et la satisfaction des clients*/

proc corresp data=lasvegas observed mca ;
title "Etude du lien entre les équipements et la satisfaction des clients.";
tables Score
Pool Gym 'Tennis court'n Spa Casino 
'Free internet'n;
run;
/* CORRELATION DES VARIABLES*/

/* La statistique de test vaut 5933 et on observe une chi2 à 
256 degrés de liberté.
Le fractile (seuil à 5%) vaut 219.
Clairement, on rejette l'hypothèse H0"les variables sont indépendantes"
*/

/*INTERPRÉTATION */

/* De nouveau, les terrains de tennis ne sont pas influents dans la note donnée à un hôtel.

Les notes les plus mauvaises (1 et 2) sont grandement influencées par l'absence des équipements.
De la même maniere, les meilleures notes (4 et 5) sont grandement influencées par la présence des équipements.

Il est plus difficile d'expliquer la note de 3, en effet pour passer de 2 à 3
la présence d'équipements est significativement plus importante.
Mais pour passer de 3 à 4 il est difficile avec ces variables de donner une raison.
Par exemple 90 % des avis 3 concernent des hôtels avec piscine contre 94 % pour les 4.
Et ce schéma se répète pour toutes les caractéristiques.
Ainsi, les équipements semblent permettre de distinguer les expériences très négatives des expériences plus positives,
mais ils ne suffisent pas à expliquer les différences entre les niveaux de satisfaction intermédiaires et élevés.



/* On vient de terminer deux études portant davantage sur les hôtels.
Effectuons maintenant une troisième analyse qui sera plus centrée sur les voyageurs*/



/* On souhaite tester si les voyageurs de différents types, venant de différents continents ont des habitudes
particulières concernant leur saison de voyage */

proc corresp data=lasvegas  observed mca;
tables 'User continent'n
'Period of stay'n 
'Traveler type'n;
run;

/* CORRELATION DES VARIABLES*/

/* La statistique de test vaut 6181 et on observe une chi2 à 
196 degrés de liberté.
Le fractile (seuil à 5%) vaut 165.
Clairement, on rejette l'hypothèse H0"les variables sont indépendantes"
*/


/*INTERPRÉTATION */

/* Rien de bien intéressant à dire pour l'instant
   A voir si 3 études c'est important ou juste les deux d'avant
   c'est okay.*/










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

/* Description des variables
Pour la suite (m.u.) signifie monnaie unitaire.
Fresh: Dépense annuelle (m.u.) en produits frais 
Milk: Dépense annuelle (m.u.)  en produits laitiers 
Grocery: Dépense annuelle (m.u.)en produits alimentaires (secs, emballés) 
Frozen: Dépense annuelle (m.u.) en produits congelés 
Detergents_paper: Dépense annuelle (m.u.) en produits d'entretien(ménage, hygiène)
Delicassen: Dépense annuelle (m.u.) en  produits traiteur/haut de gamme  

CHANNEL: canal de distribution -> 1 pour Hôtel, Restaurent, Café ...
								  2 pour Commerce, Supermarché, Epiceries ...
								  
REGION: Région du client ->1 Lisbonne
						   2 Oporto (Porto)
						   3 Autre région
*/

/*QUESTION 1:Peut on réduire le nombre de variables numériques ? */

proc princomp data=wholesale out=a plots(ncomp=2)=(pattern(circles=1.0) score);
var Fresh Milk Grocery Frozen Detergents_paper Delicassen;
title "ACP sur les dépenses annuelles.";
run;

/* On explique 72% de la variablité totale avec 2 CP
donc on peut réduire le nombre de variables numériques
en utilisant ces deux composantes principales. */

/* QUESTION 2: Quelles sont les relations entre les variables numériques ? */
proc corr data=a;
var Fresh Milk Grocery Frozen Detergents_paper Delicassen
prin1 prin2;
title"Correlation entre var initiales et les 2 premières comp principales";
run;



/* Milk, Grocery et Detergents_paper sont  fortement correlés à l'axe 1
   Fresh et Frozen sont  fortement correlés à l'axe 2
   Petit précison: Delicassen est modérémment correlé à l'axe 2
*/

/* On obtient donc deux groupes:
Le premier comprend les produits laitiers, alimentaires et d'entretien.
Le second comprend les produits frais, surgelés et traiteur. 
*/

/* QUESTION 3:Caractérisez les variables Channel, Region . */

proc plot data=a;
title" ";
plot prin2*prin1="* " $Channel;
plot prin2*prin1="*" $Region;
run;


/*INTERPRÉTATION */

/* Pour le premier graphique:

Les produits frais, surgelés et traiteur semblent être principalement
distribués par les hôtels, Restaurants, Cafés.
Les autres produits donc laitiers, alimentaires et d'entretien sont
donc plus distribués par les commerce, supermarché, epiceries .


Pour le deuxième graphique:
On a plusieurs fournisseurs d'autres régions (3) qui se démarquent
A DEVELOPPER.

*/



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
