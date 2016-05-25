#!/bin/bash
mkdir -p tmp
rm tmp/run.js
elm-make test/TwelveToneTest.elm --output tmp/run.js
node tmp/run.js
