# Test first elm

Read this at medium: https://medium.com/@danigb/test-first-elm-5d5cceea0efc#.bpr6l1yxy

I've started to learn elm-lang. It's seems to be a wondeful but strange language for people like me coming from an imperative (and mostly object oriented) languages background.

While REPLs are great to do exploratory work and understand how things works in a programming language I'm more used to test driven approach that allows that exploratory approach with the adventage of persisted files (so I can come back to remember what I did).

Surprisely I didn't found a quick guide to test driven elm programming (probably tests are not as fundamental in elm as in other languages due it's strong types nature). Anyway, this is my two cents.

## Etudes Op. 1: Twelve tone

I'm reading "Notes from the Metalevel: An Introduction to Computer Composition" so, for the test I'll steal some examples from Chapter 9 that implements some basic [twelve-tone](https://en.wikipedia.org/wiki/Twelve-tone_technique) and [set-theory] functions. If you don't know what is all about, don't worry, they are very simple functions.

The book it's used to be online, but I can't found it now. If you're interested, you can read an excerpt from the [Chapter 9 here](https://github.com/danigb/elm-twelve-tone/blob/master/ch9.pdf) but it's not necessary at all to follow this tutorial.

## Project setup

First thing to do is install elm 0.17. This is the latest version at the time of this writing and it brings big changes, starting with elm lang internals and covering elm package names, so it's important to ensure you have this version installed.

Then, we will use `elm-package` cli to generate the `elm-package.json` automatically and download the dependencies (we'll use `elm-lang/core` and `elm-community/test` packages):

```bash
mkdir elm-twelve-tone
cd elm-twelve-tone
mkdir src # source files will be here
mkdir test # test files will be here
elm-package install -y elm-lang/core
elm-package install -y elm-community/test
```

The `-y` option allows `elm-package` to do it's work without asking questions, but it's completely optional.

## Write the first test

The first function will convert from midi note numbers to pitch class numbers. In test driven programming, we start writing the test, so here is our first `test/TwelveToneTest.elm` attempt:

```elm
import ElmTest exposing (..)

tests : Test
tests =
  suite "Chapter 9: Etudes, Op. 3: Iteration, Rows and Sets"
  [
    test "noteToPc" (assertEqual 7 (noteToPc 55))
  ]

main =
    runSuite tests
```

Nothing very fancy here: just importing ElmTest (from `elm-community/test`), create a function that returns a `suite` of tests and declaring a `main` function that uses `runSuite` to run the tests.

Notice that, unlike Javascript, the expected value goes on the left. This is not important to pass the test, but matters when dealing with test assertion errors.

## Run tests

To run the tests we need first to compile to javascript (using `elm-make`) and then run the result with `node`. Let's make a script:

```sh
#!/bin/bash
mkdir -p tmp
rm tmp/run.js
elm-make test/TwelveToneTest.elm --output tmp/run.js
node tmp/run.js
```

Elm is well known for it's detailed and helpful error messages. Here's our:

```
-- NAMING ERROR ---------------------------------------- test/TwelveToneTest.elm

Cannot find variable `noteToPc`

7|           test "noteToPc" (assertEqual 7 (noteToPc 55))
                                             ^^^^^^^^
```

## Write the actual code

Let's write the actual code. The pitch class numbers are just the note numbers without the octave information. Since there are 12 notes per octave, and for each octave the first pitch class is 0 and the last is 11, we just only need to apply module operator:

```elm
module TwelveTone exposing (noteToPc)

type alias Note = Int
type alias Pc = Int

noteToPc : Note -> Pc
noteToPc note =
  note % 12
```

As you can see, I defined a couple of type aliases, just to be clear about the purpose of the function.

## Import module

Since we are storing the `TwelveTone.elm` source code into the `src/` directory, we need first to change the the `elm-package.json` file so `source-directories` is `["src/"]`.

Now we can import the module into the tests:

```elm
import ElmTest exposing (..)
import TwelveTone exposing (..)

tests : Test
tests =
  suite "Chapter 9: Etudes, Op. 3: Iteration, Rows and Sets"
  [
    test "noteToPc" (assertEqual 7 (noteToPc 55))
  ]

main =
    runSuite tests
```

If we run the tests now we'll see "All tests passed" message.

## Coda: Learn some elm

Remember the purpose of this setup is to do some exploratory programming and learn some test. Let's try it by implement a couple of functions from the book chapter. First a function to convert from a list of note numbers to a list of pitch class numbers. Test first:

```elm
test "listToPcs" (assertEqual [7,10,2,6] (listToPcs [55,58,62,66]))
```

Then the code:

```elm
import List exposing (map)

...
listToPcs : List(Note) -> List Pc
listToPcs notes =
  map noteToPc notes
```

Pretty straightforward. Just remember to import [map](http://package.elm-lang.org/packages/elm-lang/core/4.0.1/List#map) function from [List](http://package.elm-lang.org/packages/elm-lang/core/4.0.1/List) module.

But the next one is more tricky. We want to _normalize_ the pitch class notes, so always this first note of the list is 0 and the rest are relative to that one. Here's the test:

```elm
test "normalizedPcs" (assertEqual [0,3,7,11] (normalizedPcs [55,58,62,66]))
```

Basically, we want to substract the first element of the list to the rest of the elements. In my first attempt I would write something like this:

```elm
import List exposing (map, head)

...
normalizedPcs : List(Note) -> List Pc
normalizedPcs notes =
  let
    first = head notes
  in
    map (\note -> noteToPc (note - first)) notes
```

The `(\param -> body)` construct is just an anonymouse function that receives a note and returns the pitch class number of the result of substract the first element of the list to the note. And then we map the notes with the function.

Let's run our tests:

```
-- TYPE MISMATCH ------------------------------------------ ./src/TwelveTone.elm

The right argument of (-) is causing a type mismatch.

22|                             note - first)
                                       ^^^^^
(-) is expecting the right argument to be a:

    number

But the right argument is:

    Maybe a

Hint: I always figure out the type of the left argument first and if it is
acceptable on its own, I assume it is "correct" in subsequent checks. So the
problem may actually be in how the left and right arguments interact.
```

The problem is that `head` doesn't return an integer as expected, but a `Maybe(Int)`. If we don't get an integer is because the list is empty, so we should return an empty list. `case` to the rescue:

```elm
normalizedPcs : List(Note) -> List Pc
normalizedPcs notes =
  let
    first = head notes
  in
    case first of
      Just f -> map (\note -> noteToPc (note - f)) notes
      Nothing -> []
```

This is a very common pattern when dealing with [`Maybe`](http://package.elm-lang.org/packages/elm-lang/core/4.0.1/Maybe).

## The full score

You can get the full source code at [elm-twelve-tone](https://github.com/danigb/elm-twelve-tone). I hope you find it useful.
