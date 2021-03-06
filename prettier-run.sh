#!/bin/sh
jsfiles=$(find js -name "*.js" ! -path "js/backend-elm.js" ! -path "js/public/client-elm.js" ! -path "js/public/sigma/*"  | grep '\.jsx\?$' | tr '\n' ' ')
[ -z "$jsfiles" ] && exit 0

diffs=$(node_modules/.bin/prettier --write --single-quote --tab-width 4 $jsfiles)
[ -z "$diffs" ]
 exit 0
