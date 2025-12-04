CURL = curl -fsSJ

COREUI_ICONS = $(COREUI_ICONS)

public/css public/js public/fonts:
	mkdir -p $@

public/css/coreui.min.css:
	$(CURL) https://cdn.jsdelivr.net/npm/@coreui/coreui@5.4.3/dist/css/coreui.min.css > $@
.PHONY: public/css/coreui.min.css

public/js/coreui.bundle.min.js:
	$(CURL) https://cdn.jsdelivr.net/npm/@coreui/coreui@5.4.3/dist/js/coreui.bundle.min.js  > $@
.PHONY: public/js/coreui.bundle.min.js

public/css/free.min.css:
	$(CURL) $(COREUI_ICONS)/css/free.min.css > $@
.PHONY: public/css/free.min.css

public/fonts/CoreUI-Icons-Free.eot:
	$(CURL) $(COREUI_ICONS)/fonts/CoreUI-Icons-Free.eot > $@
.PHONY: public/fonts/CoreUI-Icons-Free.eot

public/fonts/CoreUI-Icons-Free.svg:
	$(CURL) $(COREUI_ICONS)/fonts/CoreUI-Icons-Free.svg > $@
.PHONY: public/fonts/CoreUI-Icons-Free.svg

public/fonts/CoreUI-Icons-Free.ttf:
	$(CURL) $(COREUI_ICONS)/fonts/CoreUI-Icons-Free.ttf > $@
.PHONY: public/fonts/CoreUI-Icons-Free.ttf

public/fonts/CoreUI-Icons-Free.woff:
	$(CURL) $(COREUI_ICONS)/fonts/CoreUI-Icons-Free.woff > $@
.PHONY: public/fonts/CoreUI-Icons-Free.woff

coreui/fonts: public/fonts public/fonts/CoreUI-Icons-Free.eot public/fonts/CoreUI-Icons-Free.svg public/fonts/CoreUI-Icons-Free.ttf public/fonts/CoreUI-Icons-Free.woff

coreui/js: public/js public/js/coreui.bundle.min.js

coreui/css: public/css public/css/coreui.min.css public/css/free.min.css

coreui: coreui/css coreui/js coreui/fonts
