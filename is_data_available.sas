/*
is data available
*/


proc sql;
create table is_data_available as 
select
count(client_id) as is_data_available 
from work.check1
;quit;

%macro is_data_available_mail();
%let is_data_available = 0;
proc sql;
select is_data_available
into:is_data_available
from work.is_data_available
;quit;


%IF &is_data_available = 0 %THEN %do;
PROC EXPORT DATA=work.check1
OUTFILE=
"/home/Moje_pliki/check1%sysfunc(putn(%syseval(%SYSFUNC(TODAY())),yymmdd10.)).xlsx"
DBMS=excel REPLACE;
RUN;
%goto REPORT skip;
%end;