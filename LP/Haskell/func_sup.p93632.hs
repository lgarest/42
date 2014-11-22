eql :: [Int] -> [Int] -> Bool
eql [] [] = True
eql [] b = False
eql a [] = False
eql a b = a == b
