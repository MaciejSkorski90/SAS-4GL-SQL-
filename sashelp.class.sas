/*proc print data=sashelp.class;
run;
*/


proc sql;
create table table1 (compress=yes) as	
	select *
		from sashelp.class
;
quit;


proc sql;

	select *
		from table1
;
quit;