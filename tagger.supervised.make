###############################################################################
## Supervised tagger training
###############################################################################

LANG=cat
BASENAME=apertium-$(LANG)

TAGGER_SUPERVISED_ITERATIONS=0
TAGGERDIR=tagger-data

all: $(LANG).prob

$(LANG).prob: $(BASENAME).$(LANG).tsx $(TAGGERDIR)/$(LANG).dic $(TAGGERDIR)/$(LANG).untagged $(TAGGERDIR)/$(LANG).tagged $(TAGGERDIR)/$(LANG).crp
	apertium-validate-tagger $(BASENAME).$(LANG).tsx
	apertium-tagger -s $(TAGGER_SUPERVISED_ITERATIONS) \
                           $(TAGGERDIR)/$(LANG).dic \
                           $(TAGGERDIR)/$(LANG).crp \
                           $(BASENAME).$(LANG).tsx \
                           $(LANG).prob \
                           $(TAGGERDIR)/$(LANG).tagged \
                           $(TAGGERDIR)/$(LANG).untagged;

$(TAGGERDIR)/$(LANG).dic: .deps/$(BASENAME).$(LANG).dix $(LANG).automorf.bin $(BASENAME).$(LANG).tsx
	@echo "Generating $@";
	@echo "This may take some time. Please, take a cup of coffee and come back later.";
	apertium-validate-dictionary .deps/$(BASENAME).$(LANG).dix
	apertium-validate-tagger $(BASENAME).$(LANG).tsx
	lt-expand .deps/$(BASENAME).$(LANG).dix | grep -v "__REGEXP__" | grep -v ":<:" |\
	awk 'BEGIN{FS=":>:|:"}{print $$1;}' | sed -e 's/@/\\@/g' > $(TAGGERDIR)/$(LANG).dic.expanded
	@echo "." >> $(TAGGERDIR)/$(LANG).dic.expanded
	@echo "?" >> $(TAGGERDIR)/$(LANG).dic.expanded
	@echo ";" >> $(TAGGERDIR)/$(LANG).dic.expanded
	@echo ":" >> $(TAGGERDIR)/$(LANG).dic.expanded
	@echo "!" >> $(TAGGERDIR)/$(LANG).dic.expanded
	@echo "42" >> $(TAGGERDIR)/$(LANG).dic.expanded
	@echo "," >> $(TAGGERDIR)/$(LANG).dic.expanded
	@echo "(" >> $(TAGGERDIR)/$(LANG).dic.expanded
	@echo "\\[" >> $(TAGGERDIR)/$(LANG).dic.expanded
	@echo ")" >> $(TAGGERDIR)/$(LANG).dic.expanded
	@echo "\\]" >> $(TAGGERDIR)/$(LANG).dic.expanded
	@echo "¿" >> $(TAGGERDIR)/$(LANG).dic.expanded
	@echo "¡" >> $(TAGGERDIR)/$(LANG).dic.expanded
	lt-proc -a $(LANG).automorf.bin < $(TAGGERDIR)/$(LANG).dic.expanded |\
	apertium-filter-ambiguity $(BASENAME).$(LANG).tsx > $@
	rm $(TAGGERDIR)/$(LANG).dic.expanded;

$(TAGGERDIR)/$(LANG).crp: $(LANG).automorf.bin $(TAGGERDIR)/$(LANG).crp.txt
	cat $(TAGGERDIR)/$(LANG).crp.txt | lt-proc $(LANG).automorf.bin > $(TAGGERDIR)/$(LANG).crp;

$(TAGGERDIR)/$(LANG).crp.txt: $(wildcard $(TAGGERDIR)/crp/*.txt)
	cat $(TAGGERDIR)/crp/*.txt > $@;

$(TAGGERDIR)/$(LANG).tagged: $(wildcard $(TAGGERDIR)/tagged/*.tagged)
	cat $(TAGGERDIR)/tagged/*.tagged > $@;

$(TAGGERDIR)/$(LANG).tagged.txt: $(TAGGERDIR)/$(LANG).tagged
	cat $< | cut -f2 -d'^' | cut -f1 -d'/' > $@;

$(TAGGERDIR)/$(LANG).untagged: $(TAGGERDIR)/$(LANG).tagged.txt $(LANG).automorf.bin
	cat $(TAGGERDIR)/$(LANG).tagged.txt | lt-proc $(LANG).automorf.bin  > $@; 

clean:
	rm -f $(TAGGERDIR)/$(LANG).dic
	rm -f $(TAGGERDIR)/$(LANG).tagged
	rm -f $(TAGGERDIR)/$(LANG).tagged.txt
	rm -f $(TAGGERDIR)/$(LANG).untagged
	rm -f $(TAGGERDIR)/$(LANG).crp
	rm -f $(TAGGERDIR)/$(LANG).crp.txt
