BUILD = build
MAKEFILE = Makefile
OUTPUT_FILENAME = book
METADATA = metadata.yml
CHAPTERS = chapters/*.md
TOC = --toc --toc-depth=2
IMAGES_FOLDER = images
IMAGES = $(IMAGES_FOLDER)/*
COVER_IMAGE = $(IMAGES_FOLDER)/cover.png
LATEX_CLASS = report
MATH_FORMULAS = --webtex
CSS_FILE = style.css
CSS_ARG = --css=$(CSS_FILE)
METADATA_ARG = --metadata-file=$(METADATA)
ARGS = $(TOC) $(MATH_FORMULAS) $(CSS_ARG) $(METADATA_ARG)

################################################################################
# Default Action

all:	book

################################################################################

book:	epub html pdf

clean:
	rm -r $(BUILD)

################################################################################

epub:	$(BUILD)/epub/$(OUTPUT_FILENAME).epub

html:	$(BUILD)/html/$(OUTPUT_FILENAME).html

pdf:	$(BUILD)/pdf/$(OUTPUT_FILENAME).pdf

################################################################################

$(BUILD)/epub/$(OUTPUT_FILENAME).epub:	$(MAKEFILE) $(METADATA) $(CHAPTERS) $(CSS_FILE) $(IMAGES) $(COVER_IMAGE)
	@echo ""
	@echo "--- $@ building ---"
	mkdir -p $(BUILD)/epub
	pandoc $(ARGS) --epub-cover-image=$(COVER_IMAGE) -o $@ $(CHAPTERS)
	@echo "--- $@ complete ---"

$(BUILD)/html/$(OUTPUT_FILENAME).html:	$(MAKEFILE) $(METADATA) $(CHAPTERS) $(CSS_FILE) $(IMAGES)
	@echo ""
	@echo "--- $@ building ---"
	mkdir -p $(BUILD)/html
	pandoc $(ARGS) --standalone --to=html5 -o $@ $(CHAPTERS)
	cp -R $(IMAGES_FOLDER)/ $(BUILD)/html/$(IMAGES_FOLDER)/
	cp $(CSS_FILE) $(BUILD)/html/$(CSS_FILE)
	@echo "--- $@ complete ---"

$(BUILD)/pdf/$(OUTPUT_FILENAME).pdf:	$(MAKEFILE) $(METADATA) $(CHAPTERS) $(CSS_FILE) $(IMAGES)
	@echo ""
	@echo "--- $@ building ---"
	mkdir -p $(BUILD)/pdf
	pandoc $(ARGS) -V documentclass=$(LATEX_CLASS) -V geometry:margin=1in -o $@ $(CHAPTERS)
	@echo "--- $@ complete ---"
