# Makefile for M2VDowsizer
#
# Author:   Robert Kennedy
# EMAIL:    amtor@hotmail.com
#
# License for Makefile:  GPL-2
#
# 'make depend'     uses makedepend to automatically generate dependencies
#                   (dependencies are added to end of Makefile)
# 'make'            build executable file 'M2VDownsizer'
# 'make install'    installs M2VDownsizer into $(DESTDIR)$(PREFIX)/bin
# 'make uninstall'  uninstalls M2VDownsizer from $(DESTDIR)$(PREFIX)/bin
# 'make clean'      removes all .o and executable files
# 'make status'     displays status of build and installation
# 'make print-'     prints the value of a variable used in the Makefile
#

# Define installation Prefix
#
PREFIX ?= /usr/local

# Define the C compiler to use
#
CC ?= cc

# Define any compile-time flags
#
CFLAGS += -Wall -g -Wno-unused-command-line-argument
#CFLAGS += -mmacosx-version-min=10.7 -isysroot /Developer/SDKs/MacOSX10.7.sdk

# Not necessary for most Macs
# But will eliminate some linker warning messages especially on High Sierra and Mojave
#
# Multi-line comment!  Remove ifeq and corresponding endif to uncomment
ifeq ("x","y")
MAJOR_MACOS_VERSION := $(shell osv="$(shell sw_vers -productVersion | cut -d '.' -f 1,2)"; echo "$${osv%}")
SDK_PATH := $(shell v="$(shell xcrun --show-sdk-path)"; echo "$${v%}")
CFLAGS += -mmacosx-version-min=$(MAJOR_MACOS_VERSION) \
-isysroot $(SDK_PATH)
endif

# Append additional architecture dependent compile-time flags
#
CFLAGS += -Xarch_ppc -faltivec
CFLAGS += -Xarch_ppc64 -faltivec

# Alternative code for appending additional architecture dependent compile-time flags
# Note: Use as last resort
#       It is better to use "-Xarch_ppc" etc. as these CFLAGS will work
#       when cross-compiling
#
# Multi-line comment!  Remove first ifeq and corresponding endif to uncomment
ifeq ("x","y")
UNAME_P := $(shell uname -p)
ifeq ($(findstring ppc, $(UNAME_P)), ppc)
	CFLAGS += -faltivec
	CXXFLAGS += -flativec
endif
endif

# Define any additional linker flags
#
LDFLAGS +=

# Define any directories containing header files other than directory containing
# the system header files, typically /usr/include
#   Statement Format: INCLUDES := -Iinclude_path
#   E.g. INCLUDES := -I./  -I/opt/local/include
#
INCLUDES := -I./ -Iutils -Iutils/altivec -Impeg2dec -Impeg2enc
#-I/System/Library/Frameworks/CoreServices.framework/Headers

# Define library directories other than the system library directory, typically /usr/lib
#   Statement Format:  LFLAGS := -Llibrary_path
#   E.g. LIBDIRS := -L/opt/local/lib
#
LIBDIRS :=

# Define any macOS frameworks directories other than the system Frameworks directory
#   Statement Format: FFLAGS:= -Fframework_path
#   E.g. FWORKDIRS = -F./ -F/System/Library/Frameworks/
#
#FWORKDIRS := -F./ -F/System/Library/Frameworks
FWORKDIRS :=

# Define any libraries to link into executable:
#   Statement Format: LIBS := -llibname
#   E.g. if I want to link the math library, use -lm as follows:
#   LIBS := -lm
#
LIBS := -lmpeg2

# Define any macOS frameworks to link into executable:
#   Statement Format: FWORKS := -framework framework_name
#   E.g. FWORKS := -framework CoreServices
#
FWORKS := -framework CoreServices

# Define the C source code files and directories
#
SRCS-UTILS := $(shell find utils ! -path utils -prune -type f -name '*.c' -exec basename {} \;)
SRCS-MPEG2ENC := $(shell find mpeg2enc -type f -name '*.c' -exec basename {} \;)
SRCS-ALTIVEC := $(shell find utils/altivec -type f -name '*.c' -exec basename {} \;)
SRCS-ALTIVEC-ASSM := $(shell find utils/altivec -type f -name '*.S' -exec basename {} \;)
SRCS-MAIN := $(shell find ./ ! -path ./ -prune -type f -name '*.c' -exec basename {} \;)

SRCDIR-UTILS := utils
SRCDIR-ALTIVEC := utils/altivec
SRCDIR-MPEG2ENC := mpeg2enc
SRCDIR-MAIN := ./

# Define the C object files
#
# This uses Suffix Replacement within a macro:
#   $(name:string1=string2)
#         For each word in 'name' replace 'string1' with 'string2'
# Below we are replacing the suffix .c of all words in the macro SRCS
# with the .o suffix
#
OBJS-UTILS := $(SRCS-UTILS:.c=.o)
OBJS-ALTIVEC := $(SRCS-ALTIVEC:.c=.o)
OBJS-ALTIVEC-ASSM:= $(SRCS-ALTIVEC-ASSM:.S=.o)
OBJS-MPEG2ENC := $(SRCS-MPEG2ENC:.c=.o)
OBJS-MAIN := $(SRCS-MAIN:.c=.o)

# Define main object directory
#
OBJDIR := obj

# Define object sub-directories
#
# Do not change the following directories!!
# The name of the last directory MUST match the name of the corresponding
# source directory in order for makedepend to work!!
# (unless the -p option is used with makedepend)
# 
OBJDIR-UTILS := $(OBJDIR)/utils
OBJDIR-ALTIVEC := $(OBJDIR)/altivec
OBJDIR-MPEG2ENC := $(OBJDIR)/mpeg2enc
OBJDIR-MAIN := $(OBJDIR)/main

# Define the final executable file(s)
#
PRODUCT := M2VDownsizer

# Define the PHONY targets
#
.PHONY: all depend clean utils altivec mpeg2enc main objects install uninstall \
print- status

# define the default target
# The default target is typically the "all" PHONY target
#
default: all

# Define the "all" PHONY target
#
all: utils altivec mpeg2enc main $(PRODUCT)

# The following also works for the "all" PHONY target but will not display messages
# after each subdirectory has been processed (e.g. compiled).
#
# all: $(PRODUCT)
#

# Define $(PRODUCT) real target
#
# Note:  Do not add phony targets to the $(PRODUCT) REAL target.
# Phony targets should not be a prerequisite of a real target file!
# If a phony target is a prerequisite, the recipe for the phony target will run every
# single time the REAL target is run!
#
$(PRODUCT): $(patsubst %,$(OBJDIR-UTILS)/%,$(OBJS-UTILS)) \
$(patsubst %,$(OBJDIR-ALTIVEC)/%,$(OBJS-ALTIVEC)) \
$(patsubst %,$(OBJDIR-ALTIVEC)/%,$(OBJS-ALTIVEC-ASSM)) \
$(patsubst %,$(OBJDIR-MPEG2ENC)/%,$(OBJS-MPEG2ENC)) \
$(patsubst %,$(OBJDIR-MAIN)/%,$(OBJS-MAIN))
	@echo '*** Starting Linking ***'
	$(CC) $(CFLAGS) $(LDFLAGS) $(INCLUDES) -o $(PRODUCT) \
$(patsubst %,$(OBJDIR-UTILS)/%,$(OBJS-UTILS)) \
$(patsubst %,$(OBJDIR-ALTIVEC)/%,$(OBJS-ALTIVEC)) \
$(patsubst %,$(OBJDIR-ALTIVEC)/%,$(OBJS-ALTIVEC-ASSM)) \
$(patsubst %,$(OBJDIR-MPEG2ENC)/%,$(OBJS-MPEG2ENC)) \
$(patsubst %,$(OBJDIR-MAIN)/%,$(OBJS-MAIN)) \
$(LIBDIRS) $(FWORKDIRS) $(LIBS) $(FWORKS)
	@echo '*** Linking Complete! $(PRODUCT) has been created! ***'

# Define all the other PHONY targets
#
# One must use @echo here and NOT $(info ) because $(info ) will not print shell variables!
# @echo uses the shell.  One must escape special characters like * ' " \ etc
# OR place text with special characters in single quotes (')like was done above.
# $(info ) is a Make command and does NOT use the shell.
# Note: @echo must be used within a recipe.  $(info ) can be used anywhere in a Makefile.
#
utils: $(patsubst %,$(OBJDIR-UTILS)/%,$(OBJS-UTILS))
	@echo '*** Finished processing the utils directory ***'

altivec: utils $(patsubst %,$(OBJDIR-ALTIVEC)/%,$(OBJS-ALTIVEC)) \
$(patsubst %,$(OBJDIR-ALTIVEC)/%,$(OBJS-ALTIVEC-ASSM))
	@echo '*** Finished processing the utils/altivec directory ***'
	
mpeg2enc: utils altivec $(patsubst %,$(OBJDIR-MPEG2ENC)/%,$(OBJS-MPEG2ENC))
	@echo '*** Finished processing the mpeg2enc directory ***'

main: utils altivec mpeg2enc $(patsubst %,$(OBJDIR-MAIN)/%,$(OBJS-MAIN))
	@echo '*** Finished processing the working directory ***'
	
objects: utils altivec mpeg2enc main
	@echo '*** objects have been created but have NOT been linked together ***'
	@echo '*** Run "make" or "make $(PRODUCT)" to link objects into $(PRODUCT) ***'

# Suffix replacement rules for building .o's from .c's
#
# it uses automatic variables $<: the name of the prerequisite of
# the rule(a .c file) and $@: the name of the target of the rule (a .o file)
# (see the gnu make manual section about automatic variables)
#.c.o:
#	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@
#
$(OBJDIR-UTILS)/%.o: $(SRCDIR-UTILS)/%.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(OBJDIR-ALTIVEC)/%.o: $(SRCDIR-ALTIVEC)/%.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(OBJDIR-ALTIVEC)/%.o: $(SRCDIR-ALTIVEC)/%.S
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(OBJDIR-MPEG2ENC)/%.o: $(SRCDIR-MPEG2ENC)/%.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(OBJDIR-MAIN)/%.o: $(SRCDIR-MAIN)/%.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

# Define the "clean" PHONY target
#
clean:
	@echo "*** Removing any built object files and binaries! ***"
	$(RM) $(OBJDIR-UTILS)/*.o $(OBJDIR-ALTIVEC)/*.o \
$(OBJDIR-MPEG2ENC)/*.o $(OBJDIR-MAIN)/*.o *.o *~ $(PRODUCT)
	@echo "*** All done! ***"

# Define the "depend" PHONY target
#
depend: 
#	makedepend $(INCLUDES) $^
# $^ is a makefile symbol that represents all the prerequisites of a target
# Will not work here since all the prerequisites are .PHONY
 
	makedepend $(INCLUDES) -p$(OBJDIR)/  $(patsubst %,$(SRCDIR-UTILS)/%,$(SRCS-UTILS))
	makedepend $(INCLUDES) -a -p$(OBJDIR)/  $(patsubst %,$(SRCDIR-ALTIVEC)/%,$(SRCS-ALTIVEC))
	makedepend $(INCLUDES) -a -p$(OBJDIR)/  $(patsubst %,$(SRCDIR-ALTIVEC)/%,$(SRCS-ALTIVEC-ASSM)) 
	makedepend $(INCLUDES) -a -p$(OBJDIR)/  $(patsubst %,$(SRCDIR-MPEG2ENC)/%,$(SRCS-MPEG2ENC))
	makedepend $(INCLUDES) -a -p$(OBJDIR-MAIN)/ $(SRCS-MAIN)

# Define the "install" PHONY target
#
install:
ifneq ("$(wildcard ./$(PRODUCT))","")
	@echo "*** Installing $(PRODUCT) ***"
	install -m 0755 $(PRODUCT) $(DESTDIR)$(PREFIX)/bin
	@echo "*** $(PRODUCT) has been installed into the $(DESTDIR)$(PREFIX)/bin directory ***"
else
	@echo "*** Nothing to install.  $(PRODUCT) does not exist!  Run \"make\" first ***"
endif

# Define the "uninstall" PHONY target
#
uninstall:
ifneq ("$(wildcard $(DESTDIR)$(PREFIX)/bin/$(PRODUCT))","")
	@echo "*** Uninstalling $(PRODUCT) ***"
	rm -f $(DESTDIR)$(PREFIX)/bin/M2VDownsizer
	@echo "*** $(PRODUCT) has been removed from the $(DESTDIR)$(PREFIX)/bin directory ***"
else
	@echo "*** Nothing happened! $(PRODUCT) is not installed! ***"
endif

# Define the "print-" PHONY target
# Use the "print-" PHONY target to print the value of a variable used in the Makefile
# E.g.  make print-CFLAGS
#       will print the value(s) contained in CFLAGS
#
print-%:
	@echo $*=$($*)

# Define the "status" PHONY target
#
status:
ifneq ("$(wildcard ./$(PRODUCT))","")
	@echo "$(PRODUCT) has been built."
else
	@echo "$(PRODUCT) has not been built. Run \"make\" to build."
endif
ifneq ("$(wildcard $(DESTDIR)$(PREFIX)/bin/$(PRODUCT))","")
	@echo "$(PRODUCT) has been installed into the $(DESTDIR)$(PREFIX)/bin directory."
else
	@echo "$(PRODUCT) has not been installed! Run \"sudo make install\" to install."
endif

# DO NOT DELETE THIS LINE -- make depend needs it

