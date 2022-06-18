-- Nathan Saric - 01/28/2022

module A1 where

-- Q1:
-- Add your student ID:
student_id :: Integer
student_id = 20099897

-- THIS FILE WILL NOT COMPILE UNTIL YOU ADD YOUR STUDENT ID ABOVE 

{-
Q2:
   samesign m n == True
   if and only if
   m and n have the same sign:
     if m and n are both less than or equal to zero, return True;
     if m and n are both greater than or equal to zero, return True;
     otherwise, return False.
-}

samesign :: Integer -> Integer -> Bool
samesign m n =
  if ((m <= 0) && (n <= 0)) || ((m >= 0) && (n >= 0)) then True
  else False

-- Testing samesign:
test_samesign1, test_samesign2, test_samesign3, test_samesign :: Bool
test_samesign1 = (samesign 5 2) == True
test_samesign2 = (samesign 1 (-1)) == False
test_samesign3 = (samesign (-2) 0) == True

test_samesign  = test_samesign1 && test_samesign2 && test_samesign3

{-
Q3:
  Write a function `spiral' that, given a pair of numbers `dir' and `span',
  returns 0 if `span' equals 0,
  and otherwise returns (span - dir) + spiral (0 - dir, span - 1).
-}

spiral :: (Integer, Integer) -> Integer
spiral (dir, span) = 
  if (span == 0) then 0
  else (span - dir) + spiral (0 - dir, span - 1)
  
-- Testing spiral:
test_spiral1, test_spiral2, test_spiral3, test_spiral :: Bool
test_spiral1 = (spiral (0, 32)  == 528)
test_spiral2 = (spiral (-32, 5) == 47)
test_spiral3 = (spiral (51252, 7)  == -51224)

test_spiral  = test_spiral1 && test_spiral2 && test_spiral3

{-
Q4: 
  spiral_seq n == string containing results of spiral (1, n) for 1, ..., n
                   separated by commas

  For example,  spiral_seq 3  should return  "0,3,5"
    because spiral (1, 1) returns 0,
            spiral (1, 2) returns 3,
        and spiral (1, 3) returns 5.

  If n < 1, spiral_seq should return the empty string: ""
  
  Hints:
     1. The built-in function  show  converts an integer to its representation as a string.

     2. You can use the built-in function  ++  to concatenate strings.
          For example, "10" ++ "," == "10,".

     3. You may want to define a helper function for spiral_seq to call.
-}

spiral_seq :: Integer -> String
spiral_seq n = 
  if (n > 1) then spiral_seq (n - 1) ++ "," ++ show (spiral (1, n))
  else if (n == 1) then show (spiral (1, n))
  else ""

-- Testing spiral_seq:
test_spiral_seq1, test_spiral_seq2, test_spiral_seq3, test_spiral_seq :: Bool
test_spiral_seq1 = (spiral_seq 3  == "0,3,5")
test_spiral_seq2 = (spiral_seq (-2) == "")
test_spiral_seq3 = (spiral_seq 1  == "0")

test_spiral_seq  = test_spiral_seq1 && test_spiral_seq2 && test_spiral_seq3

{-
Q5: Stepping

   Give your answers by filling in the blanks below,
   and including the substitution in function application steps, as described.

Q5.1: Replace the underlines (_______).

     expression                 justification

     (\q -> 1 - (q * 9)) 2
  => 1 - (2 * 9)                by function application 
                                with 2 for q
  => 1 - 18                     by arithmetic
  => -17                        by arithmetic

  For full marks, state the substitution in the function application step for example:

  "...                          by function application
                                with 500 for q"
                                     ^^^^^^^^^
                          "500 for q" is the substitution

Q5.2: Replace the underlines (_______).
      Assume a function `decr' has been defined:

        decr :: Integer -> Integer
        decr x = x - 1
 
     expression                            justification

     (\g -> (\z -> g 5)) decr 2
  => (\z -> decr 5) 2                      by function application
                                           with decr for g
  => decr 5                                by function application
                                           with 2 for z
  = (\x -> x - 1) 5                        equivalent by the definition of 'decr'
  => 5 - 1                                 by function application
                                           with 5 for x
  => 4                                     by arithmetic

  For full marks, state the substitution in all function application steps.
-} 
