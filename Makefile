# var
MODULE = $(notdir $(CURDIR))
REL    = $(shell git rev-parse --short=4    HEAD)
BRANCH = $(shell git rev-parse --abbrev-ref HEAD)
NOW    = $(shell date +%d%m%y)

# dirs
CWD   = $(CURDIR)
BIN   = $(CWD)/bin
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
C += $(wildcard $(SRC)/*.c*)
H += $(wildcard $(INC)/*.h*)
G += $(wildcard $(LIB)/*.ini) $(wildcard $(LIB)/*.g)

OBJ += $(patsubst $(SRC)/%.c*,$(TMP)/%.o,$(C))

CP += $(TMP)/$(MODULE).parser.cpp $(TMP)/$(MODULE).lexer.cpp
HP += $(TMP)/$(MODULE).parser.hpp

OBJ += $(patsubst $(TMP)/%.c*,$(TMP)/%.o,$(CP))

# cfg
CFLAGS += -Iinc -Itmp -O0 -g3
XFLAGS += $(CFLAGS) -std=gnu++17

.PHONY: all run
all: $(BIN)/$(MODULE) $(G)
run: $(BIN)/$(MODULE) $(G)
	$^

.PHONY: format
format: tmp/format_cpp
tmp/format_cpp: $(C) $(H)
	$(CF) $? && touch $@

# rule
$(BIN)/$(MODULE): $(OBJ)
	$(CXX) $(XFLAGS) -o $@ $^
$(TMP)/%.o: src/%.cpp
	$(CXX) $(XFLAGS) -o $@ -c $<
$(TMP)/%.lexer.cpp: src/%.lex
	flex -o $@ $<
$(TMP)/%.parser.cpp: src/%.yacc
	bison -o $@ $<	

# doc
.PHONY: doxy
doxy: .doxygen doc/DoxygenLayout.xml doc/logo.png
	rm -rf doc/html ; doxygen $< 1>/dev/null

.PHONY: doc
doc: $(DOCS)
