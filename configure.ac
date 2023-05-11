AC_PREREQ(2.52)

AC_INIT([Apertium Catalan], [2.11.0], [xavi.ivars@gmail.com], [apertium-cat], [https://wiki.apertium.org/wiki/Apertium-cat])
AM_INIT_AUTOMAKE

PKG_CHECK_MODULES(APERTIUM, apertium >= 3.8.3)
PKG_CHECK_MODULES(LTTOOLBOX, lttoolbox >= 3.7.1)
PKG_CHECK_MODULES(CG3, cg3 >= 1.3.9)

PKG_CHECK_MODULES(REGTEST, apertium-regtest >= 0.9.1, [],
                  [AC_MSG_WARN([Running tests requires apertium-regtest])])

AP_MKINCLUDE

AC_OUTPUT([Makefile apertium-cat.pc])
