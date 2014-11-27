-- Problema 1
esDob :: Int -> Int -> Bool
esDob x y = (\a b -> a == (b*2)) x y


elimDiv' :: [Int] -> Int -> [Int]
elimDiv' [] _ = []
elimDiv' (x:xs) r
    | x `mod` r /= 0 = [x] ++ elimDiv' xs r
    | otherwise = [] ++ elimDiv' xs r

elimDiv :: [Int] -> [Int]
--elimDiv l = filter (\ant next -> next `mod` ant /= 0) l
--elimDiv l = scanl (\ant next -> next `mod` ant /= 0) l
elimDiv [] = []
elimDiv (x:xs) = [x] ++ elimDiv (elimDiv' xs x)


--infGen :: (a->a) ->

genSum::[Integer]
genSum = [sum[0..x]|x<-[0..]]

infSum :: [[Integer]]
infSum = [[x..]|x<-[1..]]

infOne :: [Int]
infOne = iterate (\x -> x) 1

infOne' = repeat 1

esDob' :: Int -> Int -> Bool
esDob' a b = (\ x y -> x == 2 * y) a b

suma = foldl(\acc x -> acc + x) 1 [1..10]

data Arbol a = Vacio | Nodo a (Arbol a) (Arbol a)  deriving (Show, Eq, Ord)

insertNodo :: (Ord a) => a -> Arbol a -> Arbol a
insertNodo x Vacio = (Nodo x Vacio Vacio)
insertNodo x (Nodo a izq der)
    | x < a = Nodo a (insertNodo x izq) der
    | otherwise = Nodo a izq (insertNodo x der)

data Polynom a = Polynom [a] deriving (Show)

instance Eq (Polynom a) where
    (==) (Polynom a) (Polynom b) = True

--prefsufs :: [Int] -> [[Int]]
prefsufs l = [[ini..a]|a<-l] ++ [[a..las]|a<-[sec..las]]
    where
        ini = (head l)
        sec = l !! 1
        las = (last l)
