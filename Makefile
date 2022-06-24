SRC = README.md

PDF = $(SRC:.md=.pdf)

all : $(PDF)

%.pdf : %.md Makefile
	pandoc --standalone  --output=$@  $<

clean:
	rm -f *.pdf
