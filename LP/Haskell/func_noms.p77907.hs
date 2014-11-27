absValue :: Int -> Int
absValue a
    | a < 0 = a * (-1)
    | otherwise = a

power :: Int -> Int -> Int
power a 0 = 1
power a b = a * power a (b - 1)

isPrime :: Int -> Bool
isPrime a
    | a == 0 || a == 1 = False
    | otherwise = not (isDivisible a (a - 1))

isDivisible :: Int -> Int -> Bool
isDivisible a dec
    | dec == 1 = False
    | mod a dec == 0 = True
    | otherwise = isDivisible a (dec - 1)

slowFib :: Int -> Int
slowFib a
    | a < 2 = absValue a
    | otherwise = slowFib (a-1) + slowFib (a-2)

quickFib :: Int -> Int
quickFib a
    | a < 2 = absValue a
    | otherwise = fst(fib(a))

fib :: Int -> (Int, Int)
fib 0 = (0, 0)
fib 1 = (1, 0)
-- fib returns (f(n), f(n-1))
fib n = (a+b, a)
    where (a,b) = fib (n - 1)

