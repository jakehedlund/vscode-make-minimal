# Compile individual tools which depend on libmyproject. 

INC=-I../libmyproject

CSRCS= \
	mytool.c \
	myothertool.c 
## Many more source files here... 

BIN = $(CSRCS:.c=)

LDFLAGS += ../lib/libmyproject.so
LDFLAGS += $(JSON_LDFLAGS) $(POPT_LDFLAGS) $(SHA_LDFLAGS)

CFLAGS+=-std=gnu11 -fno-strict-aliasing $(WARN) $(OPT) $(INC) $(JSON_CXXFLAGS) $(SHA_CXXFLAGS) $(POPT_CXXFLAGS)
CFLAGS+=-I../libmyproject

all: $(BIN)

mytool: mytool.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

myothertool: myothertool.o 
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

clean:
	-rm -f $(BIN)
