/*import danych z pliku xlsx*/

proc import datafile = "/home/u63659310/Kurs/DATA/score_data_id_dups" 
DBMS = xlsx out = data_1 replace;
run;

proc sql outobs=2;
Select *
From data_1
order by name;
quit;


/*lista wszystkich kolumn i atrybutów tabeli*/

proc sql;
   describe table data_1;
   
   
 /*PROC SQL VS DATA Step */

proc sql;
   create table data_proc_sql as
   select stu_id,
          gender,
          name
   from data_1
   where gender = 'f';
quit;

data data_data_step;
set data_1;
if gender 'f';
keep stu_id gender name;
run;

proc print data = data_proc_sql;
title ' data from proc sql';
run;

proc print data = data_data_step;
title ' data from data step';
run;

/*zmiana pola płci na opisowe*/

proc sql;
create table data_2 as
   select *
   , case gender
   when 'f' then 'female'
   when 'm' then 'male'
   end as gender_new
   from data_1
   order by Name;
quit; 

proc sql;
create table data_2 as
   select *
   , case 
   when gender = 'f' then 'female'
   when gender = 'm' then 'male'
   end as gender_new
   from data_1
   order by Name;
quit; 



/*Dodanie tekstu do wyniku*/
proc sql;
select "Najlepszy wynik dla", Name, "to", Score
      from data_2;


/*Prosta agregacja*/
proc sql;
   select name, score1, score2, score3, gender
   , mean (score1, score2, score3 ) as score_mean
   , max (calculated score_mean) as max_mean, min(calculated score_mean)as min_mean
   from data_1
   group by name, score1, score2, score3, gender
   having gender is not missing and min(calculated score_mean) >= 60;
quit;


