/* 내가 직접 NOTE, WARNING, ERROR를 만든 것임. */
/* 색 바뀜 */
%put NOTE: Is this a SAS note?;
%put WARNING: Is this a SAS warning?;
%put ERROR: Is this a SAS error?;

/* 색 바뀜 */
%put NOTE- Is this a SAS note?;
%put WARNING- Is this a SAS warning?;
%put ERROR- Is this a SAS error?;

/* 대문자로 쓰면 SAS의 KEYWORD가 작동되는 것. */
/* 소문자로 쓰면 작성된 그대로 text로 인식함. */
/* 색 안바뀜 - 그대로 검은색 */
%put note: Is this a SAS note?;
%put warning: Is this a SAS warning?;
%put error: Is this a SAS error?;



