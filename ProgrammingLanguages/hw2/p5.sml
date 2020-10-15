 fun map(f,L) = 
 	if (L=[]) then []
	else hd(f)(hd(L))::(map(tl(f),tl(L)));

fun format(n,L) = 
	if (L=[]) then []
	else (hd(n),hd(L))::format(tl(n),tl(L)); 

fun F(f,L) = 
	if (L=[]) then []
	else format(L,map(f,L));



fun square(x) = (x:int)*x;

fun incremOne(x) = (x:int)+1;

fun incremTwo(x) = (x:int)+2;


F([square], [2]);
F([square, incremOne], [1,2]);
F([square, incremOne, incremTwo], [1,2,3]);