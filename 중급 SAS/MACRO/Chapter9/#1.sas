proc sql;
select memname format=$20.,nobs,nvar,crdate
   from dictionary.tables
   where libname='AIRLINE';
quit;

/* 같은 결과 */
proc print data=sashelp.vtable;
	var memname nobs nvar crdate;
	where libname='AIRLINE';
quit;

/* (모든 column) 다 보고 싶을 때 */
proc sql;
select *
   from dictionary.tables
   where libname='AIRLINE';
quit;