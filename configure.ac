# Copyright (c) 2012, Mickaël Delahaye <mickael.delahaye@gmail.com>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED “AS IS” AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.


AC_INIT(ocamlyices,0.6.2)

AC_PROG_CC
AC_PROG_CXX
AC_PROG_RANLIB

LIBS=-lstdc++

AC_CHECK_PROG([OCAMLC], [ocamlc], [ocamlc])
AS_IF([test "x$OCAMLC" = x], [
  AC_MSG_ERROR(Cannot find ocamlc.)
])

OCAMLVERSION=`$OCAMLC -version`
AC_MSG_NOTICE([ocaml version is $OCAMLVERSION])
OCAMLLIB=`$OCAMLC -where`
AC_MSG_NOTICE([ocaml library path is $OCAMLLIB])


AC_CHECK_PROG([OCAMLFIND], [ocamlfind], [ocamlfind])
AS_IF([test "x$OCAMLFIND" = x], [
  AC_MSG_WARN([Cannot find ocamlfind. Use only the standard Ocaml library directory.])
  OCAMLDESTDIR=$OCAMLLIB
], [
  OCAMLDESTDIR=`$OCAMLFIND printconf destdir`
  AS_IF([test "x$OCAMLDESTDIR" != "x$OCAMLLIB"],[
    OCAMLLIB="$OCAMLLIB $OCAMLDESTDIR"
  ])
])

AC_CHECK_PROG([OCAMLOPT], [ocamlopt], [ocamlopt])
OCAMLBEST=byte
AS_IF([test "x$OCAMLOPT" = x], [
  AC_MSG_WARN([Cannot find ocamlopt; bytecode compilation only.])
], [
  AC_MSG_CHECKING([ocamlopt version])
  TMPVERSION=`$OCAMLOPT -version`

  AS_IF([test "$TMPVERSION" != "$OCAMLVERSION"],[
    AC_MSG_RESULT([differs from ocamlc; ocamlopt discarded.])
    OCAMLOPT=no
  ],[
    AC_MSG_RESULT([ok])
    OCAMLBEST=opt
  ])
])

AC_CHECK_PROG([OCAMLDOC], [ocamldoc], [ocamldoc])
AS_IF([test "x$OCAMLDOC" = x],[
  AC_MSG_ERROR([Cannot find ocamldoc.])
])

AC_CHECK_PROG([CAMLIDL], [camlidl], [camlidl])
AS_IF([test "x$CAMLIDL" = x], [
  AC_MSG_ERROR(Cannot find camlidl.)
])

AC_MSG_CHECKING([platform])
AS_IF([echo "let _ = Sys.os_type" | ocaml | grep -q Win32 > /dev/null], [
	AC_MSG_RESULT(Win32)
	OCAMLWIN32=yes
	EXEEXT=.exe
], [
  AC_MSG_RESULT(*nix)
	OCAMLWIN32=no
	EXEEXT=
])

################################################################################

AC_CHECK_FUNC(__gmpz_init, [
  AC_MSG_NOTICE([Yices with GMP statically linked])
  AC_MSG_NOTICE([Ocamlyices will be linked with libyices.a])
  STATIC_YICES_WITH_GMP=yes
], [
  AC_MSG_NOTICE([Yices with GMP dynamically linked])
  AC_MSG_NOTICE([Ocamlyices will be linked with libyices.so])
  STATIC_YICES_WITH_GMP=no
  GMP_SWITCH=-lgmp
])

# Old: This doesn't work as GMP is not in LIBS yet
AC_CHECK_LIB(yices,yices_version,[],[
	AC_MSG_ERROR(Cannot find yices.)
], [$GMP_SWITCH])

################################################################################

AC_ARG_WITH(destdir,
  [AS_HELP_STRING([--with-destdir=destdir],[force a dest dir])],
  [OCAMLDESTDIR=$with_destdir],
  [])

################################################################################

AC_ARG_ENABLE(custom,
  [AS_HELP_STRING([--enable-custom], [Custom compilation (ocamlc option)])],
  [CUSTOM=${enableval}],
  [CUSTOM=no])

AC_ARG_ENABLE(partial-linking,
  [AS_HELP_STRING([--disable-partial-linking],
    [Disable incremental compilation])],
  [PARTIAL_LINKING=${enableval}],
  [PARTIAL_LINKING=yes])

AS_IF([test "x$PARTIAL_LINKING" != xno], [PARTIAL_LINKING=yes])
AS_IF([test "x$CUSTOM" != xno], [CUSTOM=yes])

################################################################################

AC_SUBST(PARTIAL_LINKING)
AC_SUBST(CUSTOM)

AC_SUBST(OCAMLC)
AC_SUBST(CAMLIDL)
AC_SUBST(OCAMLOPT)
AC_SUBST(OCAMLDOC)
AC_SUBST(OCAMLDEP)
AC_SUBST(OCAMLFIND)

AC_SUBST(OCAMLBEST)
AC_SUBST(OCAMLVERSION)
AC_SUBST(OCAMLLIB)
AC_SUBST(OCAMLDESTDIR)
AC_SUBST(OCAMLWIN32)
AC_SUBST(EXEEXT)
AC_SUBST(STATIC_YICES_WITH_GMP)

AC_CONFIG_FILES([Makefile],[chmod a-w Makefile])
AC_OUTPUT
