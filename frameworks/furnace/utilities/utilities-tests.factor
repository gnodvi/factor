USING: furnace.utilities io.encodings.utf8 io.files io.files.temp kernel
multiline parser tools.test webapps.counter ;
in: furnace.utilities.tests

<<
STRING: dummy-vocab
in: dummy-vocab

: dummy-word ( -- ) ;
;

dummy-vocab "dummy.factor" temp-file [ utf8 set-file-contents ] keep run-file
>>

{ t } [
    use: dummy-vocab
    { dummy-word "index" } resolve-template-path "index" temp-file =
] unit-test

{ "resource:extra/webapps/counter/counter" } [
    { counter-app "counter" } resolve-template-path
] unit-test
