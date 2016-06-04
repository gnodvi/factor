USING: assocs kernel sequences tools.test ;

in: tools.completion

{ f } [ "abc" "def" fuzzy ] unit-test
{ V{ 4 5 6 } } [ "set-nth" "nth" fuzzy ] unit-test

{ { { 0 } { 4 5 6 } } } [ V{ 0 4 5 6 } runs [ { } like ] map ] unit-test

{ { "nth" "?nth" "set-nth" } } [
    "nth" { "set-nth" "nth" "?nth" } dup zip completions keys
] unit-test

{ { "a" "b" "c" "d" "e" "f" "g" } } [
    "" { "a" "b" "c" "d" "e" "f" "g" } dup zip completions keys
] unit-test

{ f } [ { "use:" "A" "B" "C" } complete-vocab? ] unit-test
{ f } [ { "use:" "A" "B" } complete-vocab? ] unit-test
{ f } [ { "use:" "A" "" } complete-vocab? ] unit-test
{ t } [ { "use:" "A" } complete-vocab? ] unit-test
{ t } [ { "use:" "" } complete-vocab? ] unit-test
{ f } [ { "use:" } complete-vocab? ] unit-test
{ t } [ { "unuse:" "A" } complete-vocab? ] unit-test
{ t } [ { "QUALIFIED:" "A" } complete-vocab? ] unit-test
{ t } [ { "QUALIFIED-WITH:" "A" } complete-vocab? ] unit-test
{ t } [ { "USING:" "A" "B" "C" } complete-vocab? ] unit-test
{ f } [ { "USING:" "A" "B" "C" ";" } complete-vocab? ] unit-test
{ t } [ { "X" ";" "USING:" "A" "B" "C" } complete-vocab? ] unit-test

{ f } [ { "char:" } complete-char? ] unit-test
{ t } [ { "char:" "" } complete-char? ] unit-test
{ t } [ { "char:" "a" } complete-char? ] unit-test
