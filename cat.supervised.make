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
	cat $(TAGGER)/$(LANG).crp.txt | lt-proc $(PREFIX).automorf.bin > $(TAGGER)/$(LANG).crp;

$(TAGGER)/$(LANG).crp.txt:
	touch $(TAGGER)/$(LANG).crp.txt;

$(TAGGER)/$(LANG).tagged:
	cat $(TAGGER)/tagged/*.tagged > $@;

$(TAGGER)/$(LANG).tagged.txt: $(TAGGER)/$(LANG).tagged
	cat $(TAGGER)/$(LANG).tagged | cut -f2 -d'^' | cut -f1 -d'/' > $@;

$(TAGGER)/$(LANG).untagged: $(TAGGER)/$(LANG).tagged.txt $(PREFIX).automorf.bin
	cat $(TAGGER)/$(LANG).tagged.txt | lt-proc $(PREFIX).automorf.bin  > $@; 

clean: 
	rm -f $(TAGGER)/$(LANG).dic;
	rm -f $(TAGGER)/$(LANG).tagged;
	rm -f $(TAGGER)/$(LANG).tagged.txt;
	rm -f $(TAGGER)/$(LANG).untagged;
	rm -f $(TAGGER)/$(LANG).crp;
	rm -f $(TAGGER)/$(LANG).crp.txt;

clean-corpora: 
	rm -f $(TAGGER)/$(LANG).tagged;
	rm -f $(TAGGER)/$(LANG).tagged.txt;
	rm -f $(TAGGER)/$(LANG).untagged;
	rm -f $(TAGGER)/$(LANG).crp;
	rm -f $(TAGGER)/$(LANG).crp.txt;
