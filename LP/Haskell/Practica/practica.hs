{- Variables globales -------------------------------------------------------}
stringedABC = (map (\x -> [x]) ['a'..'z'])
stringedNums = (map (\x->show x) [0..9])

{- 2. Rewrite ---------------------------------------------------------------}
-- vocabulario ("diccionario" en los strings)
-- fst: identificator to construct objects (letra/s)
-- snd: # of arguments given
-- ej: f(x,x) = [("f",2), ("x",0)]
type Signature = [(String, Integer)]

-- indicator of position inside of an object
type Position = [Int]

-- fst: variable
-- snd: substitution term of fst
-- es diferente de una regla
-- ej: [("a","b")]
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
--noSubs :: Rewrite a => [(Position, Substitution a)] -> [(Position, a)]
noSubs :: [(t1, Substitution t)] -> [(t1, [(t, t)])]
noSubs [] = []
noSubs ((p, Substitution s):xs) = [(p,s)] ++ noSubs xs

data Rule a = Rule a a

data RewriteSystem a = RewriteSystem[Rule a]

instance (Show a) => Show (Rule a) where
    show(Rule a b) = show a ++ " --> " ++ show b

instance (Show a) => Show (RewriteSystem a) where
    show(RewriteSystem []) = []
    show(RewriteSystem (a:[])) = show a
    show(RewriteSystem (a:as)) = show a ++ "\n" ++ show(RewriteSystem as)

validRule :: (Rewrite a) => Signature -> (Rule a)-> Bool
validRule sign (Rule a b) = (valid sign a) && (valid sign b)

validRewriteSystem :: Rewrite a => Signature -> RewriteSystem a -> Bool
validRewriteSystem sign (RewriteSystem rs) = and $ map (validRule sign) rs


{- 3.2 -}
type Strategy a = [(Position, a)] -> [(Position, a)]

{- 3.3 -}
oneStepRewrite :: Rewrite a => RewriteSystem a -> a -> Strategy a -> a
oneStepRewrite (RewriteSystem sys) s strategy
    | not $ matchSomething (RewriteSystem sys) s = s
    | otherwise = foldl(\x y -> replace x [y]) s matches
    where matches = strategy $ (getMatches (RewriteSystem sys) s)

rewrite :: Rewrite a => RewriteSystem a -> a -> Strategy a -> a
rewrite rws s stgy
    | not $ matchSomething rws s = s
    | otherwise = rewrite rws (evaluate (oneStepRewrite rws s stgy)) stgy

nrewrite :: Rewrite a => RewriteSystem a -> a -> Strategy a -> Int -> a
nrewrite rws s stgy n
    | n == 0 = s
    | not $ matchSomething rws s = s
    | otherwise = nrewrite rws (evaluate (oneStepRewrite rws s stgy)) stgy (n-1)

-- applyOnPos a n m b

--[(Position, Substitution RString)]

--match str1 str2
getMatches :: Rewrite a => RewriteSystem a -> a -> [(Position, a)]
getMatches (RewriteSystem []) _ = []
getMatches (RewriteSystem ((Rule a b):rules)) str = smatch ++ getMatches (RewriteSystem rules) str
    where smatch = (map(\(x,Substitution y) -> (x,b)) (match a str))

sort :: Ord a => [(a, b)] -> [(a, b)]
sort [] = []
sort [x] = [x]
sort l@(x:xs) = sort [b | b <- xs, fst b <= fst x] ++ [x] ++
    sort [b | b <- xs, fst b > fst x]

-- devuelve si alguna regla hace matching con el string
matchSomething :: Rewrite a => RewriteSystem a -> a -> Bool
matchSomething (RewriteSystem []) _ = False
matchSomething (RewriteSystem ((Rule a b):rules)) str
    | length (match a str) /= 0 = True
    | otherwise = matchSomething (RewriteSystem (rules)) str

{- 4. RString ---------------------------------------------------------------}

{- Helpers -}
isChar :: String -> Bool
isChar str = elem str stringedABC

isNum :: String -> Bool
isNum str = elem str stringedNums

head' :: RString -> RString
head' (RString []) = readRString ""
head' (RString str) = readRString $ [head str]

tail' :: RString -> RString
tail' (RString []) = readRString ""
tail' (RString str) = readRString $ tail str

length' :: RString -> Int
length' (RString str) = length str

take' :: Int -> RString -> RString
take' n (RString str) = readRString (take n str)

drop' :: Int -> RString -> RString
drop' n (RString str) = readRString (drop n str)

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
applyChange :: RString -> (RString,RString) -> RString
applyChange s (a,b) = foldl(\x y ->
    applyOnPos x (head $ fst y) m b) s (match a s)
    where m = length' a

-- inyecta en la posicion n (comiendo m caracteres) de a el string b
applyOnPos :: RString -> Int -> Int -> RString -> RString
applyOnPos a n m b = concat' (concat' prefix b) sufix
    where prefix = take' n a
          sufix = drop' (n+m) a

--getChars :: RString -> RString
--getChars (RString str) = readRString $ takeWhile (\x -> isChar [x]) str

getNums :: RString -> RString
getNums (RString str) = readRString $ takeWhile (\x -> isNum [x]) str

getSymbol :: RString -> RString
getSymbol str
    | length' (getNums $ tail' str) == 0 = head' str
    | otherwise = concat' (head' str) (getNums $ tail' str)

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

readRuleRString :: (String, String) -> (Rule)RString
readRuleRString (a, b) = Rule (readRString a) (readRString b)

readListRuleRString :: [(String, String)] -> [Rule RString]
readListRuleRString [] = []
readListRuleRString (a:[]) = [readRuleRString a]
readListRuleRString (a:as) = [readRuleRString a] ++ (readListRuleRString as)

{- 4.3 -}
instance Show (RString) where
    show(RString a) = init(tail(show a))

{- 4.4 -}
-- [(Position, a)]
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

mySignature :: Signature
mySignature = [([a],0)|a<-['a'..'z']]

myRule = readRuleRString ("marc","gay")

test :: String -> Bool
test str = str == "a"

myStringSystem = readRStringSystem [("wb", "bw"), ("rb", "br"), ("rw", "wr")]
myStringSignature = [("b",0),("w",0),("r",0)]
myRString = readRString "wrrbbwrrwwbbwrbrbww"
--valid myStringSignature myRString

myStrings = readRStringSystem [("a","z"), ("b","y"), ("c","x")]
myString = readRString "a1b2a13"
myString2 = readRString "abc1b2a13"

--sign1 :: Signature
--sign1 = [("a",0),("b",0),("1",0),("2",0)]
--sign2 :: Signature
--sign2 = [("a1",0),("b2",0)]
--string1 = readRString "a1b2"

--show $ valid sign1 string1
--show $ valid sign2 string1


----let myRString = readRString "wrrbbwrrwwbbwrbrbww"
--myAbc = (map (\x -> readRString[x]) ['a'..'z'])
--myNums = (map (\x->readRString$show x) [0..9])
----myCleanfromString = takeWhile (\x -> isChar [x]) "abc234"
--myCleanRString = takeWhile (\x -> isChar [x]) (show myString2)
--myCleanRString2 = takeWhile (\x -> isChar [x]) "abc1b2a13"
--myWtf = readRString myCleanRString2

--applyOnPos (readRString "e1") 0 (readRString "re")

macia = readRString "Macia es un capullo!!"
luis = readRString "Luis es muy feo kuekuek"
aina = readRString "Aina es una patosa"

cambio = Substitution [
    (readRString "capullo",readRString "gay"),
    (readRString "feo", readRString "guapo"),
    (readRString "patosa",readRString "patosa que te cagas")]



str1 = RString "ababa"
str2 = RString "lpshit"
pos1 :: Position
pos1 = [2]
pos2 :: Position
pos2 = [2,2]
pos3 :: Position
pos3 = [2,4]
lista1 = [(pos1, str2)]
lista2 = [(pos2, str2)]
lista3 = [(pos3, str2)]
