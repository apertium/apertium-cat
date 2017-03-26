#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.52)

AC_INIT([Apertium Catalan], [2.0.0], [xavi.ivars@gmail.com], [apertium-cat], [http://wiki.apertium.org/wiki/Apertium-cat])
AM_INIT_AUTOMAKE

AC_PROG_LN_S
AC_PROG_AWK

m4_define([required_apertium_version], [3.4.0])
m4_define([required_lttoolbox_version], [3.3.2])

PKG_CHECK_MODULES(APERTIUM, apertium >= required_apertium_version)
PKG_CHECK_MODULES(LTTOOLBOX, lttoolbox >= required_lttoolbox_version)

AC_PATH_PROG([LTPRINT], [lt-print], [false], [$PATH$PATH_SEPARATOR$with_lt_print/bin])
AS_IF([test x$LTPRINT = xfalse], [AC_MSG_ERROR([You don't have lt-print installed])])

AC_PATH_PROG([CGCOMP], [cg-comp], [false], [$PATH$PATH_SEPARATOR$with_cg_comp/bin])
AS_IF([test x$CGCOMP = xfalse], [AC_MSG_ERROR([You don't have cg-comp installed])])

AC_PATH_PROG([CGPROC], [cg-proc], [false], [$PATH$PATH_SEPARATOR$with_cg_proc/bin])
AS_IF([test x$CGPROC = xfalse], [AC_MSG_ERROR([You don't have cg-proc installed])])

AP_MKINCLUDE

AC_OUTPUT([Makefile apertium-cat.pc])

