/* 가장 최근에 만든 데이터가 없으면 변수 참조를 진행하는데 에러남. */
proc print data=&syslast;
title "Listing of &syslast";
run;


