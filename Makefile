file=

all:
	xelatex $(file).tex
	biber $(file)
	xelatex $(file).tex
	xelatex $(file).tex

simple:
	xelatex $(file).tex

clean:
	find . -name "$(file).*" -not -name "$(file).tex" -not -name ".$(file).tex.swp" -exec rm -i {} \;
