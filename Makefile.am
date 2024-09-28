###############################################################################
## Makefile for apertium-cat
###############################################################################

LANG1=cat
BASENAME=apertium-$(LANG1)

VAR1=#deixar en blanc
VAR2=_valencia
VAR3=_valencia_gva
VAR4=_valencia_uni

TARGETS_COMMON =			\
	$(LANG1)$(VAR1).automorf.bin		\
	$(LANG1)$(VAR1).automorf.att.gz	\
	$(LANG1)$(VAR1).autogen.bin		\
	$(LANG1)$(VAR1).autogen.att.gz		\
	$(LANG1)$(VAR1).autopgen.bin		\
	$(LANG1)$(VAR2).autopgen.bin		\
	$(LANG1)$(VAR3).autopgen.bin		\
	$(LANG1)$(VAR4).autopgen.bin		\
	$(LANG1)$(VAR1).rlx.bin	\
	$(LANG1)$(VAR1).prefs.rlx.bin	\
	$(LANG1)$(VAR2).prefs.rlx.bin	\
	$(LANG1)$(VAR3).prefs.rlx.bin	\
	$(LANG1)$(VAR4).prefs.rlx.bin	\
	$(LANG1).pre2017_prefs.rlx.bin

# Use this goal for creating .deps, otherwise make -j2 will give problems:
@ap_include@

###############################################################################
## Catalan transducer
###############################################################################

.deps/$(BASENAME).$(LANG1).dix: $(BASENAME).$(LANG1).metadix .deps/.d
	python3 convert-metadix-dix.py $< $@
	apertium-validate-dictionary $@

$(LANG1)$(VAR1).automorf.bin: .deps/$(BASENAME).$(LANG1).dix $(BASENAME).$(LANG1).acx
	apertium-validate-dictionary $<
	lt-comp lr .deps/$(BASENAME).$(LANG1).dix $@ $(BASENAME).$(LANG1).acx

.deps/$(BASENAME).$(LANG1).cat.dix: .deps/$(BASENAME).$(LANG1).dix .deps/.d
	apertium-validate-dictionary $<
	apertium-genvdix cat $< >$@

.deps/$(BASENAME).$(LANG1).val.dix: .deps/$(BASENAME).$(LANG1).dix .deps/.d
	apertium-validate-dictionary $<
	apertium-genvdix val_gva $< >$@


$(LANG1)$(VAR1).autogen.bin: .deps/$(BASENAME).$(LANG1).cat.dix
	apertium-validate-dictionary $<
	lt-comp rl $< $@ $(BASENAME).$(LANG1).acx

$(LANG1)$(VAR1).autogen.att.gz: $(LANG1).autogen.bin
	lt-print $< | gzip -9 -c -n > $@

$(LANG1)$(VAR1).automorf.att.gz: $(LANG1).automorf.bin
	lt-print $< | gzip -9 -c -n > $@

$(LANG1)$(VAR1).autopgen.bin: $(BASENAME).post-$(LANG1).dix
	lt-comp -a cat lr $< $@

$(LANG1)$(VAR2).autopgen.bin: $(LANG1)$(VAR3).autopgen.bin
	cp $< $@

$(LANG1)$(VAR3).autopgen.bin: $(BASENAME).post-$(LANG1).dix
	lt-comp -a val_gva lr $< $@

$(LANG1)$(VAR4).autopgen.bin: $(BASENAME).post-$(LANG1).dix
	lt-comp -a val_uni lr $< $@

###############################################################################
## Disambiguation rules
###############################################################################

$(LANG1).rlx.bin: $(BASENAME).$(LANG1).rlx
	cg-comp $< $@

###############################################################################
## Variant preferences
###############################################################################

$(LANG1)$(VAR1).prefs.rlx.bin: $(BASENAME).$(LANG1)$(VAR1).prefs.rlx
	cg-comp $< $@

$(LANG1)$(VAR2).prefs.rlx.bin: $(BASENAME).$(LANG1)$(VAR2).prefs.rlx
	cg-comp $< $@

$(LANG1)$(VAR3).prefs.rlx.bin: $(BASENAME).$(LANG1)$(VAR3).prefs.rlx
	cg-comp $< $@

$(LANG1)$(VAR4).prefs.rlx.bin: $(BASENAME).$(LANG1)$(VAR4).prefs.rlx
	cg-comp $< $@

$(LANG1).pre2017_prefs.rlx.bin: $(BASENAME).$(LANG1).pre2017_prefs.rlx
	cg-comp $< $@

###############################################################################
## Distribution
###############################################################################
EXTRA_DIST=$(BASENAME).$(LANG1).metadix		\
		$(BASENAME).$(LANG1).acx	\
		$(BASENAME).$(LANG1).rlx	\
		$(BASENAME).post-$(LANG1).dix	\
		$(LANG1).prob			\
		$(LANG1).preferences.xml \
		modes.xml

###############################################################################
## Installation stuff
###############################################################################
#
#   apertium_cat_dir: This is where the compiled binaries go
#   apertium_cat_srcdir: This is where the source files go

apertium_catdir=$(prefix)/share/apertium/$(BASENAME)/
apertium_cat_srcdir=$(prefix)/share/apertium/$(BASENAME)/

apertium_cat_DATA=$(TARGETS_COMMON) \
		  $(LANG1).prob \
		  $(LANG1).preferences.xml

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
	$(INSTALL_DATA) $(BASENAME).$(LANG1).metadix $(DESTDIR)$(apertium_cat_srcdir)
	$(INSTALL_DATA) $(BASENAME).$(LANG1).rlx $(DESTDIR)$(apertium_cat_srcdir)
	$(INSTALL_DATA) $(BASENAME).post-$(LANG1).dix $(DESTDIR)$(apertium_cat_srcdir)

CLEANFILES = $(TARGETS_COMMON)
clean-local:
	-rm -rf .deps modes

###############################################################################
## Test
###############################################################################

test: all
	apertium-regtest test
