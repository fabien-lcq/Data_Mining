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

proc contents data=lasvegas;
run;
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
