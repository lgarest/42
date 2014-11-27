flatten :: [[Int]] -> [Int]
flatten l = foldr (\acc x -> acc ++ x) [] l

myLength :: String -> Int
myLength = length

myReverse :: [Int] -> [Int]
myReverse = reverse
