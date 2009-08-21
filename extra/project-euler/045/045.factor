! Copyright (c) 2008 Aaron Schaefer.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel math project-euler.common ;
IN: project-euler.045

! http://projecteuler.net/index.php?section=problems&id=45

! DESCRIPTION
! -----------

! Triangle, pentagonal, and hexagonal numbers are generated by the following
! formulae:
!     Triangle     Tn = n(n + 1) / 2    1, 3,  6, 10, 15, ...
!     Pentagonal   Pn = n(3n − 1) / 2   1, 5, 12, 22, 35, ...
!     Hexagonal    Hn = n(2n − 1)       1, 6, 15, 28, 45, ...

! It can be verified that T285 = P165 = H143 = 40755.

! Find the next triangle number that is also pentagonal and hexagonal.


! SOLUTION
! --------

! All hexagonal numbers are also triangle numbers, so iterate through hexagonal
! numbers until you find one that is pentagonal as well.

<PRIVATE

: nth-hexagonal ( n -- m )
    dup 2 * 1 - * ;

DEFER: next-solution

: (next-solution) ( n hexagonal -- hexagonal )
    dup pentagonal? [ nip ] [ drop next-solution ] if ;

: next-solution ( n -- m )
    1 + dup nth-hexagonal (next-solution) ;

PRIVATE>

: euler045 ( -- answer )
    143 next-solution ;

! [ euler045 ] 100 ave-time
! 12 ms ave run time - 1.71 SD (100 trials)

SOLUTION: euler045
