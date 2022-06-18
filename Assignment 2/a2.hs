-- Nathan Saric - 02/15/2022

module A2 where
import Data.Char

-- Q1:
-- Add your student ID:
student_id :: Integer
student_id = 20099897

-- THIS FILE WILL NOT COMPILE UNTIL YOU ADD YOUR STUDENT ID ABOVE.

{-
   Q2: rewrite
-}

divisible_by :: Int -> Char -> Bool
divisible_by factor ch = (mod (ord ch) factor == 0)

rewrite :: (Char -> Bool) -> String -> String
rewrite boring []       = []
rewrite boring (c : cs) = 
  if (boring c) then (rewrite boring cs)
  else [c] ++ (rewrite boring cs)

test_rewrite1 = (rewrite (divisible_by 2) "Queen's") == "Quee's"
test_rewrite2 = (rewrite (\x -> x == ' ') "take it in tow") == "takeitintow"
test_rewrite3 = (rewrite (\c -> (c > 'a')) "sIlLy CaPiTaLiZaTiOn") == "IL CaPTaLZaTO"

test_rewrite = test_rewrite1 && test_rewrite2 && test_rewrite3

{-
  Q3: lists
-}

{-
  Q3a. Fill in the definition of listCompare.
  See a2.pdf for instructions.
-}

listCompare :: ([Integer], [Integer]) -> [Bool]
listCompare ([],   []  )   = []
listCompare (x:xs, y:ys)   = [x /= y] ++ listCompare (xs, ys)
listCompare (x:xs, []  )   = [False]  ++ listCompare (xs, [])
listCompare ([],   y:ys)   = [False]  ++ listCompare ([], ys)

test_listCompare1 = listCompare ([1, 2, 4], [3, 2, 0]) == [True, False, True]
test_listCompare2 = listCompare ([1, 2, 1, 1], [1, 5]) == [False, True, False, False]
test_listCompare3 = listCompare ([1, 1], [1, 1, 1, 1]) == [False, False, False, False]

test_listCompare = test_listCompare1 && test_listCompare2 && test_listCompare3

{-
  Q3b.
  Briefly explain why listCompare cannot
  be implemented by

    listCompare :: ([Integer], [Integer]) -> [Bool]
    listCompare (xs, ys) = zipWith (/=) xs ys

  Write your brief explanation here:
    listCompare cannot be implented using zipWith because the function only iterates
    over the smallest list passed and does not consider lists of different lengths. 
    This is equivalent to only the first and second clauses of the working listCompare 
    function. The third and fourth clauses take into account when the first list and 
    second list are of different length, in which the result is padded with False, so 
    that the result list is as long as the longest list passed. 
-}

{-
  Q3c. Fill in the definition of polyCompare.
  See a2.pdf for instructions.
-}

polyCompare :: (a -> a -> Bool, [a], [a]) -> [Bool]
polyCompare (eq, [],   []  )   = []
polyCompare (eq, x:xs, y:ys)   = [eq x y] ++ polyCompare (eq, xs, ys)
polyCompare (eq, x:xs, []  )   = [False]   ++ polyCompare (eq, xs, [])
polyCompare (eq, [],   y:ys)   = [False]   ++ polyCompare (eq, [], ys)

test_polyCompare1 = polyCompare (\i -> \j -> i /= j, [1, 2, 4], [3, 2, 0])
                    == [True, False, True]

-- whoever calls polyCompare gets to define what "different" means:
--  in test_polyCompare2, the definition of "different" becomes whether two lists (here, strings) have different lengths, regardless of the lists' contents
lengthsEqual :: [a] -> [a] -> Bool
lengthsEqual xs ys = (length xs /= length ys)
test_polyCompare2 = polyCompare (lengthsEqual, ["a", "ab", "abcd"], ["ccc", "xy", ""])
                    == [True, False, True]

test_polyCompare = test_polyCompare1 && test_polyCompare2

{-
  Q4. Songs
-}

data Song = Harmony Song Song
          | Pitch Integer
          | Stop
          deriving (Show, Eq)    -- writing Eq here lets us use == to compare Songs
          
{-
  Q4. sing: See a2.pdf for complete instructions.

  The idea of 'sing' is to apply the "harmonizing rule" as much as possible: wherever the tree has

      Harmony
      /     \
  Pitch m   Pitch n

  replace that with  Pitch (m * n).  Repeat until the harmonizing rule cannot be applied anywhere.

  For example:

    sing (Harmony (Harmony (Pitch 2) (Pitch 10)) (Pitch 6))

  should return

    (Pitch 120)

  because:

  - harmonizing (Harmony (Pitch 2) (Pitch 10)) should give (Pitch 20), and
  - harmonizing (Harmony (Pitch 20) (Pitch 6)) should give (Pitch 120).

  sing (Harmony Stop (Harmony (Pitch 2) (Pitch 4)))

  should return

     Harmony Stop (Pitch 8)

  because we can harmonize (Harmony (Pitch 2) (Pitch 4)) into Pitch 8, but the Stop cannot be harmonized.

  You will probably need to write at least one helper function.
  Think about whether we can break the problem down into
  a helper function that applies the harmonizing rule *once*, or "a few times",
  and then have 'sing' call that function.
-}

sing :: Song -> Song
sing s = 
  if (s == helper s) then s
  else sing(helper s)

helper :: Song -> Song
helper Stop = Stop
helper (Pitch m) = (Pitch m)
helper (Harmony (Pitch m) (Pitch n)) = Pitch(m * n)
helper (Harmony song1 song2) = (Harmony (helper song1) (helper song2))

p2 = Pitch 2
p6 = Pitch 6
p10 = Pitch 10
test_sing1 = sing (Harmony (Harmony p2 p10) (Pitch 6)) ==
             Pitch 120
test_sing2 = sing (Harmony Stop (Harmony p2 (Pitch 4))) ==
             Harmony Stop (Pitch 8)
test_sing3 = sing (Harmony (Harmony (Harmony p2 p6) (Harmony Stop p10)) p6) ==
             Harmony (Harmony (Pitch 12) (Harmony Stop p10)) p6
test_sing4 = sing (Harmony (Harmony (Harmony p2 p6) (Harmony p10 p10)) p6) ==
             Pitch 7200

test_sing = test_sing1 && test_sing2 && test_sing3 && test_sing4
