! Copyright (C) 2010 Anton Gorenko.
! See http://factorcode.org/license.txt for BSD license.
USING: alien alien.libraries alien.syntax combinators
gobject-introspection kernel system vocabs ;
IN: gstreamer.controller.ffi

COMPILE<
"gstreamer.ffi" require
COMPILE>

LIBRARY: gstreamer.controller

COMPILE<
"gstreamer.controller" {
    { [ os windows? ] [ drop ] }
    { [ os macosx? ] [ drop ] }
    { [ os unix? ] [ "libgstcontroller-0.10.so" cdecl add-library ] }
} cond
COMPILE>

GIR: GstController-0.10.gir