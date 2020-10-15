fun lOne(L) =
	if L = nil then nil
	else hd(L)::lTwo(tl(L))
and
lTwo(L) =
	if L=nil then nil
	else lThree(tl(L))
and
lThree(L) = 
	if L=nil then nil
	else lOne(tl(L));

lOne([1,2,3,4,5,6,7,8,9]);
lTwo([1,2,3,4,5,6,7,8,9]);
lThree([1,2,3,4,5,6,7,8,9]);