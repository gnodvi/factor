CC = gcc
CFLAGS = -g -Os -mpentiumpro -Wall -fomit-frame-pointer
LIBS = -lm
STRIP = strip

OBJS = native/arithmetic.o native/array.o native/bignum.o \
	native/s48_bignum.o \
	native/complex.o native/cons.o native/error.o \
	native/factor.o native/file.o native/fixnum.o \
	native/float.o native/gc.o \
	native/image.o native/io.o native/memory.o \
	native/misc.o native/port.o native/primitives.o \
	native/ratio.o native/read.o native/relocate.o \
	native/run.o \
	native/sbuf.o native/socket.o native/stack.o \
	native/string.o native/types.o native/vector.o \
	native/write.o native/word.o

f: $(OBJS)
	$(CC) $(LIBS) -o $@ $(OBJS)
#	$(STRIP) $@

clean:
	rm -f $(OBJS)

.c.o:
	$(CC) -c $(CFLAGS) -o $@ $<

