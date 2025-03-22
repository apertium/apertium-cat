TAGGER_SUPERVISED_ITERATIONS=0
BASENAME=apertium-cat
LANG=cat
TAGGER=tagger-data
PREFIX=$(LANG)

all: $(PREFIX).prob

$(PREFIX).prob: $(BASENAME).$(LANG).tsx $(TAGGER)/$(LANG).dic $(TAGGER)/$(LANG).untagged $(TAGGER)/$(LANG).tagged $(TAGGER)/$(LANG).crp
	apertium-validate-tagger $(BASENAME).$(LANG).tsx
	apertium-tagger -s $(TAGGER_SUPERVISED_ITERATIONS) \
                           $(TAGGER)/$(LANG).dic \
                           $(TAGGER)/$(LANG).crp \
                           $(BASENAME).$(LANG).tsx \
                           $(PREFIX).prob \
                           $(TAGGER)/$(LANG).tagged \
                           $(TAGGER)/$(LANG).untagged;

$(TAGGER)/$(LANG).dic: .deps/$(BASENAME).$(LANG).dix $(PREFIX).automorf.bin
	@echo "Generating $@";
	@echo "This may take some time. Please, take a cup of coffee and come back later.";
	apertium-validate-dictionary .deps/$(BASENAME).$(LANG).dix
	apertium-validate-tagger $(BASENAME).$(LANG).tsx
	lt-expand .deps/$(BASENAME).$(LANG).dix | grep -v "__REGEXP__" | grep -v ":<:" |\
	awk 'BEGIN{FS=":>:|:"}{print $$1;}' | sed -e 's/@/\\@/g' > $(LANG).dic.expanded
	@echo "." >>$(LANG).dic.expanded
	@echo "?" >>$(LANG).dic.expanded
	@echo ";" >>$(LANG).dic.expanded
	@echo ":" >>$(LANG).dic.expanded
	@echo "!" >>$(LANG).dic.expanded
	@echo "42" >>$(LANG).dic.expanded
	@echo "," >>$(LANG).dic.expanded
	@echo "(" >>$(LANG).dic.expanded
	@echo "\\[" >>$(LANG).dic.expanded
	@echo ")" >>$(LANG).dic.expanded
	@echo "\\]" >>$(LANG).dic.expanded
	@echo "¿" >>$(LANG).dic.expanded
	@echo "¡" >>$(LANG).dic.expanded
	lt-proc -a $(PREFIX).automorf.bin <$(LANG).dic.expanded | \
	apertium-filter-ambiguity $(BASENAME).$(LANG).tsx > $@
	rm $(LANG).dic.expanded;

$(TAGGER)/$(LANG).crp: $(PREFIX).automorf.bin $(TAGGER)/$(LANG).crp.txt
	apertium-destxt -n < $(TAGGER)/$(LANG).crp.txt | lt-proc $(PREFIX).automorf.bin > $(TAGGER)/$(LANG).crp; \

$(TAGGER)/$(LANG).crp.txt:
	touch $(TAGGER)/$(LANG).crp.txt

$(TAGGER)/$(LANG).tagged:
	@echo "Error: File '"$@"' is needed to perform a supervised tagger training" 1>&2
	@echo "This file should exist. It is the result of solving the ambiguity from the '"$(TAGGER)/$(LANG).tagged.txt"' file" 1>&2
	exit 1

$(TAGGER)/$(LANG).untagged: $(TAGGER)/$(LANG).tagged.txt $(PREFIX).automorf.bin
	cat $(TAGGER)/$(LANG).tagged.txt | lt-proc $(PREFIX).automorf.bin  > $@; 

clean: 
	rm -f $(TAGGER)/$(LANG).dic
