fun duplicate(L) = 
	if L = [] then []
	else hd(L)::hd(L)::duplicate(tl(L));

duplicate([1,2,3,4,5,6]);
duplicate([7,8,9,10]);