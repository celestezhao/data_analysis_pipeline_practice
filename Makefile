# Makefile

# This driver script completes the textual analysis of
# 3 novels and creates figures on the 10 most frequently
# occuring words from each of the 3 novels. This script
# takes no arguments.

# example usage:
# make all
# make clean

# variables
DATA_DIR = data
RESULTS_DIR = results
FIGURE_DIR = $(RESULTS_DIR)/figure
INPUT_FILES = $(DATA_DIR)/isles.txt $(DATA_DIR)/abyss.txt $(DATA_DIR)/last.txt $(DATA_DIR)/sierra.txt
DAT_FILES = $(patsubst $(DATA_DIR)/%.txt, $(RESULTS_DIR)/%.dat, $(INPUT_FILES))
PLOT_FILES = $(patsubst $(DATA_DIR)/%.txt, $(FIGURE_DIR)/%.png, $(INPUT_FILES))

.PHONY: all clean

all: $(DAT_FILES) $(PLOT_FILES) report

# count the words
$(RESULTS_DIR)/%.dat: $(DATA_DIR)/%.txt	scripts/wordcount.py	
	python scripts/wordcount.py --input_file=$< --output_file=$@

# create the plots
$(FIGURE_DIR)/%.png: $(RESULTS_DIR)/%.dat	scripts/wordcount.py	
	python scripts/plotcount.py --input_file=$< --output_file=$@

# write the report
report:	$(PLOT_FILES)	
	jupyter-book build report	

# clean up
clean:
	rm -f $(DAT_FILES) $(PLOT_FILES)	
	jupyter-book clean report --all	