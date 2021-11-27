/* 값을 참조하여 오늘 날짜 log 화면에 출력 */
%put sysdate9 = &sysdate9;

/* %substr 함수의 리턴값이 year에 저장되어 log 화면에 출력 */
%put year = %substr(&sysdate9, 6);
