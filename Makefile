####################################################################################################
# Configuration
####################################################################################################

# Build configuration

BUILD = build
MAKEFILE = Makefile
OUTPUT_FILENAME = book
METADATA = metadata.yml
CHAPTERS = chapters/*.md
TOC = --toc --toc-depth 2
METADATA_ARGS = --metadata-file $(METADATA)
IMAGES = $(shell find images -type f)
TEMPLATES = $(shell find templates/ -type f)
COVER_IMAGE = images/cover.png
MATH_FORMULAS = --webtex

# TODO: ??
CSS_ARGS = --css $(CSS_FILE)

# Debugging

# DEBUG_ARGS = --verbose

# Pandoc filtes - uncomment the following variable to enable cross references filter. For more
# information, check the "Cross references" section on the README.md file.

# FILTER_ARGS = --filter pandoc-crossref

# Combined arguments

ARGS = $(TOC) $(MATH_FORMULAS) $(METADATA_ARGS) $(FILTER_ARGS) $(DEBUG_ARGS)
	
PANDOC_COMMAND = pandoc

# Per-format options

DOCX_ARGS = --standalone --reference-doc templates/docx.docx
EPUB_ARGS = --template templates/epub.html --epub-cover-image $(COVER_IMAGE)
HTML_ARGS = --template templates/html.html --standalone --to html5
PDF_ARGS = --template templates/pdf.latex --pdf-engine xelatex

# Per-format file dependencies

BASE_DEPENDENCIES = $(MAKEFILE) $(CHAPTERS) $(METADATA) $(IMAGES) $(TEMPLATES)
DOCX_DEPENDENCIES = $(BASE_DEPENDENCIES)
EPUB_DEPENDENCIES = $(BASE_DEPENDENCIES)
HTML_DEPENDENCIES = $(BASE_DEPENDENCIES)
PDF_DEPENDENCIES = $(BASE_DEPENDENCIES)

####################################################################################################
# Basic actions
####################################################################################################

all:	book

book:	epub html pdf docx

clean:
	rm -r $(BUILD)

####################################################################################################
# File builders
####################################################################################################

epub:	$(BUILD)/epub/$(OUTPUT_FILENAME).epub

html:	$(BUILD)/html/$(OUTPUT_FILENAME).html

pdf:	$(BUILD)/pdf/$(OUTPUT_FILENAME).pdf

docx:	$(BUILD)/docx/$(OUTPUT_FILENAME).docx

$(BUILD)/epub/$(OUTPUT_FILENAME).epub:	$(EPUB_DEPENDENCIES)
	mkdir -p $(BUILD)/epub
	$(PANDOC_COMMAND) $(ARGS) $(EPUB_ARGS) -o $@ $(CHAPTERS)
	@echo "$@ was built"

$(BUILD)/html/$(OUTPUT_FILENAME).html:	$(HTML_DEPENDENCIES)
	mkdir -p $(BUILD)/html
	$(PANDOC_COMMAND) $(ARGS) $(HTML_ARGS) -o $@ $(CHAPTERS)
	cp --parent $(IMAGES) $(BUILD)/html/
	@echo "$@ was built"

$(BUILD)/pdf/$(OUTPUT_FILENAME).pdf:	$(PDF_DEPENDENCIES)
	mkdir -p $(BUILD)/pdf
	$(PANDOC_COMMAND) $(ARGS) $(PDF_ARGS) -o $@ $(CHAPTERS)
	@echo "$@ was built"

$(BUILD)/docx/$(OUTPUT_FILENAME).docx:	$(DOCX_DEPENDENCIES)
	mkdir -p $(BUILD)/docx
	$(PANDOC_COMMAND) $(ARGS) $(DOCX_ARGS) -o $@ $(CHAPTERS)
	@echo "$@ was built"
