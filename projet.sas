/* QUESTION 1:Divisez le jeu de données en un ensemble d'apprentissage(80%)
et un ensemble de test (20%) */

proc freq data=ionosphere;
    tables target;
run;
/*Les classes sont deséquilibrées, on doit donc tenir compte
de ce problème pour le découpage*/

proc sort data=ionosphere;by target;run;
proc surveyselect data=ionosphere 
    out=ionosphere_stratifié
    method=srs 
    samprate=0.8 /* 80% dans l'échantillon */
    seed=12345
    outall;
    strata target; /* variable de stratification */
run;
data train test;
set ionosphere_stratifié ;
if  Selected then output train;
else output test;
drop SelectionProb Selected SamplingWeight;
run;

/*Petite vérification */
proc freq data=test;
    tables target;
run;
proc freq data=train;
    tables target;
run;
/* c'est okay */

/*QUESTION 2:Quelles sont les variables qui permettent de prévoir la qualité du retour de radar? */

/* On se retrouve sur un problème de classification classique
On dispose de 34 variables explicatives (V1-V34)
et d'une variable à expliquer (target)
*/

/* QUESTION 3: Trouvez la meilleure méthode de prévision pour la qualité du retour de radar. */

/* EXPLICATION DE LA METHODE:
On va construire différents modèles avec des méthodes différentes:
De façon paramétrique d'abord
Puis on essaiera avec des méthodes non paramétriques
comme les plus proches voisins ou encore un noyau normal.

Une fois ces modéles construits on comparera les resultats
pour obtenir le meilleur modèle possible.
Ce sera ce modèle que l'on mettra en comparaison avec les données de test.
*/

proc discrim data=train anova crossvalidate ;
class target ;
var V1-V34;
run;

/*On observe que certaines p-value sont nettement 
superieurs à 0.05 mais ici les variables fonctionnent 
en pairs donc on ne vas pas prendre le risque de supprimer des variables 
pour l'entrainement .
*/

/* L'erreur par validation croisée est d'environ 19.5% .
Avec notamment une tendance à classer de mauvais signaux en bons signaux.
36 des 101 mauvais signaux ont été clasées en tant que bon signaux (36%)
contre 6 des 180 bons signaux clasées en tant que mauvais signaux (3%)
*/

/* Testons avec des méthodes non parametriques:
1er methode->k-NN
2eme methode->Kernel Normal  
*/

/* PLUS PROCHE VOISINS*/
proc discrim data=train  method=npar k=1 crossvalidate ;
class target ;
var V1-V34;
run;
/*On obtient 0% d'erreur sur les données d'apprentissage
mais par crossvalidation on est proche des 23% d'erreurs.
 */

/* testons avec plus de voisins */

proc discrim data=train  method=npar k=2 crossvalidate ;
class target ;
var V1-V34;
run;
/*On obtient 0% d'erreur sur les données d'apprentissage
mais par crossvalidation on est proche des 19% d'erreurs.
 */

proc discrim data=train  method=npar k=4 crossvalidate ;
class target ;
var V1-V34;
run;
/*On obtient 13% d'erreur sur les données d'apprentissage
mais par crossvalidation on est proche des 27% d'erreurs.   */


proc discrim data=train  method=npar k=6 crossvalidate ;
class target ;
var V1-V34;
run;
/*On obtient 23% d'erreur sur les données d'apprentissage
mais par crossvalidation on est proche des 28% d'erreurs   */

/* Lorsque le nombre de voisins augmente, les performances
du modèle se dégradent.Parmis le nombre de voisins testées
k=2 nous fournit donc les meilleurs résultats avec environ
19% d'erreurs par validation croisée.

/*Testons de nouveaux modèles par noyau gaussien */

proc discrim data=train method=npar kernel=normal r=0.25 crossvalidate ;
class target ;
var V1-V34;
run;
/* Parfaitement performant sur les données d'apprentissage
et environ 23% d'erreur par validation croisée. */

proc discrim data=train method=npar kernel=normal r=0.5 crossvalidate ;
class target ;
var V1-V34;
run;
/* Même conclusion, 22% par validation croisée */

proc discrim data=train method=npar kernel=normal r=1 crossvalidate ;
class target ;
var V1-V34;
run;
/*Même conclusion */

proc discrim data=train method=npar kernel=normal r=2 crossvalidate ;
class target ;
var V1-V34;
run;

/*Notre rayon est devenue trop grand on dépasse les 40%
d'erreurs par validation croisée */

/* Pour r=[0.25,0.5,1] on obtiens des résultats similaires:
Une erreur d'apprentissage quasiment voir complétement nulle
et une erreur par validation croisée autour des 22%.
*/

/*POUR LE RAPPORT FAIRE UN TABLEAU COMPARATIF*/

/* QUESTION 4:Vérifiez la méthode choisie à la question précédente sur les observations de test*/

proc discrim data=train method=npar k=2 testdata=test  ;
class target;
testclass target;
var V1-V34;
run;


