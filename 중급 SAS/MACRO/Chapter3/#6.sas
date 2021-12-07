%macro dog(name=spot);
	%put My dog is &name;
%mend dog;

%dog()