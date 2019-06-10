# VAR := expands during assignment
# VAR = expands when referenced

# output binary
BIN := .run/asciiid

# source files
SRCS :=	asciiid.cpp \
		asciiid_vt.cpp \
		asciiid_term.cpp \
		asciiid_xterm.cpp \
		asciiid_x11.cpp \
		asciiid_urdo.cpp \
		terrain.cpp \
		mesh.cpp \
		water.cpp \
		texheap.cpp \
		rgba8.cpp \
		upng.c \
		gl.c \
		imgui_impl_opengl3.cpp \
		imgui/imgui.cpp \
		imgui/imgui_demo.cpp \
		imgui/imgui_draw.cpp \
		imgui/imgui_widgets.cpp 

LDLIBS := -lGL -lX11 -lXinerama -lutil

# files included in the tarball generated by 'make dist' (e.g. add LICENSE file)
DISTFILES := $(BIN)

# filename of the tar archive generated by 'make dist'
DISTOUTPUT := $(BIN).tar.gz

# intermediate directory for generated object files
OBJDIR := .o

# intermediate directory for generated dependency files
DEPDIR := .d

# object files, auto generated from sourcce files
OBJS := $(patsubst %,$(OBJDIR)/%.o,$(basename $(SRCS)))

# dependency files, auto generated from source files
DEPS := $(patsubst %,$(DEPDIR)/%.d,$(basename $(SRCS)))

# compilers (at least gcc and clang) don't create the subdirectories automatically
$(shell mkdir -p $(dir $(OBJS)) >/dev/null)
$(shell mkdir -p $(dir $(DEPS)) >/dev/null)

# C compiler
CC := gcc

# C++ compiler
CXX := g++

# linker
LD := g++

# tar
TAR := tar

# C flags
CFLAGS := 

# C++ flags
CXXFLAGS := 

# C/C++ flags
CPPFLAGS := -g -save-temps=obj -pthread -O3

# linker flags
LDFLAGS := -g -save-temps=obj -pthread -O3

# flags required for dependency generation; passed to compilers
DEPFLAGS = -MT $@ -MD -MP -MF $(DEPDIR)/$*.Td

# compile C source files
COMPILE.c = $(CC) $(DEPFLAGS) $(CFLAGS) $(CPPFLAGS) -c -o $@

# compile C++ source files
COMPILE.cc = $(CXX) $(DEPFLAGS) $(CXXFLAGS) $(CPPFLAGS) -c -o $@

# link object files to binary
LINK.o = $(LD) $(LDFLAGS) -o $@

# precompile step
PRECOMPILE =

# postcompile step
POSTCOMPILE = mv -f $(DEPDIR)/$*.Td $(DEPDIR)/$*.d

all: $(BIN)

dist: $(DISTFILES)
	@$(TAR) -cvzf $(DISTOUTPUT) $^
#	$(BUILD)

.PHONY: clean
clean:
	@$(RM) -r $(OBJDIR) $(DEPDIR)
#	$(BUILD)

.PHONY: distclean
distclean: clean
	@$(RM) $(BIN) $(DISTOUTPUT)
#	$(BUILD)

.PHONY: install
install:
	@echo no install tasks configured

.PHONY: uninstall
uninstall:
	@echo no uninstall tasks configured

.PHONY: check
check:
	@echo no tests configured

.PHONY: help
help:
	@echo available targets: all dist clean distclean install uninstall check

$(BIN): $(OBJS)
	@echo Linking: $(BIN)
	@$(LINK.o) $^ $(LDLIBS)

$(OBJDIR)/%.o: %.c
$(OBJDIR)/%.o: %.c $(DEPDIR)/%.d
	@echo Comiling $<
	@$(PRECOMPILE)
	@$(COMPILE.c) $<
	@$(POSTCOMPILE)

$(OBJDIR)/%.o: %.cpp
$(OBJDIR)/%.o: %.cpp $(DEPDIR)/%.d
	@echo Comiling $<
	@$(PRECOMPILE)
	@$(COMPILE.cc) $<
	@$(POSTCOMPILE)

$(OBJDIR)/%.o: %.cc
$(OBJDIR)/%.o: %.cc $(DEPDIR)/%.d
	@echo Comiling $<
	@$(PRECOMPILE)
	@$(COMPILE.cc) $<
	@$(POSTCOMPILE)

$(OBJDIR)/%.o: %.cxx
$(OBJDIR)/%.o: %.cxx $(DEPDIR)/%.d
	@echo Comiling $<
	@$(PRECOMPILE)
	@$(COMPILE.cc) $<
	@$(POSTCOMPILE)

.PRECIOUS = $(DEPDIR)/%.d
$(DEPDIR)/%.d: ;

-include $(DEPS)