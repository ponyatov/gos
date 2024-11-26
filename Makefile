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

# doc
.PHONY: doxy
doxy: .doxygen doc/DoxygenLayout.xml doc/logo.png
	rm -rf doc/html ; doxygen $< 1>/dev/null

.PHONY: doc
doc: $(DOCS)
