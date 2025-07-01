DIRS= \
	libmyproject \
	tools

_VERSION_FILE=libmyproject/my_version.h
_VERSION:=$(shell ./mkversion.sh $(_VERSION_FILE) $(_VERSION))
export _VERSION 

.PHONY: all all-recursive check checkconfig clean debug release printconfig

JSON_CXXFLAGS:=$(shell pkg-config json-c --cflags 2>/dev/null && echo -DHAVE_JSON)
JSON_LDFLAGS:=$(shell pkg-config json-c --libs 2>/dev/null)
SHA_CXXFLAGS:=$(shell pkg-config openssl --cflags 2>/dev/null || apu-config --includes 2>/dev/null && echo -DHAVE_OPENSSL)
SHA_LDFLAGS:=$(shell pkg-config openssl --libs 2>/dev/null || apu-config --link-ld --libs 2>/dev/null)
POPT_CXXFLAGS=-DHAVE_POPT
POPT_LDFLAGS=-lpopt

CFLAGS+=-std=gnu++11 -fno-strict-aliasing $(WARN) $(OPT) $(INC) $(JSON_CXXFLAGS) $(SHA_CXXFLAGS) $(POPT_CXXFLAGS)
CFLAGS+=-I../libmyproject

all: all-recursive 

release: _BUILD_DEBUG=
release: all

debug: _BUILD_DEBUG=1 
debug: all 

all-recursive: check
	@for d in $(DIRS); do \
		(cd $$d && $(MAKE) $(_BUILD_DEBUG) all ) || exit 1; \
	done

check: 
	@mkdir -p lib 
	@true 

clean:
	@for d in $(DIRS); do \
		(cd $$d && $(MAKE) clean ) || exit 1; \
	done 

checkconfig:
	@err=0; \
		for i in APRUTIL CMS CURL JSON POPT SQLITE LIBXML2 LIBXMLPLUSPLUS; do \
			echo "$(CXXFLAGS)" | grep -q HAVE_$$i; \
			if [ $$? != 0 ]; then \
				echo "ERROR: Missing $$i"; \
				err=1; \
			fi; \
		done; \
		exit $$err

printconfig:
	@echo JSON_CXXFLAGS=$(JSON_CXXFLAGS)
	@echo JSON_LDFLAGS=$(JSON_LDFLAGS)
	@echo SHA_CXXFLAGS=$(SHA_CXXFLAGS)
	@echo SHA_LDFLAGS=$(SHA_LDFLAGS)
	@echo POPT_CXXFLAGS=$(POPT_CXXFLAGS)
	@echo POPT_LDFLAGS=$(POPT_LDFLAGS)
	@echo ""
	@echo CC=$(CC)
	@echo CXX=$(CXX)
	@echo CXXFLAGS=$(CXXFLAGS)
	@echo LDFLAGS=$(LDFLAGS)
