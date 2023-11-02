/* create table*/
proc sql;
   create table client
          ( name 	 char(10),          
            gender   char(1),                   
			Birth_date    num				
         				 informat=date9.     
               			 format=date9.);      
quit;

proc sql;
create table data2 as
  select * from data (drop = column1);
quit; 

/*insert:
set - by name
values - by position
query
*/
proc sql;
   insert into client   
      set name='Albert',
          gender = 'm',
          birthdate = '03Dec2001'd,
      set name='Tymek',
          birthdate = '06Jun2007'd,
          gender = 'm';
quit;

Proc SQL;  											
   insert into client							
      values ('Albert', 'm', '03Dec2001'd)
      values ('Tymek','m', '06Jun2007'd);
quit;

proc sql;   
   insert into client (name,gender,birthdate)  
   select name,gender,birthdate 
   		from client_0;
quit;

/*update*/
proc sql;
   create table client like client_0; /*create empty table*/
   
   insert into new_score_data   /*Insert all of the columns/rows into client table from a query*/
   select * from client_0;
quit;

proc sql;
   update client
      set gender='man'
      where gender='m';
quit;

proc sql;
   update client
      set gender='female'
      where gender='f';
   update client
      set gender='man'
      where gender='m';
quit;    
      
 proc sql;
create table client as
   select * from client_0;
update client as u
   set gender=(select gender from client_000 as s1
            where u.name=s1.name) 
        where u.name in (select name from client_000); 
quit;
      
/*delete*/
proc sql;
delete
from client
where gender = 'f';
quit;

/*add a new column without data values*/
proc sql; 
   alter table client
      add rating num label='rating' format=4.1;
quit;

/*modifying a column*/
proc sql;
   alter table client
      modify birthdate label = 'birth_date' format = date8.;
quit;
  
/*deleting a table*/     
proc sql;
   drop table client;
quit;   

/*creating views*/
proc sql;
   create view v_client as
   select *,
   mean(rating1, rating2, rating3 ) as rating_avg,
          case
             when Calculated rating_avg >= 100 then 'A++'
             when 80 <= Calculated rating_avg < 80 then 'A+'
             when 70 <= Calculated rating_avg < 70 then 'A'
             when 60 <= Calculated rating_avg < 60 then 'B+'
             when 0< Calculated rating_avg < 50 then 'B'
             else 'no_rating'
          end as Grade
      from client
      order by Name;
quit;
   
proc sql;
   describe view v_client;
quit;   

proc sql;
   drop view v_client;
quit; 
