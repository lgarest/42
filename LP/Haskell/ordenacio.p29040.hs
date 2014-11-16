insert :: [Int] -> Int -> [Int]
insert [] a = [a]
insert (x:xs) a
    | x > a = [a,x] ++ xs
    | otherwise = [x] ++ insert xs a
--insert l a = [b | b <- l, b <= a] ++ [a] ++ [b | b <- l, b > a]

isort :: [Int] -> [Int]
isort [] = []
isort l = [] ++ insert (isort (init l)) (last l)

remove :: [Int] -> Int -> [Int]
remove [] _ = []
remove (x:xs) a
    | x == a = xs
    | otherwise = [x] ++ remove xs a

ssort :: [Int] -> [Int]
ssort [] = []
ssort [x] = [x]
ssort l = [minl] ++ (ssort (remove l minl))
    where minl = minimum l

merge :: [Int] -> [Int] -> [Int]
merge [] [] = []
merge [] b = b
merge a [] = a
merge (a:as) (b:bs)
    | a <= b = [a] ++ (merge as (b:bs))
    | otherwise = [b] ++ (merge (a:as) bs)

msort :: [Int] -> [Int]
msort [] = []
msort [x] = [x]
msort l
    | length l == 2 = merge [head l] [last l]
    | otherwise = merge (msort a) (msort b)
    where a = take m l
          b = drop m l
          m = (length l) `quot` 2

qsort :: [Int] -> [Int]
qsort [] = []
qsort [x] = [x]
qsort l@(x:xs) = qsort [b | b <- xs, b <= x] ++ [x] ++ qsort [b | b <- xs, b > x]

genQsort :: (Ord a) => [a] -> [a]
genQsort [] = []
genQsort [x] = [x]
genQsort l@(x:xs) = genQsort [b | b <- xs, b <= x] ++ [x] ++ genQsort [b | b <- xs, b > x]
