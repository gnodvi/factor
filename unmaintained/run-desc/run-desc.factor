USING: io io.encodings.utf8 io.launcher kernel sequences ;
in: run-desc
: run-desc ( desc -- result ) utf8 [ contents [ but-last ] [ f ] if* ] with-process-reader ;
