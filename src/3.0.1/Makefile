# On macOS, g++ is often an alias to clang++, so try to find g++ from Homebrew
# Users can still override by setting CXX environment variable
ifeq ($(shell uname), Darwin)
    CXX_DETECTED := $(shell \
        for v in 20 19 18 17 16 15 14 13 12 11 10; do \
            if which g++-$$v >/dev/null 2>&1; then \
                echo g++-$$v; \
                break; \
            fi; \
        done)
    ifneq ($(CXX_DETECTED),)
        CXX?=$(CXX_DETECTED)
    else
        CXX?=g++
    endif
else
    CXX?=g++
endif
CPPFLAGS=
CXXFLAGS=
LDFLAGS=
AR=ar
LD=ld
INSTALL=install
PREFIX=/usr/local/
DESTDIR=
COPY=cp

LIB_OBJS = datetime.o decode.o encode.o errorhandler.o extensible.o link.o namedindividual.o object.o objectpath.o objectset.o property.o propertyvalue.o refproperty.o type.o util.o spdx-3.0.1.o spdx-3.0.1-jsonld.o

VALIDATE_OBJS = spdx-3.0.1-validate.o
ALL_OBJS = $(LIB_OBJS) $(VALIDATE_OBJS)

all: libspdx-3.0.1.so libspdx-3.0.1.a spdx-3.0.1-validate docs

clean:
	rm -rf *.o *.so *.a spdx-3.0.1-validate doc/

install: libspdx-3.0.1.so libspdx-3.0.1.a docs
	# Library
	$(INSTALL) -d $(DESTDIR)/$(PREFIX)/lib
	$(INSTALL) -m 0755 "libspdx-3.0.1.so" "$(DESTDIR)/$(PREFIX)/lib/libspdx-3.0.1.so.0.0.1"
	ln -sf "libspdx-3.0.1.so.0.0.1" "$(DESTDIR)/$(PREFIX)/lib/libspdx-3.0.1.so"
	ln -sf "libspdx-3.0.1.so.0.0.1" "$(DESTDIR)/$(PREFIX)/lib/libspdx-3.0.1.so.0"

	$(INSTALL) -m 0644 "libspdx-3.0.1.a" "$(DESTDIR)/$(PREFIX)/lib/"

	# Package Config
	$(INSTALL) -d $(DESTDIR)/$(PREFIX)/lib/pkgconfig

	$(INSTALL) -m 0644 "spdx-3.0.1.pc" "$(DESTDIR)/$(PREFIX)/lib/pkgconfig/"
	sed -i.bak -e 's^@@PREFIX@@^$(PREFIX)^g' \
		"$(DESTDIR)/$(PREFIX)/lib/pkgconfig/spdx-3.0.1.pc"
	rm -f "$(DESTDIR)/$(PREFIX)/lib/pkgconfig/spdx-3.0.1.pc.bak"

	# Headers
	$(INSTALL) -d "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1"
	$(INSTALL) -m 0644 "api.hpp" "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1/"
	$(INSTALL) -m 0644 "datetime.hpp" "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1/"
	$(INSTALL) -m 0644 "decode.hpp" "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1/"
	$(INSTALL) -m 0644 "encode.hpp" "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1/"
	$(INSTALL) -m 0644 "errorhandler.hpp" "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1/"
	$(INSTALL) -m 0644 "exceptions.hpp" "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1/"
	$(INSTALL) -m 0644 "extensible.hpp" "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1/"
	$(INSTALL) -m 0644 "link.hpp" "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1/"
	$(INSTALL) -m 0644 "namedindividual.hpp" "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1/"
	$(INSTALL) -m 0644 "object.hpp" "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1/"
	$(INSTALL) -m 0644 "objectpath.hpp" "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1/"
	$(INSTALL) -m 0644 "objectset.hpp" "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1/"
	$(INSTALL) -m 0644 "prop.hpp" "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1/"
	$(INSTALL) -m 0644 "property.hpp" "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1/"
	$(INSTALL) -m 0644 "propertyvalue.hpp" "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1/"
	$(INSTALL) -m 0644 "ref.hpp" "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1/"
	$(INSTALL) -m 0644 "refproperty.hpp" "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1/"
	$(INSTALL) -m 0644 "type.hpp" "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1/"
	$(INSTALL) -m 0644 "util.hpp" "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1/"
	$(INSTALL) -m 0644 "walk.hpp" "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1/"
	$(INSTALL) -m 0644 "spdx-3.0.1.hpp" "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1/"
	$(INSTALL) -m 0644 "spdx-3.0.1-jsonld.hpp" "$(DESTDIR)/$(PREFIX)/include/spdx-3.0.1/"

	# Binaries
	$(INSTALL) -d $(DESTDIR)/$(PREFIX)/bin

	$(INSTALL) -m 0755 "spdx-3.0.1-validate" "$(DESTDIR)/$(PREFIX)/bin/"

	# Documentation
	$(INSTALL) -d "$(DESTDIR)/$(PREFIX)/share/doc/libspdx-3.0.1"
	$(COPY) -R doc/ "$(DESTDIR)/$(PREFIX)/share/doc/libspdx-3.0.1/"

%.o: %.cpp
	@echo " [CC]  $<"
	$(CXX) -c -o $@ $< $(CPPFLAGS) $(CXXFLAGS) \
		-fPIC \
		-fvisibility=hidden \
		-fvisibility-inlines-hidden \
		-DSHACL2CODE_SPDX_3_0_1_DLL=1 \
		-DSHACL2CODE_SPDX_3_0_1_DLL_EXPORT=1

libspdx-3.0.1.a: $(LIB_OBJS)
	# Combine all object files into a single object file. This is required
	# otherwise the linker may only include object files that were actually
	# referenced and the initializers will not run
	@echo " [LD]  libspdx-3.0.1.static.o"
	$(CXX) -r -o "libspdx-3.0.1.static.o" $^
	@echo " [AR]  $@"
	$(AR) rcs $@ "libspdx-3.0.1.static.o"

libspdx-3.0.1.so: $(LIB_OBJS)
	@echo " [LD]  $@"
ifeq ($(shell uname), Darwin)
	# macOS ld doesn't support -soname; avoid passing it and use -dynamiclib
	# Set install_name to @rpath/... so client binaries can locate the library
	$(CXX) -dynamiclib $(LDFLAGS) '-Wl,-install_name,@rpath/libspdx-3.0.1.so' -o $@ $^
else
	$(CXX) -shared -fPIC '-Wl,-soname,libspdx-3.0.1.so.0' $(LDFLAGS) -o $@ $^
endif

spdx-3.0.1-validate: $(VALIDATE_OBJS) libspdx-3.0.1.a
	@echo " [LD]  $@"
	$(CXX) $(LDFLAGS) -o $@ $^

docs:
	@echo " [DOC]"
	doxygen

# Use `make V=1` to print commands.
$(V).SILENT:

.PHONY: clean all docs

