CURL = curl -fsSJ


public/css public/js:
	mkdir -p $@

public/css/coreui.min.css: public/css
	# create public/css directory if it doesn't exist
	$(CURL) https://cdn.jsdelivr.net/npm/@coreui/coreui@5.4.3/dist/css/coreui.min.css > $@
.PHONY: public/css/coreui.min.css

public/js/coreui.bundle.min.js: public/js
	$(CURL) https://cdn.jsdelivr.net/npm/@coreui/coreui@5.4.3/dist/js/coreui.bundle.min.js  > $@
.PHONY: public/js/coreui.bundle.min.js

coreui: public/css/coreui.min.css public/js/coreui.bundle.min.js
