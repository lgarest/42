module Tests where
import Practica

assertEq b c = if b == c then putStr "." else putStr "F"
assertNEq b c = if b /= c then putStr "." else putStr "F"
assertTr b = if b then putStr "."else putStr "F"
assertFa b = if not b then putStr "."else putStr "F"

testRStringGetVars = do
    putStr "\nRString -> GetVars: "
    let myRString = readRString "wrrbbwrrwwbbwrbrbww"
    let gotten = getVars myRString
    let expected = []
    assertEq gotten expected

testRStringValid = do
    putStr "\nRString -> Valid: "

    let myStringSignature = [("b",0),("w",0),("r",0)]
    let myRString = readRString "wrrbbwrrwwbbwrbrbww"
    let gotten = valid myStringSignature myRString
    assertTr gotten

    let myStringSignature1 = [("a",0),("b",0),("c",0),("1",0),("2",0),("3",0)]
    let myRString2 = readRString "a1b2c13"
    let gotten2 = valid myStringSignature1 myRString2
    assertFa gotten2

    let myStringSignature2 = [("a1",0),("b2",0),("c13",0)]
    let gotten3 = valid myStringSignature2 myRString2
    assertTr gotten3

testRStringMatch = do
    putStr "\nRString -> Match: "
    let mytargetRString = readRString "abababa"
    let myRString = readRString "ab"

    let gotten = length $ match myRString mytargetRString
    let expected = 3
    assertEq gotten expected

testRStringApply = do
    putStr "\nRString -> Apply: "
    let myRString = readRString "abfabfabf"
    let a = readRString "ab"
    let b = readRString "d"

    let gotten = apply myRString (Substitution[(a,b)])
    let expected = readRString "dfdfdf"
    assertEq gotten expected

    let myRString2 = readRString "abb"
    let c = readRString "ab"
    let d = readRString "a"

    let gotten2 = apply myRString2 (Substitution[(c,d)])
    let expected2 = readRString "ab"
    assertEq gotten2 expected2

testRStringReplace = do
    putStr "\nRString -> Replace: "
    let myRString = readRString "edeferg"
    let replacement = readRString "re"

    let gotten = replace myRString [([2,2], replacement)]
    let expected = readRString "edreeferg"
    assertEq gotten expected

    let gotten2 = replace myRString [([2,4], replacement)]
    let expected2 = readRString "edreerg"
    assertEq gotten2 expected2

testRStringEvaluate = do
    putStr "\nRString -> Evaluate: "
    let myRString = readRString "wrrbbwrrwwbbwrbrbww"
    let gotten = evaluate myRString
    assertEq gotten myRString

testRStringRewrite = do
    putStr "\nRString -> rewrite: "
    let myStringSystem = readRStringSystem [("wb", "bw"), ("rb", "br"), ("rw", "wr")]
    let myStringSignature = [("b",0),("w",0),("r",0)]
    let myRString = readRString "wrrbbwrrwwbbwrbrbww"

    let gottenStr1 = rewrite myStringSystem myRString leftmost
    let expected1 = readRString "bbbbbbwwwwwwwrrrrrr"
    assertEq gottenStr1 expected1

    let gottenStr2 = rewrite myStringSystem myRString rightmost
    assertEq gottenStr2 expected1

testSymbols = do
    putStr "\nRString -> getSymbols: "
    let origStr1 = readRString "a1b2c13dez240"
    let expected1 = map(\x -> readRString x) ["a1","b2","c13","d","e","z240"]
    let gotten1 = getSymbols origStr1
    assertEq gotten1 expected1

    let origStr2 = readRString "abecedario"
    let expected2 = map(\x -> readRString x) ["a","b","e","c","e","d","a","r","i","o"]
    let gotten2 = getSymbols origStr2
    assertEq gotten2 expected2

testRStringOneStepRewrite = do
    putStr "\nRString -> oneStepRewrite: "
    let myStringSystem = readRStringSystem [("wb", "bw"), ("rb", "br"), ("rw", "wr")]
    let myStringSignature = [("b",0),("w",0),("r",0)]
    let myRString = readRString "wrrbbwrrwwbbwrbrbww"

    let gottenStr1 = oneStepRewrite myStringSystem myRString leftmost
    let expected1 = readRString "wrbrbwrrwwbbwrbrbww"
    assertEq gottenStr1 expected1

    let expected2 = readRString "wrrbbwrrwwbbwrbbrww"
    let gottenStr2 = oneStepRewrite myStringSystem myRString rightmost
    assertEq gottenStr2 expected2

testRStringnrewrite = do
    putStr "\nRString -> nrewrite: "
    let myStringSystem = readRStringSystem [("wb", "bw"), ("rb", "br"), ("rw", "wr")]
    let myStringSignature = [("b",0),("w",0),("r",0)]
    let myRString = readRString "wrrbbwrrwwbbwrbrbww"

    let gottenStr1 = nrewrite myStringSystem myRString leftmost 1
    let expected1 = readRString "wrbrbwrrwwbbwrbrbww"
    assertEq gottenStr1 expected1

    let expected2 = readRString "wrrbbwrrwwbbwrbbrww"
    let gottenStr2 = nrewrite myStringSystem myRString rightmost 1
    assertEq gottenStr2 expected2

    let gottenStr3 = nrewrite myStringSystem myRString leftmost 68
    let expected3 = readRString "bbbbbbwwwwwwrwrrrrr"
    assertEq gottenStr3 expected3

    let expected4 = readRString "bbbbbwbwwwwwwrrrrrr"
    let gottenStr4 = nrewrite myStringSystem myRString rightmost 68
    assertEq gottenStr4 expected4

testRStringValidRule = do
    putStr "\nRString -> validRule: "
    let myRule1 = readRuleRString ("wb", "bw")
    let myStringSignature = [("b",0),("w",0),("r",0)]
    let gotten = validRule myStringSignature myRule1
    assertTr gotten

    let myInvalidRule1 = readRuleRString ("a", "z")
    let gotten2 = validRule myStringSignature myInvalidRule1
    assertFa gotten2

    let myInvalidRule2 = readRuleRString ("", "")
    let gotten3 = validRule myStringSignature myInvalidRule2
    assertFa gotten3

testRStringValidRWS = do
    putStr "\nRString -> validRWS: "
    let myStringSystem = readRStringSystem [("wb", "bw"), ("rb", "br"), ("rw", "wr")]
    let myStringSignature = [("b",0),("w",0),("r",0)]
    let myRString = readRString "wrrbbwrrwwbbwrbrbww"
    let gotten = validRewriteSystem myStringSignature myStringSystem
    assertTr gotten

testRStringValidRString = do
    putStr "\nRString -> validRString: "
    let myStringSystem = readRStringSystem [("wb", "bw"), ("rb", "br"), ("rw", "wr")]
    let myStringSignature = [("b",0),("w",0),("r",0)]
    let myRString = readRString "wrrbbwrrwwbbwrbrbww"
    let gotten = valid myStringSignature myRString
    assertTr gotten

    let myRString2 = readRString "b1w2r3"
    let myInvalidStringSignature1 = [("b",0),("w",0),("r",0),("1",0),("2",0),("3",0)]
    let gotten2 = valid myInvalidStringSignature1 myRString2
    assertFa gotten2

    let myRString3 = readRString "b1w2r3"
    let myStringSignature2 = [("b1",0),("w2",0),("r3",0)]
    let gotten3 = valid myStringSignature2 myRString3
    assertTr gotten3

testRTermreadRTree = do
    putStr "\nRTerm -> readRTree: "
    let st = readRTree [("a",3),("b",1),("c",1),("d",0),("e",1),("f",1),("g",0),("h",1),("i",1),("j",0)]
    let d = Node(readTString "d", 0) []
    let g = Node(readTString "g", 0) []
    let j = Node(readTString "j", 0) []
    let c = Node(readTString "c", 0) [d]
    let f = Node(readTString "f", 0) [g]
    let i = Node(readTString "i", 0) [j]
    let b = Node(readTString "b", 0) [c]
    let e = Node(readTString "e", 0) [f]
    let h = Node(readTString "h", 0) [i]
    let expected = Node(readTString "a", 3) [b,e,h]
    assertEq st expected

    let st2 = readRTree [("a",1),("b",1),("c",1),("d",0)]
    let d1 = Node(readTString "d", 0) []
    let c1 = Node(readTString "c", 1) [d1]
    let b1 = Node(readTString "b", 1) [c1]
    let expected2 = Node(readTString "a", 1) [b1]
    assertEq st2 expected2

    let st3 = readRTree [("a",3),("b",0),("c",0),("d",0)]
    let d2 = Node(readTString "d", 0) []
    let c2 = Node(readTString "c", 0) []
    let b2 = Node(readTString "b", 0) []
    let expected3 = Node(readTString "a", 3) [b2,c2,d2]
    assertEq st3 expected3

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
    testRTermreadRTree
    putStr "\n--------------------------------------------------------------\n"

main = runtests
