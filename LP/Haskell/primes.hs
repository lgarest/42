-- primes lazy

primes = (lprimes [2..])

--lprimes 0 _ = []

lprimes (x:xs) = x:(lprimes $ filter (\y-> (mod y x)/=0) xs)











filterNoDiv n [] = []
filterNoDiv n (x:xs) 
      | (rem x n)==0 = (filterNoDiv n xs)
      | otherwise    = (x:(filterNoDiv n xs))











-- genera la llista de tots els primers d'una llista d'elements consecutius iniciada en 2

allprimes [] = []
allprimes (x:xs) = x:(allprimes (filterNoDiv x xs))

-- Selecciona l'element en posició n de la llista

seln 0 (x:xs) = x
seln n (x:xs) = seln (n-1) xs

-- Obte la llista amb els n primers elements de la llista donada (si n'hi ha menys, els que hi ha)

taken _ [] = []
taken 0 _  = []
taken n (x:xs) = x:(taken (n-1) xs)

-- calcula l'enessim primer

nthprime n = seln (n-1) (allprimes [2..])

-- calcula els n primers primers usant allprimes taken

sprimes n = taken n (allprimes [2..])


-- primes lazy with higher-order filter and lambdas

primesh n = (lprimesh n [2..])

lprimesh 0 _ = []
lprimesh n (x:xs) = x:(lprimesh (n-1) (filter (divid x) xs))

divid x y = (rem y x) /=0


lprimeshl (x:xs) = x:(lprimeshl (filter (\y-> y`rem`x/=0) xs))

