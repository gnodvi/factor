! Copyright (C) 2009, 2010 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors arrays sequences sorting assocs colors.constants fry
combinators combinators.smart combinators.short-circuit editors make
memoize compiler.units fonts kernel io.pathnames prettyprint
source-files.errors source-files.errors.debugger math.parser init math.order
models models.arrow models.arrow.smart models.search models.mapping debugger
namespaces summary locals ui ui.commands ui.gadgets ui.gadgets.panes
ui.gadgets.tables ui.gadgets.labeled ui.gadgets.tracks ui.gestures
ui.operations ui.tools.browser ui.tools.common ui.gadgets.scrollers
ui.tools.inspector ui.gadgets.buttons ui.gadgets.borders ui.gadgets.labels
ui.gadgets.packs ui.theme ui.gadgets.toolbar ui.gadgets.status-bar
ui.baseline-alignment ui.images
compiler.errors tools.errors tools.errors.model ;
IN: ui.tools.error-list

CONSTANT: source-file-icon
    T{ image-name f "vocab:ui/tools/error-list/icons/source-file.tiff" } ;

MEMO: error-icon ( type -- image-name )
    error-icon-path <image-name> ;

: <checkboxes> ( alist -- gadget )
    [ <shelf> { 15 0 } >>gap ] dip
    [ swap <checkbox> add-gadget ] assoc-each ;

: <error-toggle> ( -- model gadget )
    ! Linkage errors are not shown by default.
    error-types get [ fatal?>> <model> ] assoc-map
    [ [ [ error-icon ] dip ] assoc-map <checkboxes> ]
    [ <mapping> ] bi ;

TUPLE: error-list-gadget < tool
visible-errors source-file error
error-toggle source-file-table error-table error-display ;

SINGLETON: source-file-renderer

M: source-file-renderer row-columns
    drop first2 [
        [ source-file-icon ]
        [ +listener-input+ or ]
        [ length number>string ] tri*
    ] output>array ;

M: source-file-renderer prototype-row
    drop source-file-icon "" "" 3array ;

M: source-file-renderer row-value
    drop dup [ first [ <pathname> ] [ f ] if* ] when ;

M: source-file-renderer row-value? row-value = ;

M: source-file-renderer column-titles
    drop { "" "File" "Errors" } ;

M: source-file-renderer column-alignment drop { 0 0 1 } ;

M: source-file-renderer filled-column drop 1 ;

: <source-file-model> ( model -- model' )
    [ group-by-source-file sort-keys ] <arrow> ;

:: <source-file-table> ( error-list -- table )
    error-list model>> <source-file-model>
    source-file-renderer
    <table>
        [ invoke-primary-operation ] >>action
        color: dark-gray >>column-line-color
        6 >>gap
        4 >>min-rows
        4 >>max-rows
        60 >>min-cols
        60 >>max-cols
        t >>selection-required?
        error-list source-file>> >>selection ;

SINGLETON: error-renderer

M: error-renderer row-columns
    drop [
        {
            [ error-type error-icon ]
            [ line#>> [ number>string ] [ "" ] if* ]
            [ asset>> [ unparse-short ] [ "" ] if* ]
            [ error>> safe-summary ]
        } cleave
    ] output>array ;

M: error-renderer prototype-row
    drop [ +compiler-error+ error-icon "" "" "" ] output>array ;

M: error-renderer row-value
    drop ;

M: error-renderer column-titles
    drop { "" "Line" "Asset" "Error" } ;

M: error-renderer column-alignment drop { 0 1 0 0 } ;

: sort-errors ( seq -- seq' )
    [ [ [ line#>> 0 or ] [ asset>> unparse-short ] bi 2array ] keep ] { } map>assoc
    sort-keys values ;

: file-matches? ( error pathname/f -- ? )
    [ path>> ] [ dup [ string>> ] when ] bi* = ;

: <error-table-model> ( error-list -- model )
    [ model>> ] [ source-file>> ] bi
    [ file-matches? ] <search>
    [ sort-errors ] <arrow> ;

:: <error-table> ( error-list -- table )
    error-list <error-table-model>
    error-renderer
    <table>
        [ invoke-primary-operation ] >>action
        color: dark-gray >>column-line-color
        6 >>gap
        4 >>min-rows
        4 >>max-rows
        60 >>min-cols
        60 >>max-cols
        t >>selection-required?
        error-list error>> >>selection ;

TUPLE: error-display < track ;

: <error-display> ( error-list -- gadget )
    vertical error-display new-track with-lines
        swap error>> >>model
        dup model>> [ [ print-error ] when* ] <pane-control>
        margins <scroller> white-interior 1 track-add
        add-toolbar ;

: com-inspect ( error-display -- )
    control-value [ inspector ] when* ;

: com-help ( error-display -- )
    control-value [ error>> error-help-window ] when* ;

: com-edit ( error-display -- )
    control-value [ edit-error ] when* ;

error-display "toolbar" f {
    { f com-inspect }
    { f com-help }
    { f com-edit }
} define-command-map

: <error-list-toolbar> ( error-list -- toolbar )
    [ <toolbar> ] [ error-toggle>> "Show errors:" label-on-left f track-add ] bi
    format-toolbar ;

: <error-model> ( visible-errors model -- model' )
    [ swap '[ error-type _ at ] filter ] <smart-arrow> ;

:: <error-list-gadget> ( model -- gadget )
    vertical \ error-list-gadget new-track
        <error-toggle> [ >>error-toggle ] [ >>visible-errors ] bi*
        dup visible-errors>> model <error-model> >>model
        f <model> >>source-file
        f <model> >>error
        dup <source-file-table> >>source-file-table
        dup <error-table> >>error-table
        dup <error-display> >>error-display
    :> error-list
    error-list vertical <track> with-lines
        error-list <error-list-toolbar> f track-add
        error-list source-file-table>> margins <scroller> white-interior
        "Source files" source-files-color <labeled> 1/4 track-add
        error-list error-table>> margins <scroller> white-interior
        "Errors" errors-color <labeled> 1/4 track-add
        error-list error-display>>
        "Details" details-color <labeled> 1/2 track-add
    1 track-add ;

M: error-list-gadget focusable-child*
    source-file-table>> ;

: error-list-help ( -- ) "ui.tools.error-list" com-browse ;

\ error-list-help H{ { +nullary+ t } } define-command

\ error-list-gadget "toolbar" f {
    { T{ key-down f f "F1" } error-list-help }
} define-command-map

MEMO: get-error-list-gadget ( -- gadget )
    error-list-model get-global [ drop all-errors ] <arrow>
    <error-list-gadget> ;

[ \ get-error-list-gadget reset-memoized ] "ui.tools.error-list" add-startup-hook

: show-error-list ( -- )
    [ get-error-list-gadget eq? ] find-window
    [ raise-window ] [ get-error-list-gadget "Errors" open-status-window ] if* ;

\ show-error-list H{ { +nullary+ t } } define-command