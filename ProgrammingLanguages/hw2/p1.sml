fun fib(n) =
  if n < 3 then 1
  else fib (n-1) + fib(n-2);


fib(0);
fib(8);
fib(19);
fib(21);
fib(28);
fib(40);

(* 
	What is the smallest value for which you get an "uncaught exception Overflow" raised? 
	Answer: 45
*)