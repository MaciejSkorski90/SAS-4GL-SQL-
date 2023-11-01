/*
I'm creating 2 reports, from 2 different databases (my_db_1 and my_db_2)
*/

libname my_db_1 odbc dsn=my_db_1;
libname my_db_2 odbc dsn=my_db_2;
libname my_db_3 "/home/Moje_pliki/db";

proc sql noprint; 
connect to odbc as myconnection 
(datasrc=my_db_1);

create table work.summary_db1 (compress = yes) as 
select * from connection to myconnection
(
SELECT DISTINCT 
CURRENT_DATE AS TECH_REPO_DATE, SOH.Company,SOH.OrderDate, SOH.CustomerID, C.CustomerName, SOH.SalesOrderNumber, SOH.TotalDue
, SUM(SOH.TotalDue) OVER (PARTITION BY SOH.OrderDate) AS TotalDueDateSUM
, SUM(SOH.TotalDue) OVER (PARTITION BY SOH.OrderDate ORDER BY SOH.SalesOrderNumber) AS TotalDueDateRunningSUM
, SUM(SOH.TotalDue) OVER ()  AS TotalOfAllTotalDue

FROM Sales1.SalesOrderHeader SOH
LEFT JOIN Sales1.Customer C ON C.ID = SOH.CustomerID

WHERE SOH.OrderDate >= (CURRENT_DATE - 30)
AND C.CustomerName NOT LIKE '%ABC_BAN%'
AND C.TECH_REPO_DATE = (SELECT MAX(TECH_REPO_DATE) FROM Sales.Customer)

ORDER BY SOH.OrderDate ASC
);
disconnect from myconnection; 
quit;

proc sql noprint; 
connect to odbc as myconnection 
(datasrc=my_db_2);

create table work.summary_db2 (compress = yes) as 
select * from connection to myconnection
(
SELECT DISTINCT 
CURRENT_DATE AS TECH_REPO_DATE, SOH.Company, SOH.OrderDate, SOH.CustomerID, C.CustomerName, SOH.SalesOrderNumber, SOH.TotalDue
, SUM(SOH.TotalDue) OVER (PARTITION BY SOH.OrderDate) AS TotalDueDateSUM
, SUM(SOH.TotalDue) OVER (PARTITION BY SOH.OrderDate ORDER BY SOH.SalesOrderNumber) AS TotalDueDateRunningSUM
, SUM(SOH.TotalDue) OVER ()  AS TotalOfAllTotalDue

FROM Sales2.SalesOrderHeader SOH
LEFT JOIN Sales2.Customer C ON C.ID = SOH.CustomerID

WHERE SOH.OrderDate >= (CURRENT_DATE - 30)
AND C.CustomerName NOT LIKE '%ABC_BAN%'
AND C.TECH_REPO_DATE = (SELECT MAX(TECH_REPO_DATE) FROM Sales.Customer)

ORDER BY SOH.OrderDate ASC
);
disconnect from myconnection; 
quit;

/*
I'm combining 2 sets of data
*/

proc sql;
create table summary_all as 

select * from summary_db1
union all 
select * from summary_db2

;quit;

/*
Insert data into a summary table
*/

proc sql;
insert into my_db_3.summary
select * from summary_all;
quit;

/*
EXPORT data to excel file
*/


PROC EXPORT DATA=work.summary_all
OUTFILE="/home/Moje_pliki/summary_all%sysfunc(putn(%sysfunc(today(), yymmdd10.), yymmddn8.)).xlsx"
DBMS=excel REPLACE;
NEWFILE=yes;
RUN;

/*
sending notifying email
*/

filename outbox email;

Data _null_;
file outbox
to = ('adress1@mail.com','adress2@mail.com')
cc = ('adress3@mail.com','adress4@mail.com')
from = 'adress0@mail.com'
attach=("/home/Moje_pliki/summary_all%sysfunc(putn(%sysfunc(today(), yymmdd10.), yymmddn8.)).xlsx")
type='text/html'
subject="%sysfunc(putn(%sysfunc(today(), yymmdd10.), yymmddn8.) summary_all_report"
put 'The database has been updated, the report is attached.'
run;
