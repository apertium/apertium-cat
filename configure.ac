AC_PREREQ(2.52)

AC_INIT([Apertium Catalan], [2.10.2], [xavi.ivars@gmail.com], [apertium-cat], [https://wiki.apertium.org/wiki/Apertium-cat])
AM_INIT_AUTOMAKE

PKG_CHECK_MODULES(APERTIUM, apertium >= 3.7.1)
PKG_CHECK_MODULES(LTTOOLBOX, lttoolbox >= 3.5.3)
PKG_CHECK_MODULES(CG3, cg3 >= 1.3.2)

AP_MKINCLUDE

AC_OUTPUT([Makefile apertium-cat.pc])
