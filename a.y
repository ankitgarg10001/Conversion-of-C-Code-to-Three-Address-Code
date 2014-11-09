%{ 
#include<stdio.h>
#include<ctype.h>
#include<string.h>
int i=0;
int l=0;

%}

%union{
char *str;
int c;
}

%start Z;
%type <c> S E T F A B K Z

%token <str> ID NUM FOR OPR1 OPR2 WHILE DO


%right '='
%left '+' '-'
%left '*' '/'
%left UMINUS
/*
A: FOR '(' S  ';' K ';' S ')' '{' N '}';
problems:take K as $6 instead of $5
need raw data to advance sometimes


*/


//for(i=0;i+2<b-4;i=i+1){a=b+c*4}

%%

Z	: '{' Y {YYACCEPT; }
	;

Y	: A Y
	|B Y
	|C Y
	|N Y
	| '}'
	;

A	:	FOR	{printf("//For start \n");} 
		'(' 
		S {printf("\nL%d\n",l);l++;} 
		';' 
		K {printf("if t%d  goto L%d \ngoto L%d \nL%d \n",$7,l+1,l+2,l);l++;}
		';' S {printf("\ngoto L%d\nL%d\n",l-2,l);l++;}  
		')'
		'{' 
		N 
		'}'	{	//printf("%s = t%d \n\n\n",$2,$4);
			printf("\ngoto L%d\nL%d\n",l-2,l);
			l++;
			printf("//For done \n");
			//YYACCEPT; 
			};
						
B	:	WHILE {printf("//while start \n");}  
		'(' {printf("\nL%d\n",l);l++;} 
		K {printf("if t%d  goto L%d \n\n",$5,l);} 
		')' 
		'{' 
		N 
		'}'{	printf("\ngoto L%d\nL%d\n",l-1,l);
			l++;
			printf("//while done \n");
			//YYACCEPT; 
			};
	
	
C	:	DO  {printf("//do start\nL%d\n",l);l++;}
		'{' 
		N 
		'}' 
		WHILE 
		'(' 
		K 
		')'
		';' { printf("if t%d goto L%d\n//do end\n",$8,l-1);}

K: E OPR1 E {
			printf("t%d = t%d %s t%d \n\n",i,$1,$2,$3);
			$$=i;
			i++;
		  }

	|E OPR2 E {
			printf("t%d = t%d %s t%d \n\n",i,$1,$2,$3);
			$$=i;
			i++;
		     }	
	;



N	:	S ';' N
	|	S  ';' //shift reduce due to this
	;


S    :    ID '=' E  {
					printf("%s = t%d \n\n",$1,$3);
					//printf("accepted \n");
					//YYACCEPT; 
				}
      ;
E    :    E '+'  T  {
					printf("t%d = t%d + t%d \n",i,$1,$3);
					$$=i;
					i++;
				}
			
      |    E '-' T  {
					printf("t%d = t%d - t%d \n",i,$1,$3);
					$$=i;
					i++;
				}
			
      |    T
      ;
T    :    T '*' F {
			 printf("t%d = t%d * t%d \n",i,$1,$3);
			 $$=i;
			 i++;
			}
			
      |    T '/' F {
			 printf("t%d = t%d / t%d \n",i,$1,$3);
			 $$=i;
			 i++;
			}
      |    F
      ;
F    :    '(' E ')' { 
				$$=$2;
				i++;
				}
      |    '-' F %prec UMINUS {
			 printf("t%d = -t%d \n",i,$2);
			 $$=i;
			 i++;
			}
      |    ID {
			 printf("t%d = %s \n",i,$1);
			 $$=i;
			 //printf("%c %c \n",$$,i);
			 i++;
			}
      |    NUM {
			 printf("t%d = %s \n",i,$1);
			 $$=i;
			 //printf("%c \n",$$);
			 i++;
			}
      ;

%%


yyerror(){printf("invalid expression \n");}
yywrap(){}
main()
{
    //printf("Enter the expression : ");
    yyparse();
}




/************Samples****************/
/*
gcc y.tab.c lex.yy.c
home@ankit-Inspiron-N5010:~/try$ ./a.out 
Enter the expression : a=b+c*d--d;w=x+y
t0 = b 
t1 = c 
t2 = d 
t3 = t1 * t2 
t4 = t0 + t3 
t5 = d 
t6 = -t5 
t7 = t4 - t6 
a = t7 


t8 = x 
t9 = y 
t10 = t8 + t9 
w = t10 

*/




/*
gcc y.tab.c lex.yy.c
home@ankit-Inspiron-N5010:~/working/for$ ./a.out 
Enter the expression : for(i=0;i+2<b-4;i=i+1){a=b+c*4}
t0 = 0 
i = t0 



L0
t1 = i 
t2 = 2 
t3 = t1 + t2 
t4 = b 
t5 = 4 
t6 = t4 - t5 
t7 = t3 < t6 


if t7  goto L2 
goto L3 
L1 
 t8 = i 
t9 = 1 
t10 = t8 + t9 
i = t10 



goto L0
L2t11 = b 
t12 = c 
t13 = 4 
t14 = t12 * t13 

a
t15 = t11 + t14 
a = t15 



goto L1
L3
accepted 
invalid expression 


*/

