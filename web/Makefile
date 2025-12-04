CURL = curl -fsSJ

COREUI_ICONS = https://unpkg.com/@coreui/icons@3.0.1
COREUI_CDN=https://cdn.jsdelivr.net/npm/@coreui/coreui@5.4.3/dist

public/css public/js public/fonts:
	mkdir -p $@

public/css/coreui.min.css:
	$(CURL) $(COREUI_CDN)/css/$(notdir $@) > $@

public/js/coreui.bundle.min.js:
	$(CURL) $(COREUI_CDN)/js/$(notdir $@)  > $@

public/css/free.min.css:
	$(CURL) $(COREUI_ICONS)/css/$(notdir $@) > $@

.PHONY: public/css/free.min.css public/js/coreui.bundle.min.js public/css/coreui.min.css

SUFFIX := eot svg ttf woff woff2
FONTS    := $(addprefix public/fonts/CoreUI-Icons-Free.,$(SUFFIX))
public/fonts/CoreUI-Icons-Free.%:
	$(CURL) $(COREUI_ICONS)/fonts/$(notdir $@) > $@

coreui/fonts: public/fonts $(FONTS)
	echo $(FONTS)

coreui/js: public/js public/js/coreui.bundle.min.js

coreui/css: public/css public/css/coreui.min.css public/css/free.min.css

coreui: coreui/css coreui/js coreui/fonts

clean:
	rm -rf public/js public/css public/fonts
