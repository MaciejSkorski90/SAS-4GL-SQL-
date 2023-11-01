/* 
Keyboard Macro:

Insert the string 
"proc sql noprint; 
connect to odbc as myconnection 
(datasrc=my_db);

create table work.table1 (compress = yes) as 
select * from connection to myconnection
(
select *
from table_10
);
disconnect from myconnection; 
quit;" at the current position.




Insert the string 
"proc sql;
create table table1 as 
select * from table10
;quit;" at the current position.

*/


proc sql noprint; 
connect to odbc as myconnection 
(datasrc=my_db);

create table work.table1 (compress = yes) as 
select * from connection to myconnection
(
select *
from table_10
);
disconnect from myconnection; 
quit;

proc sql;
create table table1 as 
select * from table10
;quit;

