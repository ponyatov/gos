# var
MODULE = $(notdir $(CURDIR))
REL    = $(shell git rev-parse --short=4    HEAD)
BRANCH = $(shell git rev-parse --abbrev-ref HEAD)
NOW    = $(shell date +%d%m%y)

ifeq (Msys,$(shell uname -o))
	OS = msys
else
	OS = $(shell uname -s | tr A-Z a-z )
# OS = $(shell lsb_release -si)
endif

# dirs
CWD   = $(CURDIR)
BIN   = $(CWD)/bin
DOC   = $(CWD)/doc
LIB   = $(CWD)/lib
INC   = $(CWD)/inc
SRC   = $(CWD)/src
REF   = $(CWD)/ref
TMP   = $(CWD)/tmp

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
C += $(wildcard $(SRC)/*.c*) $(wildcard $(SRC)/$(OS)/*.c*)
H += $(wildcard $(INC)/*.h*) $(wildcard $(INC)/$(OS)/*.h*)
G += $(wildcard $(LIB)/*.ini) $(wildcard $(LIB)/*.g)

OBJ += $(patsubst $(SRC)/%.cpp,$(TMP)/%.o,$(C))

CP += $(TMP)/$(MODULE).parser.cpp $(TMP)/$(MODULE).lexer.cpp
HP += $(TMP)/$(MODULE).parser.hpp

OBJ += $(patsubst $(TMP)/%.cpp,$(TMP)/%.o,$(CP))

# cfg
CFLAGS += -I$(INC) -I$(TMP) -O0 -g3
XFLAGS += $(CFLAGS) -std=gnu++17

.PHONY: all run
all: $(BIN)/$(MODULE) $(G)
# run: $(BIN)/$(MODULE) $(G)
# 	$^
run: $(BIN)/$(OS)/bin/$(MODULE) $(G)
	$^

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
	$(CXX) $(XFLAGS) -o $@ $^
$(TMP)/%.o: $(SRC)/%.cpp $(H) $(HP)
	$(CXX) $(XFLAGS) -o $@ -c $<
$(TMP)/%.o: $(TMP)/%.cpp $(H) $(HP)
	$(CXX) $(XFLAGS) -o $@ -c $<
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
.PHONY: install update
install: install_$(OS)
update: update_$(OS)

.PHONY: install_Debian update_Debian
install_Debian:
	$(MAKE) update
update_Debian: apt.Debian
	sudo apt update
	sudo apt install -uy `cat apt.Debian`

.PHONY: install_Msys update_Msys
install_Msys:
	pacman -Syuu
	$(MAKE) update
update_Msys: apt.Msys
	pacman -S `cat $< | tr '[ \t\r\n]+' ' ' `
