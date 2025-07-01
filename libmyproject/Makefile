# compile libmyproject static and shared libs. 

CSRCS= \
	mylib.c 
# More source files here... 

SHLIB=../lib/libmyproject.so
LIB=../lib/libmyproject.a

OBJS= $(CSRCS:.c=.o)
POBJS= $(CSRCS:.c=.po) 

LDFLAGS += -L/lib -L../libmyproject  -lrt
LDFLAGS += $(JSON_LDFLAGS) $(POPT_LDFLAGS) $(SHA_LDFLAGS)
CFLAGS+=-std=c99 -fno-strict-aliasing $(WARN) $(OPT) $(INC) $(JSON_CXXFLAGS) $(SHA_CXXFLAGS) $(POPT_CXXFLAGS)
CFLAGS+=-I../libmyproject -I. -I..

all: $(SHLIB) $(LIB)

test: 

install:

$(SHLIB): $(POBJS)
	$(CC) -shared -Wl,-soname,$(notdir $(SHLIB)) -o $@ $(POBJS) $(LDFLAGS)

$(LIB): $(OBJS) 
	$(AR) rcs $@ $(OBJS)

%.o %.po : %.c
	$(CC) $(CFLAGS) -c $< -o $(<:.c=.o) 
	$(CC) $(CFLAGS) -c $< -o $(<:.c=.po)

clean: 
	-rm -f $(OBJS) $(POBJS)
