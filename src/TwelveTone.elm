module TwelveTone exposing (noteToPc, listToPcs, normalizedPcs, retrogradeRow,
  transposeRow, invertRow, retrogradeInvertRow, rowMatrix)
import List exposing (map, head, reverse)

type alias Note = Int
type alias Pc = Int

noteToPc : Note -> Pc
noteToPc note =
  note % 12

listToPcs : List Note  -> List Pc
listToPcs notes =
  map noteToPc notes

normalizedPcs : List Note  -> List Pc
normalizedPcs notes =
  let
    first = head notes
  in
    case first of
      Just f -> map (\note -> noteToPc (note - f)) notes
      Nothing -> []

retrogradeRow : List Pc -> List Pc
retrogradeRow row =
  reverse row

type alias Interval = Int
transposeRow : List Pc -> Interval -> List Pc
transposeRow row ivl =
  map (\pc -> noteToPc (pc + ivl)) row

invertRow : List Pc -> List Pc
invertRow row =
  map (\pc -> noteToPc (12 - pc)) row

retrogradeInvertRow : List Pc -> List Pc
retrogradeInvertRow row =
  retrogradeRow (invertRow row)

rowMatrix : List Pc -> List (List Pc)
rowMatrix row =
  map (\i -> (transposeRow row i)) (invertRow row)
