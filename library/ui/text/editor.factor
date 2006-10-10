! Copyright (C) 2006 Slava Pestov
! See http://factorcode.org/license.txt for BSD license.
IN: gadgets-text
USING: arrays errors freetype gadgets gadgets-borders
gadgets-buttons gadgets-frames gadgets-labels
gadgets-scrolling gadgets-theme io kernel math models namespaces
opengl sequences strings styles ;

TUPLE: editor
font color caret-color selection-color
caret mark
focused? ;

TUPLE: loc-monitor editor ;

: <loc> ( editor -- loc )
    <loc-monitor> { 0 0 } <model> [ add-connection ] keep ;

: init-editor-locs ( editor -- )
    dup <loc> over set-editor-caret
    dup <loc> swap set-editor-mark ;

C: editor ( -- editor )
    dup <document> <gadget> delegate>control
    dup init-editor-locs
    dup editor-theme ;

: activate-editor-model ( editor model -- )
    dup activate-model swap control-model add-loc ;

: deactivate-editor-model ( editor model -- )
    dup deactivate-model swap control-model remove-loc ;

M: editor graft*
    dup dup editor-caret activate-editor-model
    dup dup editor-mark activate-editor-model
    dup control-self swap control-model add-connection ;

M: editor ungraft*
    dup dup editor-caret deactivate-editor-model
    dup dup editor-mark deactivate-editor-model
    dup control-self swap control-model remove-connection ;

M: editor model-changed
    control-self dup control-model
    over editor-caret [ over validate-loc ] (change-model)
    over editor-mark [ over validate-loc ] (change-model)
    drop relayout ;

: editor-caret* editor-caret model-value ;

: editor-mark* editor-mark model-value ;

: change-caret ( editor quot -- )
    over >r >r dup editor-caret* swap control-model r> call r>
    [ control-model validate-loc ] keep
    editor-caret set-model* ; inline

: mark>caret ( editor -- )
    dup editor-caret* swap editor-mark set-model* ;

: change-caret&mark ( editor quot -- )
    over >r change-caret r> mark>caret ; inline

: editor-line ( n editor -- str ) control-value nth ;

: editor-font* ( editor -- font ) editor-font lookup-font ;

: line-height ( editor -- n )
    editor-font* font-height ;

: run-char-widths ( str editor -- wlist )
    #! List of x co-ordinates of each character.
    editor-font* swap >array [ char-width ] map-with
    dup 0 [ + ] accumulate nip swap 2 v/n v+ ;

: x>offset ( x line# editor -- col# )
    [ editor-line ] keep
    over >r run-char-widths [ <= ] find-with drop dup -1 =
    [ drop r> length ] [ r> drop ] if ;

: y>line ( y editor -- line# )
    [ line-height / >fixnum ] keep control-model validate-line ;

: point>loc ( point editor -- loc )
    over second over y>line [
        >r >r first r> r> swap x>offset
    ] keep swap 2array ;

: click-loc ( editor model -- )
    >r [ hand-rel ] keep point>loc r> set-model* ;

: focus-editor ( editor -- )
    t over set-editor-focused? relayout-1 ;

: unfocus-editor ( editor -- )
    f over set-editor-focused? relayout-1 ;

: (offset>x) ( font col# str -- x )
    swap head-slice string-width ;

: offset>x ( col# line# editor -- x )
    [ editor-line ] keep editor-font* -rot (offset>x) ;

: loc>x ( loc editor -- x ) >r first2 swap r> offset>x ;

: line>y ( lines# editor -- y )
    line-height * ;

: caret-loc ( editor -- loc )
    [ editor-caret* ] keep 2dup loc>x
    rot first rot line>y 2array ;

: caret-dim ( editor -- dim )
    line-height 0 swap 2array ;

: scroll>caret ( editor -- )
    dup gadget-grafted? [
        dup caret-loc over caret-dim { 1 0 } v+ <rect>
        over scroll>rect
    ] when drop ;

M: loc-monitor model-changed
    loc-monitor-editor control-self
    dup relayout-1 scroll>caret ;

: draw-caret ( -- )
    editor get editor-focused? [
        editor get
        dup editor-caret-color gl-color
        dup caret-loc swap caret-dim over v+ gl-line
    ] when ;

: translate-lines ( n -- )
    editor get line-height * 0.0 swap 0.0 glTranslated ;

: draw-line ( editor str -- )
    over editor-color gl-color
    >r editor-font r> draw-string ;

: first-visible-line ( editor -- n )
    clip get rect-loc second origin get second -
    swap y>line ;

: last-visible-line ( editor -- n )
    clip get rect-extent nip second origin get second -
    swap y>line 1+ ;

: with-editor ( editor quot -- )
    [
        swap
        dup first-visible-line \ first-visible-line set
        dup last-visible-line \ last-visible-line set
        dup control-model document set
        editor set
        call
    ] with-scope ; inline

: visible-lines ( editor -- seq )
    \ first-visible-line get
    \ last-visible-line get
    rot control-value <slice> ;

: draw-lines ( -- )
    GL_MODELVIEW [
        \ first-visible-line get translate-lines
        editor get dup visible-lines
        [ draw-line 1 translate-lines ] each-with
    ] do-matrix ;

: selection-start/end ( editor -- start end )
    dup editor-mark* swap editor-caret*
    2dup <=> 0 > [ swap ] when ;

: (draw-selection) ( x1 x2 -- )
    2dup = [ 2 + ] when
    0.0 swap editor get line-height glRectd ;

: draw-selected-line ( start end n -- )
    [ start/end-on-line ] keep tuck
    >r >r editor get offset>x r> r>
    editor get offset>x
    (draw-selection) ;

: draw-selection ( -- )
    GL_MODELVIEW [
        editor get
        dup editor-selection-color gl-color
        selection-start/end
        over first translate-lines
        2dup [
            >r 2dup r> draw-selected-line
            1 translate-lines
        ] each-line 2drop
    ] do-matrix ;

M: editor draw-gadget*
    [ draw-selection draw-lines draw-caret ] with-editor ;

: editor-height ( editor -- n )
    [ control-value length ] keep line>y ;

: editor-width ( editor -- n )
    0 swap dup editor-font* swap control-value
    [ string-width max ] each-with ;

M: editor pref-dim*
    dup editor-width swap editor-height 2array ;

M: editor gadget-selection?
    selection-start/end = not ;

M: editor gadget-selection
    [ selection-start/end ] keep control-model doc-range ;

: remove-editor-selection ( editor -- )
    [ selection-start/end ] keep control-model
    remove-doc-range ;

M: editor user-input*
    [ selection-start/end ] keep control-model set-doc-range t ;

: editor-text ( editor -- str )
    control-model doc-text ;

: set-editor-text ( str editor -- )
    control-model set-doc-text ;

! Editors support the stream output protocol
M: editor stream-write1 >r ch>string r> stream-write ;

M: editor stream-write control-self user-input ;

M: editor stream-close drop ;
