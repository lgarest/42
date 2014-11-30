module Tests where
import Practica

testRStringGetVars = do
    putStr "\nRString -> GetVars: "
    let myRString = readRString "wrrbbwrrwwbbwrbrbww"
    let gotten = getVars myRString
    let expected = []
    if gotten == expected then putStr "."
    else putStr "F"

testRStringValid = do
    putStr "\nRString -> Valid: "

    let myStringSignature = [("b",0),("w",0),("r",0)]
    let myRString = readRString "wrrbbwrrwwbbwrbrbww"
    let gotten = valid myStringSignature myRString
    if gotten then putStr "."
    else putStr "F"

    let myStringSignature1 = [("a",0),("b",0),("c",0),("1",0),("2",0),("3",0)]
    let myRString2 = readRString "a1b2c13"
    let gotten2 = valid myStringSignature1 myRString2
    if not gotten2 then putStr "."
    else putStr "F"

    let myStringSignature2 = [("a1",0),("b2",0),("c13",0)]
    let gotten3 = valid myStringSignature2 myRString2
    if gotten3 then putStr "."
    else putStr "F"

testRStringMatch = do
    putStr "\nRString -> Match: "
    let mytargetRString = readRString "abababa"
    let myRString = readRString "ab"

    let gotten = length $ match myRString mytargetRString
    let expected = 3

    if gotten == expected then putStr "."
    else putStr "F"

testRStringApply = do
    putStr "\nRString -> Apply: "
    let myRString = readRString "abfabfabf"
    let a = readRString "ab"
    let b = readRString "d"

    let gotten = apply myRString (Substitution[(a,b)])
    let expected = readRString "dfdfdf"

    if gotten == expected then putStr "."
    else putStr "F"

    let myRString2 = readRString "abb"
    let c = readRString "ab"
    let d = readRString "a"

    let gotten2 = apply myRString2 (Substitution[(c,d)])
    let expected2 = readRString "ab"

    if gotten2 == expected2 then putStr "."
    else putStr "F"

testRStringReplace = do
    putStr "\nRString -> Replace: "
    let myRString = readRString "edeferg"
    let replacement = readRString "re"

    let gotten = replace myRString [([2,2], replacement)]
    let expected = readRString "edreeferg"

    if gotten == expected then putStr "."
    else putStr "F"

    let gotten2 = replace myRString [([2,4], replacement)]
    let expected2 = readRString "edreerg"

    if gotten2 == expected2 then putStr "."
    else putStr "F"

testRStringEvaluate = do
    putStr "\nRString -> Evaluate: "
    let myRString = readRString "wrrbbwrrwwbbwrbrbww"

    let gotten = evaluate myRString

    if gotten == myRString then putStr "."
    else putStr "F"


testRStringRewrite = do
    putStr "\nRString -> rewrite: "
    let myStringSystem = readRStringSystem [("wb", "bw"), ("rb", "br"), ("rw", "wr")]
    let myStringSignature = [("b",0),("w",0),("r",0)]
    let myRString = readRString "wrrbbwrrwwbbwrbrbww"

    let gottenStr1 = rewrite myStringSystem myRString leftmost
    let expected1 = readRString "bbbbbbwwwwwwwrrrrrr"

    if gottenStr1 == expected1 then putStr "."
    else putStr "F"

    let gottenStr2 = rewrite myStringSystem myRString rightmost
    if gottenStr2 == expected1 then putStr "."
    else putStr "F"

testSymbols = do
    putStr "\nRString -> getSymbols: "
    let origStr1 = readRString "a1b2c13dez240"
    let expected1 = map(\x -> readRString x) ["a1","b2","c13","d","e","z240"]
    let gotten1 = getSymbols origStr1

    if gotten1 == expected1 then putStr "."
    else putStr "F"

    let origStr2 = readRString "abecedario"
    let expected2 = map(\x -> readRString x) ["a","b","e","c","e","d","a","r","i","o"]
    let gotten2 = getSymbols origStr2

    if gotten2 == expected2 then putStr "."
    else putStr "F"

testRStringOneStepRewrite = do
    putStr "\nRString -> oneStepRewrite: "
    let myStringSystem = readRStringSystem [("wb", "bw"), ("rb", "br"), ("rw", "wr")]
    let myStringSignature = [("b",0),("w",0),("r",0)]
    let myRString = readRString "wrrbbwrrwwbbwrbrbww"

    let gottenStr1 = oneStepRewrite myStringSystem myRString leftmost
    let expected1 = readRString "wrbrbwrrwwbbwrbrbww"

    if gottenStr1 == expected1 then putStr "."
    else putStr "F"

    let expected2 = readRString "wrrbbwrrwwbbwrbbrww"
    let gottenStr2 = oneStepRewrite myStringSystem myRString rightmost
    if gottenStr2 == expected2 then putStr "."
    else putStr "F"

testRStringnrewrite = do
    putStr "\nRString -> nrewrite: "
    let myStringSystem = readRStringSystem [("wb", "bw"), ("rb", "br"), ("rw", "wr")]
    let myStringSignature = [("b",0),("w",0),("r",0)]
    let myRString = readRString "wrrbbwrrwwbbwrbrbww"

    let gottenStr1 = nrewrite myStringSystem myRString leftmost 1
    let expected1 = readRString "wrbrbwrrwwbbwrbrbww"

    if gottenStr1 == expected1 then putStr "."
    else putStr "F"

    let expected2 = readRString "wrrbbwrrwwbbwrbbrww"
    let gottenStr2 = nrewrite myStringSystem myRString rightmost 1
    if gottenStr2 == expected2 then putStr "."
    else putStr "F"

    let gottenStr3 = nrewrite myStringSystem myRString leftmost 68
    let expected3 = readRString "bbbbbbwwwwwwrwrrrrr"
    if gottenStr3 == expected3 then putStr "."
    else putStr "F"

    let expected4 = readRString "bbbbbwbwwwwwwrrrrrr"
    let gottenStr4 = nrewrite myStringSystem myRString rightmost 68
    if gottenStr4 == expected4 then putStr "."
    else putStr "F"

testRStringValidRule = do
    putStr "\nRString -> validRule: "
    let myRule1 = readRuleRString ("wb", "bw")
    let myStringSignature = [("b",0),("w",0),("r",0)]
    let gotten = validRule myStringSignature myRule1
    if gotten == True then putStr "."
    else putStr "F"

    let myInvalidRule1 = readRuleRString ("a", "z")
    let gotten2 = validRule myStringSignature myInvalidRule1
    if gotten2 == False then putStr "."
    else putStr "F"

    let myInvalidRule2 = readRuleRString ("", "")
    let gotten3 = validRule myStringSignature myInvalidRule2
    if gotten3 == False then putStr "."
    else putStr "F"

testRStringValidRWS = do
    putStr "\nRString -> validRWS: "
    let myStringSystem = readRStringSystem [("wb", "bw"), ("rb", "br"), ("rw", "wr")]
    let myStringSignature = [("b",0),("w",0),("r",0)]
    let myRString = readRString "wrrbbwrrwwbbwrbrbww"
    let gotten = validRewriteSystem myStringSignature myStringSystem

    if gotten == True then putStr "."
    else putStr "F"

testRStringValidRString = do
    putStr "\nRString -> validRString: "
    let myStringSystem = readRStringSystem [("wb", "bw"), ("rb", "br"), ("rw", "wr")]
    let myStringSignature = [("b",0),("w",0),("r",0)]
    let myRString = readRString "wrrbbwrrwwbbwrbrbww"
    let gotten = valid myStringSignature myRString
    if gotten == True then putStr "."
    else putStr "F"

    let myRString2 = readRString "b1w2r3"
    let myInvalidStringSignature1 = [("b",0),("w",0),("r",0),("1",0),("2",0),("3",0)]
    let gotten2 = valid myInvalidStringSignature1 myRString2
    if gotten2 == False then putStr "."
    else putStr "F"

    let myRString3 = readRString "b1w2r3"
    let myStringSignature2 = [("b1",0),("w2",0),("r3",0)]
    let gotten3 = valid myStringSignature2 myRString3
    if gotten3 == True then putStr "."
    else putStr "F"


runtests = do
    putStr "--------------------------------------------------------------\n"
    putStr "| Haskell |         Luis García Estrades          | group:13 |\n"
    putStr "--------------------------------------------------------------\n"
    putStr "Running tests (if . the test passes, otherwise F)"
    testRStringGetVars
    testRStringValid
    testRStringMatch
    testRStringApply
    testRStringReplace
    testRStringEvaluate
    testRStringRewrite
    testRStringOneStepRewrite
    testRStringnrewrite
    testSymbols
    testRStringValidRule
    testRStringValidRWS
    testRStringValidRString
    putStr "\n--------------------------------------------------------------\n"

main = runtests
