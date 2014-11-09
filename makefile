all:	
	clear
	clear
	lex a.l
	yacc -d a.y
	gcc y.tab.c lex.yy.c
	
run:
	./a.out<test>tcode
	gedit tcode
	
clean:
	rm -rf *.out
	rm -rf *.c
	rm -rf *.h
	mv tcode old
