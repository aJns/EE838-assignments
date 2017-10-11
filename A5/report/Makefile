texname = assignment

tyoselostus: $(texname).tex content.tex $(texname).bib
	rubber --pdf $(texname).tex

clean: $(texname).tex
	rubber --clean $(texname).tex
