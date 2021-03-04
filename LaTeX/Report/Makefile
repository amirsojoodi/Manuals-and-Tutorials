.PHONY: clean force once all

UNAME=$(shell uname)

ifeq ($(UNAME), Darwin)
	PDF_READER='open'
	SPELL_LANG='uk'
else # ($(UNAME), Linux) # Else it is Linux, unsure on windows.
	PDF_READER='zathura'
	SPELL_LANG='en_GB'
endif

OUT_DIR=Out
# FILE=$(shell ls -p | grep -v / | grep tex)

MAIN=Main
SOURCES=$(MAIN).tex Makefile 
TEX := $(shell find Tex/*.tex -type f)
REFERENCES := $(shell find References/*.bib -type f)
FIGURES := $(shell find Tex/Figures/* -type f)
PDF=$(MAIN).pdf

all: $(PDF)

.refresh:
	touch .refresh

$(PDF): .refresh $(SOURCES) $(REFERENCES) $(FIGURES)
	latexmk -pdf -outdir=$(OUT_DIR) -r .latexmkrc

force:
	touch .refresh
	rm $(OUT_DIR)/$(PDF)
	cd $(OUT_DIR) && makeglossaries $(MAIN)
	latexmk -pdf -outdir=$(OUT_DIR) -r .latexmkrc

clean:
	rm -r $(OUT_DIR)/*

open: $(PDF)
	nohup $(PDF_READER) $(PDF) > /dev/null &

spell:
	for file in $(shell ls tex/*.tex); do \
		echo $$file; \
		aspell -d $(SPELL_LANG) --mode=tex -c $$file; \
	done
		#aspell -d $(SPELL_LANG) --mode=tex -c $$file; \
