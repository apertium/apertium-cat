AC_PREREQ(2.52)

AC_INIT([Apertium Catalan], [2.10.0], [xavi.ivars@gmail.com], [apertium-cat], [http://wiki.apertium.org/wiki/Apertium-cat])
AM_INIT_AUTOMAKE

PKG_CHECK_MODULES(APERTIUM, apertium >= 3.6.0)
PKG_CHECK_MODULES(LTTOOLBOX, lttoolbox >= 3.5.0)
PKG_CHECK_MODULES(CG3, cg3 >= 1.3.0)

AP_MKINCLUDE

AC_OUTPUT([Makefile apertium-cat.pc])
