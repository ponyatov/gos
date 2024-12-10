# cross
TARGET ?= linux-x86_64
# linux-x86_64
# win32-i686

# var
MODULE = $(notdir $(CURDIR))
REL    = $(shell git rev-parse --short=4    HEAD)
BRANCH = $(shell git rev-parse --abbrev-ref HEAD)
NOW    = $(shell date +%d%m%y)

ifeq ($(OS),Windows_NT)
	OS = MinGW
else
	OS = $(shell lsb_release -si)
endif

# dirs
CWD = $(CURDIR)
BIN = $(CWD)/bin
DOC = $(CWD)/doc
LIB = $(CWD)/lib
INC = $(CWD)/inc
SRC = $(CWD)/src
REF = $(CWD)/ref
TMP = $(CWD)/tmp

# tool
CURL   = curl -L -o
CF     = clang-format -style=file -i
GITREF = git clone -o gh --depth 1
GITURL = https://github.com/ponyatov

# ref/some/README.md:
# 	$(call gitref,$@,master)
define gitref
	refile=$1 ; branch=$2 ;\
	name=$(patsubst ref/%/,%,$(dir $1)) ;\
	$(GITREF) -b $2 $(GITURL)/$$name.git $(dir $1)
endef

# src
C += $(wildcard $(SRC)/*.c*)
H += $(wildcard $(INC)/*.h*)
C += $(wildcard $(SRC)/$(OS)/*.c*)
H += $(wildcard $(INC)/$(OS)/*.h*)
C += $(wildcard $(SRC)/gui/*.c*)
H += $(wildcard $(INC)/gui/*.h*)
G += $(wildcard $(LIB)/*.ini) $(wildcard $(LIB)/*.g)

OBJ = $(patsubst $(SRC)/%.cpp,$(TMP)/%.o,$(C))
OBJ := $(subst tmp/linux/,tmp/,$(OBJ))
OBJ := $(subst tmp/gui/,tmp/,$(OBJ))

CP += $(TMP)/$(MODULE).parser.cpp $(TMP)/$(MODULE).lexer.cpp
HP += $(TMP)/$(MODULE).parser.hpp

OBJ += $(patsubst $(TMP)/%.cpp,$(TMP)/%.o,$(CP))

# libs
L += $(shell pkg-config --libs sdl2)

# cfg
   FLAGS += -I$(INC) -I$(INC)/$(OS) -I$(INC)/gui -I$(TMP) -O0 -g3
   FLAGS += $(shell pkg-config --cflags sdl2)
  CFLAGS += $(FLAGS) -std=gnu11
CXXFLAGS += $(FLAGS) -std=gnu++17

# all
.PHONY: all run
all: $(BIN)/$(MODULE) $(G)
	$^
# run: $(BIN)/$(MODULE) $(G)
# 	$^
run: $(BIN)/$(OS)/bin/$(MODULE) $(G)
	$^

# format
.PHONY: format
format: tmp/format_cpp
tmp/format_cpp: $(C) $(H)
	$(CF) $? && touch $@

# rule
$(BIN)/$(OS)/bin/$(MODULE): $(C) $(H) $(CP) $(HP) CMake*
	cmake --preset=$(OS)         &&\
	cmake --build   $(TMP)/$(OS) &&\
	cmake --install $(TMP)/$(OS) &&\
	ls -la $@ && touch $@

$(BIN)/$(MODULE): $(OBJ)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(L)
$(TMP)/%.o: $(SRC)/%.cpp $(H) $(HP)
	$(CXX) $(CXXFLAGS) -o $@ -c $<
$(TMP)/%.o: $(SRC)/$(OS)/%.cpp $(H) $(HP)
	$(CXX) $(CXXFLAGS) -o $@ -c $<
$(TMP)/%.o: $(SRC)/gui/%.cpp $(H) $(HP)
	$(CXX) $(CXXFLAGS) -o $@ -c $<
$(TMP)/%.o: $(TMP)/%.cpp $(H) $(HP)
	$(CXX) $(CXXFLAGS) -o $@ -c $<
$(TMP)/%.lexer.cpp: $(SRC)/%.lex
	flex -o $@ $<
$(TMP)/%.parser.cpp: $(SRC)/%.yacc
	bison -o $@ $<	

# doc
.PHONY: doxy
doxy: .doxygen doc/DoxygenLayout.xml doc/logo.png
	rm -rf doc/html ; doxygen $< 1>/dev/null

DOCS += $(DOC)/Cpp/modern-cmake.pdf
$(DOC)/Cpp/modern-cmake.pdf:
	$(CURL) $@ https://cliutils.gitlab.io/modern-cmake/modern-cmake.pdf

.PHONY: doc
doc: $(DOCS)

# install
.PHONY: install update update_$(OS) ref gz
install: doc ref gz
	$(MAKE) update
update: update_$(OS)
ref:    $(REF)
gz:     $(GZ)

update_Debian:
	sudo apt update
	sudo apt install -uy `cat apt.Debian`
update_MinGW:
	pacman -Suy
	pacman -S `cat $< | tr '[ \t\r\n]+' ' ' `
