spelling: 
	Rscript -e 'spelling::spell_check_files("evtools.qmd")'

all: 
	quarto render evtools.qmd
	cp evtools.html docs
