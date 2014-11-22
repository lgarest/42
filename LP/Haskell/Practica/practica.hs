-- fst: identificator to construct objects
-- snd: # of arguments given
type Signature = [(String, Int)]

-- indicator of position inside of an object
type Position = [Int]

-- fst: variable
-- snd: substitution term of fst
type Substitution a = [(a, a)]

class Rewrite a where
    getVars :: a -> [a]
    valid :: Signature -> a -> Bool
    match :: a -> a -> [(Position, Substitution a)]
    apply :: a -> Substitution a -> a
    replace :: a -> [(Position, a)] -> a
    evaluate :: a -> a

data Rule a = Rule a a

data RewriteSystem a = RewriteSystem[Rule a]

instance (Show a) => Show (Rule a) where
    show(Rule a b) = show a ++ " --> " ++ show b

instance (Show a) => Show (RewriteSystem a) where
    show(RewriteSystem []) = []
    show(RewriteSystem (a:[])) = show a
    show(RewriteSystem (a:as)) = show a ++ "\n" ++ show(RewriteSystem as)

data RString = RString String

instance Show (RString) where
    show(RString a) = init(tail(show a))
--instance Rewrite RString where
    -- getVars
    -- valid
    -- match
    -- apply
    -- replace
    -- evaluate

readRString :: String -> RString
readRString s = RString s

readRuleRString :: (String, String) -> (Rule)RString
readRuleRString (a, b) = Rule(readRString a) (readRString b)

readListRuleRString :: [(String, String)] -> [Rule RString]
readListRuleRString [] = []
readListRuleRString (a:[]) = [readRuleRString a]
readListRuleRString (a:as) = [readRuleRString a] ++ (readListRuleRString as)

readRStringSystem :: [(String, String)] -> (RewriteSystem)RString
readRStringSystem [] = RewriteSystem []
readRStringSystem l = RewriteSystem $ readListRuleRString l

leftmost a = a
rightmost b = b
