# doc
.PHONY: doxy
doxy: .doxygen doc/logo.png
	rm -rf doc/html ; doxygen $< 1>/dev/null
