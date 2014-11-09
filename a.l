%{
#include "y.tab.h"
%}

%option interactive
ALPHA [A-Za-z]
DIGIT [0-9]

%%


[ \t\n]+  {}

"do"		{return(DO);}
"while"             { return(WHILE);}
"for"             { return(FOR);}
{ALPHA}({ALPHA}|{DIGIT})*	{ yylval.str=strdup(yytext);return(ID);}
{DIGIT}+	{yylval.str=strdup(yytext);      
		return(NUM);}

"<="|">="|"<"|">"     {yylval.str=strdup(yytext);			
					return (OPR1);
					} 
		   
"=="|"!="      {yylval.str=strdup(yytext);			
			return(OPR2);
		}  
		  
.              {  return yytext[0];}

%%

