(* Part A *)
fun cycle(L) = 
	if L = [] then []
	else tl(L) @ [hd(L)];

cycle([1,2,3]);
cycle([1,2,3,4,5,6]);


(* Part B *)
fun reCycle(i,L) =
	if L = [] then []
	else if i = 0 then L
	else reCycle(i-1, cycle(L));

reCycle(0, [1,2,3]);
reCycle(3, [1,2,3,4,5,6]);