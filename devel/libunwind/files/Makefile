# Default locations for the build
ifdef DESTDIR
DSTROOT = $(DESTDIR)
endif
OBJROOT = .

# Default install locations for the library
PREFIX = /usr
INCDIR = $(PREFIX)/include
LIBDIR = $(PREFIX)/lib
LIBUNWIND_INCDIR = $(INCDIR)/libunwind
MACHO_INCDIR = $(INCDIR)/mach-o
LIBUNWIND_FILENAME = libunwind.1.dylib
LIBUNWIND_SYMLINKNAME = libunwind.dylib
LIBUNWIND_FILENAME_STATIC = libunwind.a
LIBUNWIND_COMPAT_VERSION = 1.0.0
LIBUNWIND_CURRENT_VERSION = 1.0.0

# Default toolchain
AR =  $(shell xcrun -find ar)
RANLIB =  $(shell xcrun -find ranlib)
CC = $(shell xcrun -find cc)
CXX = $(shell xcrun -find c++)
STRIP = $(shell xcrun -find strip)
STRIP_LIB_FLAGS = -S
DSYMUTIL = $(shell xcrun -find dsymutil)
INCLUDES = -I../../include

# Default archs
RC_ARCHS = i386 x86_64 
ARCH_FLAGS := $(foreach arch,$(RC_ARCHS),-arch $(arch))

# Use an SDK?
ifdef SDKROOT
SYSROOT_FLAGS = -isysroot $(SDKROOT)
endif

C_SRCS = \
  UnwindLevel1.c \
  UnwindLevel1-gcc-ext.c \
  Unwind-sjlj.c

CXX_SRCS = \
  Unwind_AppleExtras.cpp \
  libunwind.cpp \
  Unwind-EHABI.cpp

ASM_SRCS = \
  UnwindRegistersRestore.S \
  UnwindRegistersSave.S

HEADERS = \
  ../../include/libunwind.h \
  ../../include/unwind.h

LIBUNWIND_HEADERS = \
  AddressSpace.hpp \
  assembly.h \
  CompactUnwinder.hpp \
  config.h \
  dwarf2.h \
  DwarfInstructions.hpp \
  DwarfParser.hpp \
  libunwind_ext.h \
  Registers.hpp \
  UnwindCursor.hpp \
  unwind_ext.h

MACHO_HEADERS = \
  ../../include/mach-o/compact_unwind_encoding.h

OBJS = $(C_SRCS:%.c=$(OBJROOT)/%.o) $(CXX_SRCS:%.cpp=$(OBJROOT)/%.o) $(ASM_SRCS:%.S=$(OBJROOT)/%.o)

$(OBJROOT)/%.o : %.c
	$(CC) $(ARCH_FLAGS) $(SYSROOT_FLAGS) $(INCLUDES) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

$(OBJROOT)/%.o : %.cpp
	$(CXX) $(ARCH_FLAGS) $(SYSROOT_FLAGS) $(INCLUDES) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

$(OBJROOT)/%.o : %.S
	$(CC) $(ARCH_FLAGS) -force_cpusubtype_ALL $(SYSROOT_FLAGS) $(INCLUDES) $(CPPFLAGS) $(ASFLAGS) -c -o $@ $<

$(OBJROOT)/$(LIBUNWIND_FILENAME): $(OBJS)
	$(CXX) -o $@ $(ARC_FLAGS) $(SYSROOT_FLAGS) $(LDFLAGS) \
	    -dynamiclib -install_name $(LIBDIR)/$(LIBUNWIND_FILENAME) \
	    -compatibility_version $(LIBUNWIND_COMPAT_VERSION) -current_version $(LIBUNWIND_CURRENT_VERSION) \
	    $(OBJS)

$(OBJROOT)/$(LIBUNWIND_FILENAME_STATIC): $(OBJS)
	$(AR) cru $@ $(OBJS)
	$(RANLIB) $@

all: $(OBJROOT)/$(LIBUNWIND_FILENAME) $(OBJROOT)/$(LIBUNWIND_FILENAME_STATIC)

installhdrs:
	install -d -m 755 $(DSTROOT)$(INCDIR)
	install -d -m 755 $(DSTROOT)$(LIBUNWIND_INCDIR)
	install -d -m 755 $(DSTROOT)$(MACHO_INCDIR)

	for f in $(HEADERS); do \
	  install -m 644 $$f $(DSTROOT)$(INCDIR); \
	done

	for f in $(LIBUNWIND_HEADERS); do \
	  install -m 644 $$f $(DSTROOT)$(LIBUNWIND_INCDIR); \
	done

	for f in $(MACHO_HEADERS); do \
	  install -m 644 $$f $(DSTROOT)$(MACHO_INCDIR); \
	done

installdylib: $(OBJROOT)/$(LIBUNWIND_FILENAME)
ifdef SYMROOT
	install -m 755 $(OBJROOT)/$(LIBUNWIND_FILENAME) $(SYMROOT)
	$(DSYMUTIL) --out $(SYMROOT)/$(LIBUNWIND_FILENAME).dSYM $(OBJROOT)/$(LIBUNWIND_FILENAME)
endif
	install -d -m 755 $(DSTROOT)$(LIBDIR)
	install -m 755 $(OBJROOT)/$(LIBUNWIND_FILENAME) $(DSTROOT)$(LIBDIR)
ifneq "NO" "$(STRIP_ON_INSTALL)"
	$(STRIP) $(STRIP_LIB_FLAGS) $(DSTROOT)$(LIBDIR)/$(LIBUNWIND_FILENAME)
endif
	ln -s $(LIBUNWIND_FILENAME) $(DSTROOT)$(LIBDIR)/$(LIBUNWIND_SYMLINKNAME)

installstatic: $(OBJROOT)/$(LIBUNWIND_FILENAME_STATIC)
	install -d -m 755 $(DSTROOT)$(LIBDIR)
	install -m 644 $(OBJROOT)/$(LIBUNWIND_FILENAME_STATIC) $(DSTROOT)$(LIBDIR)

installlibs: installdylib installstatic
install: installhdrs installlibs
