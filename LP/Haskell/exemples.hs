
-- exemple ús if then else
-- no l'useu massa!
prod :: Int -> Int -> Int
prod n m = if n == 0 then 0
       	   else n + prod (n-1) m

-- exemple ús pattern matching
--sumar els elements d'una llista
sumar :: [Integer] -> Integer
sumar [] = 0
sumar (x:xs) = x+(sumar xs)

-- exemple ús pattern matching més complicat i ús de guardes
-- donada una llista de parells, torna una llista on s'ha seleccionat
-- el màxim de cada parell.
select :: [(Int,Int)] -> [Int]
select [] = []
select ((x,y):xs) 
       | x>=y = x:(select xs) 
       | otherwise = y:(select xs) 


-- exemple ús pattern matching al where amb resultat tupla
-- calcula un parell amb el quocient i el residu
division :: Int -> Int -> (Int,Int)
division n m 
    | n < m = (0,n)
    | otherwise = (q+1,r)
    where (q,r) = division (n-m) m


-- Exemples pattern matching, guardes i if-then-else sobre el factorial
ifact :: Integer -> Integer
ifact n = if n==0 then 1
         else n * ifact (n-1)

gfact :: Integer -> Integer
gfact n 
  | n == 0    = 1
  | otherwise = n * gfact (n-1)
--  | n /= 0    = n * gfact (n-1) -- pitjor!


-- fact :: Integer -> Integer
fact 0 = 1
fact n = n * fact (n-1)


-- pfact :: Integer -> Integer
pfact n = product [1..n]

