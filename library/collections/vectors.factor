! Copyright (C) 2004, 2005 Slava Pestov.
! See http://factor.sf.net/license.txt for BSD license.
IN: vectors
USING: errors generic kernel kernel-internals lists math
math-internals sequences ;

DEFER: vector?
BUILTIN: vector 11 vector?
    [ 1 length set-capacity ]
    [ 2 underlying set-underlying ] ;

M: vector set-length ( len vec -- )
    growable-check 2dup grow set-capacity ;

M: vector nth ( n vec -- obj )
    bounds-check underlying array-nth ;

M: vector set-nth ( obj n vec -- )
    growable-check 2dup ensure underlying set-array-nth ;

M: vector hashcode ( vec -- n )
    dup length 0 number= [ drop 0 ] [ first hashcode ] ifte ;
