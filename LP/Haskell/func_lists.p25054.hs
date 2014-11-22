myLength :: [Int] -> Int
myLength [] = 0
myLength (x:xs) = 1 + myLength xs

myMaximum :: [Int] -> Int
myMaximum [] = 0
myMaximum (x:xs)
    | null xs = x
    | head xs > x = myMaximum (head xs:xs)
    | otherwise = myMaximum (x:tail xs)

average :: [Int] -> Float
average [] = 0
average l = (fromIntegral (sum l)) / (fromIntegral (myLength l))

buildPalindrome :: [Int] -> [Int]
buildPalindrome [] = []
buildPalindrome l = (reverse' l) ++ l

reverse' :: [Int] -> [Int]
reverse' [] = []
reverse' l = last l : (reverse' (init l))

remove :: [Int] -> [Int] -> [Int]
remove l [] = l
remove [] _ = []
remove a b
    | not (null b) = remove (removeItem a (head b)) (tail b)
    | otherwise = remove a (tail b)

removeItem :: [Int] -> Int -> [Int]
removeItem [] _ = []
-- devuelve una lista que a cada elemento no se le aplica nada, y es cada elemento de la lista que es /= r
removeItem l r = [y | y <- l, y /= r]
--removeItem (x:xs) r
--    |  x == r = (removeItem xs r)
--    | otherwise = x:(removeItem xs r)

-- infiniteList = [[a..]|a<-[1..]]

flatten :: [[Int]] -> [Int]
flatten [] = []
flatten (x:xs) = [] ++ x ++ flatten xs

oddsNevens :: [Int] -> ([Int], [Int])
oddsNevens [] = ([],[])
oddsNevens l = (odds l, evens l)

odds :: [Int] -> [Int]
odds l = [x | x <- l, x `mod` 2 /= 0]

evens :: [Int] -> [Int]
evens l = [x | x <- l, x `mod` 2 == 0]

primeDivisors :: Int -> [Int]
primeDivisors a
    | isPrime a = [a]
    | otherwise = [x | x <- [2..(div a 2)], isPrime x && a `mod` x == 0]

isPrime :: Int -> Bool
isPrime a
    | a == 0 || a == 1 = False
    | otherwise = not (isDivisible a (a - 1))

isDivisible :: Int -> Int -> Bool
isDivisible a dec
    | dec == 1 = False
    | mod a dec == 0 = True
    | otherwise = isDivisible a (dec - 1)
