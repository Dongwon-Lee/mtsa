CXX ?= g++
CFLAGS = -Wall -Wconversion -O3 -fPIC
#CFLAGS = -Wall -Wconversion -g -fPIC
LDFLAGS = -shared
SHVER = 2

all: libmtsa.so

libmtsa.so: libmtsa.o libsvm.o libsvm_gkm.o
	$(CXX) $(CFLAGS) libmtsa.o libsvm.o libsvm_gkm.o -lm -lpthread -o $@ $(LDFLAGS)

libsvm.o: libsvm.cpp libsvm.h
	$(CXX) $(CFLAGS) -c libsvm.cpp
libsvm_gkm.o: libsvm_gkm.c libsvm_gkm.h
	$(CXX) $(CFLAGS) -c libsvm_gkm.c
libmtsa.o: libmtsa.c
	$(CXX) $(CFLAGS) -c libmtsa.c

clean:
	rm -f libsvm.o libsvm_gkm.o libmtsa.o libmtsa.so 

install:
	cp libmtsa.so ../bin
