! Copyright (C) 2009 Philipp Brüschweiler
! See http://factorcode.org/license.txt for BSD license.
USING: infix infix.private kernel locals math math.functions
tools.test ;
IN: infix.tests

{ 0 } [ infix[[ 0 ]] ] unit-test
{ 0.5 } [ infix[[ 3.0/6 ]] ] unit-test
{ 1+2/3 } [ infix[[ 5/3 ]] ] unit-test
{ 3 } [ infix[[ 2*7%3+1 ]] ] unit-test
{ 1419857 } [ infix[[ 17**5 ]] ] unit-test
{ 1 } [ infix[[ 2-
     1
     -5*
     0 ]] ] unit-test

{ 0.0 } [ infix[[ sin(0) ]] ] unit-test
{ 10 } [ infix[[ lcm(2,5) ]] ] unit-test
{ 1.0 } [ infix[[ +cos(-0*+3) ]] ] unit-test

{ f } [ 2 \ gcd check-word ] unit-test ! multiple return values
{ f } [ 1 \ drop check-word ] unit-test ! no return value
{ f } [ 1 \ lcm check-word ] unit-test ! takes 2 args

: qux ( -- x ) 2 ;
{ t } [ 0 \ qux check-word ] unit-test
{ 8 } [ infix[[ qux()*3+2 ]] ] unit-test
: foobar ( x -- y ) 1 + ;
{ t } [ 1 \ foobar check-word ] unit-test
{ 4 } [ infix[[ foobar(3*5%12) ]] ] unit-test
: stupid_function ( x x x x x -- y ) + + + + ;
{ t } [ 5 \ stupid_function check-word ] unit-test
{ 10 } [ infix[[ stupid_function (0, 1, 2, 3, 4) ]] ] unit-test

{ -1 } [ let[ 1 set: a infix[[ -a ]] ] ] unit-test

{ char: f } [ let[ "foo" set: s infix[[ s[0] ]] ] ] unit-test
{ char: r } [ let[ "bar" set: s infix[[ s[-1] ]] ] ] unit-test
{ "foo" } [ let[ "foobar" set: s infix[[ s[0:3] ]] ] ] unit-test
{ "foo" } [ let[ "foobar" set: s infix[[ s[:3] ]] ] ] unit-test
{ "bar" } [ let[ "foobar" set: s infix[[ s[-3:] ]] ] ] unit-test
{ "boof" } [ let[ "foobar" set: s infix[[ s[-3::-1] ]] ] ] unit-test
{ "foobar" } [ let[ "foobar" set: s infix[[ s[:] ]] ] ] unit-test
{ "foa" } [ let[ "foobar" set: s infix[[ s[::2] ]] ] ] unit-test
{ "bar" } [ let[ "foobar" set: s infix[[ s[-3:100] ]] ] ] unit-test
{ "foobar" } [ let[ "foobar" set: s infix[[ s[-100:100] ]] ] ] unit-test
{ "olh" } [ let[ "hello" set: s infix[[ s[4::-2] ]] ] ] unit-test
{ "rb" } [ let[ "foobar" set: s infix[[ s[:1:-2] ]] ] ] unit-test
{ "foa" } [ let[ "foobar" set: s infix[[ s[:-1:2] ]] ] ] unit-test
{ "rbo" } [ let[ "foobar" set: s infix[[ s[::-2] ]] ] ] unit-test
{ "rbo" } [ let[ "foobar" set: s infix[[ s[:0:-2] ]] ] ] unit-test
{ "rb" } [ let[ "foobar" set: s infix[[ s[:-5:-2] ]] ] ] unit-test

INFIX:: foo ( x y -- z ) x**2-abs(y) ;

{ 194 } [ 15 31 foo ] unit-test