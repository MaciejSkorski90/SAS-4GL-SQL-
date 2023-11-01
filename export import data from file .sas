/*
Keyboard Macro:

Insert the string "PROC EXPORT DATA=work.table_1
OUTFILE=
"/home/Moje_pliki/file"
DBMS=excel REPLACE:
RUN;
at the current position.



Insert the string"
proc import
OUTFILE=
"/home/Moje_pliki/file"
dbms=xlsx
out-work.table_1
replace:
sheet = "table_1":
GETNAMES=yes;
run;" at the current position.
*/

PROC EXPORT DATA=work.table_1
OUTFILE="/home/Moje_pliki/file"
DBMS=excel REPLACE:
RUN;

PROC IMPORT
OUTFILE= "/home/Moje_pliki/file"
DBMS=xlsx
OUT=work.table_1
replace;
sheet = "table_1";
GETNAMES=yes;
run;