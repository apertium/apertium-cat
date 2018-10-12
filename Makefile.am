###############################################################################
## Makefile for apertium-cat
###############################################################################

LANG1=cat
BASENAME=apertium-$(LANG1)

VAR1=#deixar en blanc
VAR2=_valencia_gva
VAR3=_valencia_uni

TARGETS_COMMON =			\
	$(LANG1)$(VAR1).automorf.bin		\
	$(LANG1)$(VAR1).automorf.att.gz	\
	$(LANG1)$(VAR1).autogen.bin		\
	$(LANG1)$(VAR2).autogen.bin		\
	$(LANG1)$(VAR3).autogen.bin		\
	$(LANG1)$(VAR1).autogen.att.gz		\
	$(LANG1)$(VAR1).autopgen.bin		\
	$(LANG1)$(VAR2).autopgen.bin		\
	$(LANG1)$(VAR3).autopgen.bin		\
	$(LANG1)$(VAR1).autopgen-diacritics-vells.bin		\
	$(LANG1)$(VAR1).autopgen-diacritics-nous.bin		\
	$(LANG1)$(VAR1).rlx.bin
	
# Use this goal for creating .deps, otherwise make -j2 will give problems:
@ap_include@

###############################################################################
## Catalan transducer
###############################################################################

$(LANG1)$(VAR1).automorf.bin: $(BASENAME).$(LANG1).dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@ $(BASENAME).$(LANG1).acx
	
.deps/$(BASENAME).$(LANG1).cat.dix: $(BASENAME).$(LANG1).dix .deps/.d
	apertium-validate-dictionary $<
	python genvdix.py cat $< >$@

.deps/$(BASENAME).$(LANG1).val_gva.dix: $(BASENAME).$(LANG1).dix .deps/.d
	apertium-validate-dictionary $<
	python genvdix.py val_gva $< >$@

.deps/$(BASENAME).$(LANG1).val_uni.dix: $(BASENAME).$(LANG1).dix .deps/.d
	apertium-validate-dictionary $<
	python genvdix.py val_uni $< >$@


$(LANG1)$(VAR1).autogen.bin: .deps/$(BASENAME).$(LANG1).cat.dix
	apertium-validate-dictionary $<
	lt-comp -v cat rl $< $@ $(BASENAME).$(LANG1).acx

$(LANG1)$(VAR2).autogen.bin: .deps/$(BASENAME).$(LANG1).val_gva.dix 
	apertium-validate-dictionary $<
	lt-comp -v val_gva rl $< $@ $(BASENAME).$(LANG1).acx

$(LANG1)$(VAR3).autogen.bin: .deps/$(BASENAME).$(LANG1).val_uni.dix
	apertium-validate-dictionary $<
	lt-comp -v val_uni rl $< $@ $(BASENAME).$(LANG1).acx

$(LANG1)$(VAR1).autogen.att.gz: $(LANG1).autogen.bin
	lt-print $< | gzip -9 -c -n > $@

$(LANG1)$(VAR1).automorf.att.gz: $(LANG1).automorf.bin
	lt-print $< | gzip -9 -c -n > $@

$(LANG1)$(VAR1).autopgen.bin: $(BASENAME).post-$(LANG1).dix
	lt-comp -a cat lr $< $@

$(LANG1)$(VAR2).autopgen.bin: $(BASENAME).post-$(LANG1).dix
	lt-comp -a val_gva lr $< $@

$(LANG1)$(VAR3).autopgen.bin: $(BASENAME).post-$(LANG1).dix
	lt-comp -a val_uni lr $< $@

$(LANG1)$(VAR1).autopgen-diacritics-vells.bin: $(BASENAME).post-diacritics-vells.dix
	lt-comp -a cat lr $< $@

$(LANG1)$(VAR1).autopgen-diacritics-nous.bin: $(BASENAME).post-diacritics-nous.dix
	lt-comp -a cat lr $< $@

###############################################################################
## Disambiguation rules
###############################################################################

$(LANG1).rlx.bin: $(BASENAME).$(LANG1).rlx $(CGCOMP)
	$(CGCOMP) $< $@

###############################################################################
## Distribution
###############################################################################
EXTRA_DIST=$(BASENAME).$(LANG1).dix		\
		$(BASENAME).$(LANG1).acx	\
		$(BASENAME).$(LANG1).rlx	\
		$(BASENAME).post-$(LANG1).dix	\
		$(BASENAME).post-diacritics-vells.dix	\
		$(BASENAME).post-diacritics-nous.dix	\
		$(LANG1).prob			\
		genvdix.py 			\
		modes.xml

###############################################################################
## Installation stuff
###############################################################################
#
#   apertium_cat_dir: This is where the compiled binaries go
#   apertium_cat_srcdir: This is where the source files go

apertium_catdir=$(prefix)/share/apertium/$(BASENAME)/
apertium_cat_srcdir=$(prefix)/share/apertium/$(BASENAME)/

apertium_cat_DATA=$(TARGETS_COMMON) $(LANG1).prob

pkgconfigdir = $(prefix)/share/pkgconfig
pkgconfig_DATA = $(BASENAME).pc

# Modes are not installed since they're all just "debug modes". All
# modes are created by this goal.
modes/$(LANG1)-morph.mode: modes.xml
	apertium-validate-modes modes.xml
	apertium-gen-modes modes.xml

noinst_DATA=modes/$(LANG1)-morph.mode

install-data-local: install-modes
	test -d $(DESTDIR)$(apertium_cat_srcdir) || mkdir -p $(DESTDIR)$(apertium_cat_srcdir)
	$(INSTALL_DATA) $(BASENAME).$(LANG1).dix $(DESTDIR)$(apertium_cat_srcdir)
	$(INSTALL_DATA) $(BASENAME).$(LANG1).rlx $(DESTDIR)$(apertium_cat_srcdir)
	$(INSTALL_DATA) $(BASENAME).post-$(LANG1).dix $(DESTDIR)$(apertium_cat_srcdir)
	$(INSTALL_DATA) $(BASENAME).post-diacritics-vells.dix $(DESTDIR)$(apertium_cat_srcdir)
	$(INSTALL_DATA) $(BASENAME).post-diacritics-nous.dix $(DESTDIR)$(apertium_cat_srcdir)

CLEANFILES = $(TARGETS_COMMON)
clean-local:
	-rm -rf .deps modes

###############################################################################
## Test
###############################################################################

test: all
	echo "TODO test sentence" | apertium -d . cat-morph | tee .test-mt
	@echo "TODO test analysis results" > .test-ref
	@diff .test-ref .test-mt
	@rm .test-ref .test-mt

