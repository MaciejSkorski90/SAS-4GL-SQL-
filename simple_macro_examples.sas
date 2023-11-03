/*macro examples*/
/**/
%let state  = Mazowieckie;
title "data for &state";

/**/
%macro print;
   proc print data = data1;
   title 'input data';
   run;
%mend print;

/**/
%macro data1;
   data
%mend data1;

/**/
%macro score_avg(score_var= );
   proc means data = score_data mean MAXDEC = 3;
      var &score_var;
   run;
%mend score_avg;

%score_avg(score_var= score1)
%score_avg(score_var= score2)
%score_avg(score_var= score3)
