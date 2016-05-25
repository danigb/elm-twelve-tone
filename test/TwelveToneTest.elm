import ElmTest exposing (..)
import TwelveTone exposing (..)

albansNotes = [55,58,62,66,69,72,76,80,83,85,87,89]
albansRow = normalizedPcs albansNotes

tests : Test
tests =
  suite "Chapter 9: Etudes, Op. 3: Iteration, Rows and Sets"
  [
    test "noteToPc" (assertEqual 7 (noteToPc 55)),
    test "listToPcs" (assertEqual [7,10,2,6,9,0,4,8,11,1,3,5] (listToPcs albansNotes)),
    test "normalizedPcs" (assertEqual [0,3,7,11,2,5,9,1,4,6,8,10] (normalizedPcs albansNotes)),
    test "retrogradeRow" (assertEqual [10,8,6,4,1,9,5,2,11,7,3,0] (retrogradeRow albansRow)),
    test "transposeRow" (assertEqual [3,6,10,2,5,8,0,4,7,9,11,1] (transposeRow albansRow 3)),
    test "invertRow" (assertEqual [0,9,5,1,10,7,3,11,8,6,4,2] (invertRow albansRow)),
    test "retrogradeInvertRow" (assertEqual [2,4,6,8,11,3,7,10,1,5,9,0] (retrogradeInvertRow albansRow)),
    test "rowMatrix" (assertEqual [
      [0,3,7,11,2,5,9,1,4,6,8,10],[9,0,4,8,11,2,6,10,1,3,5,7],
      [5,8,0,4,7,10,2,6,9,11,1,3],[1,4,8,0,3,6,10,2,5,7,9,11],
      [10,1,5,9,0,3,7,11,2,4,6,8],[7,10,2,6,9,0,4,8,11,1,3,5],
      [3,6,10,2,5,8,0,4,7,9,11,1],[11,2,6,10,1,4,8,0,3,5,7,9],
      [8,11,3,7,10,1,5,9,0,2,4,6],[6,9,1,5,8,11,3,7,10,0,2,4],
      [4,7,11,3,6,9,1,5,8,10,0,2],[2,5,9,1,4,7,11,3,6,8,10,0]
    ] (rowMatrix albansRow))
  ]

main =
    runSuite tests
