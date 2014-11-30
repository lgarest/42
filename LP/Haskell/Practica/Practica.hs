module Practica where

{- Author: Luis García Estrades Group:13 -}

{- Variables globales -------------------------------------------------------}
stringedABC = (map (\x -> [x]) ['a'..'z'])
stringedNums = (map (\x->show x) [0..9])

{- 2. Rewrite ---------------------------------------------------------------}

type Signature = [(String, Integer)]

type Position = [Int]

data Substitution a = Substitution [(a, a)]

instance (Show a) => Show (Substitution a) where
    show(Substitution l) = show l

class Rewrite a where
    getVars :: a -> [a]
    valid :: Signature -> a -> Bool
    match :: a -> a -> [(Position, Substitution a)]
    apply :: a -> Substitution a -> a
    replace :: a -> [(Position, a)] -> a
    evaluate :: a -> a

{- 3. Rule & RewriteSystem --------------------------------------------------}

{- 3.1 -}
data Rule a = Rule a a | EmptyRule

data RewriteSystem a = RewriteSystem[Rule a]

instance (Show a) => Show (Rule a) where
    show(Rule a b) = show a ++ " --> " ++ show b

instance (Show a) => Show (RewriteSystem a) where
    show(RewriteSystem []) = []
    show(RewriteSystem (a:[])) = show a
    show(RewriteSystem (a:as)) = show a ++ "\n" ++ show(RewriteSystem as)

-- comprueba que una regla sea válida
validRule :: (Rewrite a) => Signature -> (Rule a)-> Bool
validRule sign EmptyRule = False
validRule sign (Rule a b) = (valid sign a) && (valid sign b)

-- comprueba que un RWS sea válido
validRewriteSystem :: Rewrite a => Signature -> RewriteSystem a -> Bool
validRewriteSystem sign (RewriteSystem rs) = and $ map (validRule sign) rs

{- 3.2 -}
type Strategy a = [(Position, a)] -> [(Position, a)]

{- 3.3 -}
-- aplica una reescritura según un RWS y una estrategia
oneStepRewrite :: Rewrite a => RewriteSystem a -> a -> Strategy a -> a
oneStepRewrite (RewriteSystem sys) s strategy
    | not $ matchSmth (RewriteSystem sys) s = s
    | otherwise = foldl(\x y -> replace x [y]) s matches
    where matches = strategy $ (getMatches (RewriteSystem sys) s)

-- reescribre un objeto según un RWS y una estrategia
rewrite :: Rewrite a => RewriteSystem a -> a -> Strategy a -> a
rewrite rws a stgy
    | not $ matchSmth rws a = a
    | otherwise = rewrite rws (evaluate (oneStepRewrite rws a stgy)) stgy

-- aplica oneStepRewrite n veces
nrewrite :: Rewrite a => RewriteSystem a -> a -> Strategy a -> Int -> a
nrewrite rws a stgy n
    | n == 0 = a
    | not $ matchSmth rws a = a
    | otherwise = nrewrite rws (evaluate (oneStepRewrite rws a stgy)) stgy (n-1)

-- devuelve todos los matches de las reglas de un RWS sobre un obj
getMatches :: Rewrite a => RewriteSystem a -> a -> [(Position, a)]
getMatches (RewriteSystem []) _ = []
getMatches (RewriteSystem ((Rule a b):rules)) o = smatch ++
    getMatches (RewriteSystem rules) o
    where smatch = (map(\(x,Substitution y) -> (x,b)) (match a o))

-- ordenación por quicksort de lista de duplas genéricas
sort :: Ord a => [(a, b)] -> [(a, b)]
sort [] = []
sort [x] = [x]
sort l@(x:xs) = sort [b | b <- xs, fst b <= fst x] ++ [x] ++
    sort [b | b <- xs, fst b > fst x]

-- devuelve si alguna regla hace matching con el string
matchSmth :: Rewrite a => RewriteSystem a -> a -> Bool
matchSmth (RewriteSystem []) _ = False
matchSmth (RewriteSystem ((Rule a b):rules)) str
    | length (match a str) /= 0 = True
    | otherwise = matchSmth (RewriteSystem (rules)) str

{- 4. RString ---------------------------------------------------------------}

{- Helpers -}
-- devuelve si un String es un número
isNum :: String -> Bool
isNum str = elem str stringedNums

-- head sobre RString
head' :: RString -> RString
head' (RString []) = readRString ""
head' (RString str) = readRString $ [head str]

-- tail sobre RString
tail' :: RString -> RString
tail' (RString []) = readRString ""
tail' (RString str) = readRString $ tail str

-- longitud de un RString
length' :: RString -> Int
length' (RString str) = length str

-- hace take sobre un RString
take' :: Int -> RString -> RString
take' n (RString str) = readRString (take n str)

-- hace drop sobre un RString
drop' :: Int -> RString -> RString
drop' n (RString str) = readRString (drop n str)

-- (++) de dos RStrings
concat' :: RString -> RString -> RString
concat' (RString str1) (RString str2) = readRString $ str1 ++ str2

{- 4.1 -}
data RString = RString String deriving(Eq)

instance Rewrite (RString) where
    getVars _ = []

    valid signature str = (wellComposed str) && (strInSignat signature str)

    match str1 str2 = matchC str1 str2 0

    apply str (Substitution s) = foldl (\x y -> applyChange x y) str s

    replace str lista = foldl (\x y ->
        if (length $ fst y) == 1 then
        applyOnPos str (head $ fst y) (length' $ snd y) (snd y)
        else
        applyOnPos str (head $ fst y) ((last $ fst y)-(head $ fst y)) (snd y)
        ) str lista

    evaluate str = str

-- comprueba que el primer caracter del string no sea numero
wellComposed :: RString -> Bool
wellComposed str = not $ elem (head$show str) (map (\x->head$show x) [0..9])

-- comprueba si un RString se puede haber formado por una signatura
strInSignat :: Signature -> RString -> Bool
strInSignat sign str = and $ map (symbolInSignat sign) (getSymbols str)

-- comprueba que un simbolo esta en la signatura
symbolInSignat :: Signature -> RString -> Bool
symbolInSignat sign str = elem (show str) (map fst sign)

-- itera sobre a y comprueba si el str hace matching
matchC :: RString -> RString -> Int -> [(Position, Substitution a)]
matchC str a n
    | length' a == 0 = []
    | take' (length' str) a == str = [([n], Substitution [])] ++ rec
    | otherwise = matchC str (tail' a) (n+1)
    where rec = matchC str (drop' (length' str) a) (n+(length' str))

-- aplica el cambio del snd donde haga matching el fst en el primer parámetro
--applyChange :: RString -> (RString,RString) -> RString
--applyChange s (a,b) = foldl(\x y ->
--    applyOnPos x (head $ fst y) m b) s (match a s)
--    where m = length' a

-- | length' s == 0 = s
applyChange :: RString -> (RString,RString) -> RString
applyChange s (a,b)
    | length (match a s) == 0 = s
    | otherwise = concat' (applyOnPos actual n m b) (applyChange next (a,b))
    where
        n = head $ fst $ head(match a s)
        m = length' b
        actual = take' (n+m) s
        next = drop' (n+m+1) s

-- inyecta en la posicion n (comiendo m caracteres) de a el string b
applyOnPos :: RString -> Int -> Int -> RString -> RString
applyOnPos a n m b = concat' (concat' prefix b) sufix
    where prefix = take' n a
          sufix = drop' (n+m) a

-- devuelve un RString con todos los numeros que haya desde el principio de str
getNums :: RString -> RString
getNums (RString str) = readRString $ takeWhile (\x -> isNum [x]) str

-- devuelve el primer simbolo del str
getSymbol :: RString -> RString
getSymbol str
    | length' (getNums $ tail' str) == 0 = head' str
    | otherwise = concat' (head' str) (getNums $ tail' str)

-- devuelve los símbolos por los que está compuesto un RString
getSymbols :: RString -> [RString]
getSymbols str
    | length' symbol == 0 = []
    | otherwise = [symbol] ++ getSymbols next
    where symbol = getSymbol str
          next = drop' (length' symbol) str

{- 4.2 -}
readRString :: String -> RString
readRString str = RString str

readRStringSystem :: [(String, String)] -> (RewriteSystem)RString
readRStringSystem [] = RewriteSystem []
readRStringSystem l = RewriteSystem $ readListRuleRString l

-- transforma una dupla de Strings en una regla de Rstrings
readRuleRString :: (String, String) -> (Rule)RString
readRuleRString ("",_) = EmptyRule
readRuleRString (a, b) = Rule (readRString a) (readRString b)

readListRuleRString :: [(String, String)] -> [Rule RString]
readListRuleRString [] = []
readListRuleRString (a:[]) = [readRuleRString a]
readListRuleRString (a:as) = [readRuleRString a] ++ (readListRuleRString as)

{- 4.3 -}
instance Show (RString) where
    show(RString a) = init(tail(show a))

{- 4.4 -}
leftmost :: Strategy (RString)
leftmost [] = []
leftmost l = [head $ sort l]
rightmost :: Strategy (RString)
rightmost [] = []
rightmost l = [last $ sort l]
--parallelinnermost _ = []
--leftmostinnermost _ = []
--paralleloutermost _ = []
--leftmostoutermost _ = []

{- 5. RTerm -----------------------------------------------------------------}




{- Juegos de pruebas --------------------------------------------------------}

myStringSystem = readRStringSystem [("wb", "bw"), ("rb", "br"), ("rw", "wr")]
myStringSignature = [("b",0),("w",0),("r",0)]
myRString = readRString "wrrbbwrrwwbbwrbrbww"
