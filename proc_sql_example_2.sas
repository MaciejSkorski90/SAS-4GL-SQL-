/*import danych z pliku xlsx*/

proc import datafile = "/home/MS/DATA/score_data1" 
DBMS = xlsx out = score_data1 ;
run; 

proc import datafile = "/home/MS/DATA/score_data2" 
DBMS = xlsx out = score_data2 ;
run; 

proc import datafile = "/home/MS/DATA/data3" 
DBMS = xlsx out = data3 replace ;
run;


proc sql;
   SELECT a.id, a.Name, score1, score2, score3, gender   
   FROM score_data1 AS a,  score_data2 AS b
   where a.id =  b.id and a.score1 >= b.score2
   order by id;
quit; 


proc sql;
   SELECT a.id, a.Name, score1, score2, score3, gender, c.best_score   
   FROM score_data1 AS a,  score_data2 AS b, data3 AS c
   where a.id =  b.id and c.name = a.name and c.name = b.name
   order by id;
quit; 


proc sql;
select * , mean (score1, score2, score3) as smean
from score_data1 as a, data3 as c
where c.group = c.group and calculated smean >=   
									(select score_avg from score1 as a 
										where a.group = c.group  and c.group in 
											(select c.group from data3 as c 
												where score_avg > 70));
quit;



proc sql;
   SELECT a.id, a.Name, score1, score2, score3, gender   
   FROM score_data1 AS a,  score_data2 AS b
   where a.id =  b.id and a.score1 >= b.score2
   order by id;
quit; 


/*EXCEPT zwraca wiersze, które wynikają z pierwszego zapytania, ale nie z drugiego zapytania*/
proc sql;
   title 'EXCEPT ALL';
   select * from score_data1
   except all
   select * from score_data2;
quit;

/*INTERSECT zwraca wiersze z pierwszego zapytania, które występują również w drugim*/
proc sql;
   title 'INTERSECT';
   select * from score_data1
   intersect
   select * from score_data2;
quit;
 
/*OUTER UNION łączy wyniki zapytań (union w pionie, outer union w poziomie)*/
proc sql;
   title 'OUTER UNION';
   select * from score_data1
   outer union
   select * from score_data2;
quit;
  
/*nakłada kolumny w tej samej pozycji*/
proc sql;
   title 'OUTER UNION CORR';
   select * from score_data1
   outer union CORR
   select * from score_data2;
quit;

/*match merge*/
proc sort data = score_data1;
by id;
run;

proc sort data = score_data2;
by id;
run;

data match_merge;
merge score_data1 score_data2;
by id;
run;

proc print data=match_merge;
title "match merge";
run;

/*porownanie*/

proc sql;

   title "score_data1";
   select * from score_data1;
   
   title "score_data2";
   select * from score_data2;
   
quit;

proc sql;

   select * from score_data1;
   
   select * from score_data2;
   
quit;



