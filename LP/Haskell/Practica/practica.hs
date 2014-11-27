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
type Substitution a = [(a, a)]

class Rewrite a where
    getVars :: a -> [a]
    valid :: Signature -> a -> Bool
    match :: a -> a -> [(Position, Substitution a)]
    apply :: a -> Substitution a -> a
    replace :: a -> [(Position, a)] -> a
    evaluate :: a -> a

{- 3. Rule & RewriteSystem --------------------------------------------------}
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
    -- valida un RString: definido por la signatura y bien formado
    valid signature str = (wellComposed str) && (strInSignat signature str)
    match str1 str2 = [] {- TODO -}
    apply str substi = str {- TODO -}
    replace str lista = str {- TODO -}
    evaluate str = str {- TODO -}

-- comprueba que el primer caracter del string no sea numero
wellComposed :: RString -> Bool
wellComposed str = not $ elem (head$show str) (map (\x->head$show x) [0..9])

-- comprueba si un RString se puede haber formado por una signatura
strInSignat :: Signature -> RString -> Bool
strInSignat sign str = and $ map (symbolInSignat sign) (getSymbols str)

-- comprueba que un simbolo esta en la signatura
symbolInSignat :: Signature -> RString -> Bool
symbolInSignat sign str = elem (show str) (map fst sign)

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
    where
        symbol = getSymbol str
        next = drop' (length' symbol) str

{- UNUSED -}
rStrTChar :: RString -> [Char]
rStrTChar (RString str) = str

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
leftmost a = a {- TODO -}
rightmost b = b {- TODO -}

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


----let myRString = readRString "wrrbbwrrwwbbwrbrbww"
--myAbc = (map (\x -> readRString[x]) ['a'..'z'])
--myNums = (map (\x->readRString$show x) [0..9])
----myCleanfromString = takeWhile (\x -> isChar [x]) "abc234"
--myCleanRString = takeWhile (\x -> isChar [x]) (show myString2)
--myCleanRString2 = takeWhile (\x -> isChar [x]) "abc1b2a13"
--myWtf = readRString myCleanRString2

--a = getChars myString
--b = getNums $ tail' myString
