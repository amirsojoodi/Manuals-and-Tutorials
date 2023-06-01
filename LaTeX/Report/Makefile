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
SOURCES=$(MAIN).tex Makefile preamble.sty
TEX := $(shell find TexFiles/*.tex -type f)
REFERENCES := $(shell find References/*.bib -type f)
FIGURES := $(shell find TexFiles/Figures/* -type f)
PDF=$(MAIN).pdf

all: $(PDF)

$(PDF): $(OUT_DIR)/$(PDF)
	cp $(OUT_DIR)/$(PDF) .

$(OUT_DIR)/$(PDF): $(SOURCES) $(TEX) $(REFERENCES) $(FIGURES)
	latexmk -pdf -outdir=$(OUT_DIR) -f 

# -shell-escape

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

force: | $(OUT_DIR)
	latexmk -pdf -outdir=$(OUT_DIR) -g -f
	makeglossaries -d $(OUT_DIR) $(MAIN)
	latexmk -pdf -outdir=$(OUT_DIR) -g
	cp $(OUT_DIR)/$(PDF) .

clean:
	rm -rf $(OUT_DIR)/*
	rm -f $(PDF)

open: $(PDF)
	nohup $(PDF_READER) $(PDF) > /dev/null &

format:
	for file in $(shell ls TexFiles/*.tex); do \
		echo $$file; \
		./latexindent.exe -m -w $$file; \
	done
	rm TexFiles/*.bak0
	rm TexFiles/indent.log
		# perl latexindent.pl -w $$file;

spell:
	for file in $(shell ls TexFiles/*.tex); do \
		echo $$file; \
		aspell -d $(SPELL_LANG) --mode=tex -c $$file; \
	done
