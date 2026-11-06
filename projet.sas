/* Test */
data test;
    do i = 1 to 10;
        x = i**2;
        output;
    end;
run;

proc means data=test mean median min max;
    var x;
run;