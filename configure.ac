AC_INIT(ocamlyices,0.5)

AC_PROG_CC
AC_PROG_RANLIB

AC_CHECK_PROG(OCAMLC,ocamlc,ocamlc)
AS_IF([test "x$OCAMLC" = x],[
	AC_MSG_ERROR(Cannot find ocamlc.)
])

OCAMLVERSION=`$OCAMLC -version`
AC_MSG_NOTICE([ocaml version is $OCAMLVERSION])
OCAMLLIB=`$OCAMLC -where`
AC_MSG_NOTICE([ocaml library path is $OCAMLLIB])


AC_CHECK_PROG(OCAMLFIND,ocamlfind,ocamlfind)
AS_IF([test "x$OCAMLFIND" = x], [
  AC_MSG_WARN(Cannot find ocamlfind. Use only the standard Ocaml library directory.)
  OCAMLDESTDIR=$OCAMLLIB
], [
  OCAMLDESTDIR=`$OCAMLFIND printconf destdir`
  AS_IF([test "x$OCAMLDESTDIR" != "x$OCAMLLIB"],[
    OCAMLLIB="$OCAMLLIB $OCAMLDESTDIR"
  ])
])

AC_CHECK_PROG(OCAMLOPT,ocamlopt,ocamlopt)
OCAMLBEST=byte
AS_IF([test "x$OCAMLOPT" = x], [
  AC_MSG_WARN(Cannot find ocamlopt; bytecode compilation only.)
], [
  AC_MSG_CHECKING(ocamlopt version)
  TMPVERSION=`$OCAMLOPT -version`

  AS_IF([test "$TMPVERSION" != "$OCAMLVERSION"],[
    AC_MSG_RESULT(differs from ocamlc; ocamlopt discarded.)
    OCAMLOPT=no
  ],[
    AC_MSG_RESULT(ok)
    OCAMLBEST=opt
  ])
])

AC_CHECK_PROG(OCAMLDOC,ocamldoc,ocamldoc)
AS_IF([test "x$OCAMLDOC" = x],[
	AC_MSG_ERROR(Cannot find ocamldoc.)
])

#AC_CHECK_PROG(OCAMLDEP,ocamldep,ocamldep)
#AS_IF([test "x$OCAMLDEP" != x], [
#	AC_MSG_ERROR(Cannot find ocamldep.)
#])

AC_CHECK_PROG(CAMLIDL,camlidl,camlidl)
AS_IF([test "x$CAMLIDL" = x], [
	AC_MSG_ERROR(Cannot find camlidl.)
])

AC_MSG_CHECKING(platform)
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

AS_IF([test -f /usr/local/lib/libyices.so], [LIBYICES=/usr/local/lib/libyices.so],
  [test -f /opt/lib/libyices.so], [LIBYICES=/opt/lib/libyices.so],
  [test -f /usr/lib/libyices.so], [LIBYICES=/usr/lib/libyices.so],
  [])

GMP_DEFAULT=`gcc -print-file-name=libgmp.so.3`
AS_CASE([$GMP_DEFAULT], [/*], [GMP_DEFAULT=`readlink -f $GMP_DEFAULT`], [GMP_DEFAULT=gmp])
# Cheating is bad...

AS_IF([test "x$LIBYICES" != x],[
  AC_MSG_CHECKING(GMP dependency for libyices)
  AS_IF([ldd $LIBYICES | grep libgmp > /dev/null],[
    GMP=`ldd $LIBYICES | grep libgmp | head -1 | cut -d' ' -f3`
    AS_CASE([$GMP], [/*], [AC_MSG_RESULT($GMP)],[
      need=`ldd $LIBYICES | grep libgmp | head -1 | cut -d' ' -f1`
      need=`echo $need`
      AC_MSG_ERROR(no suitable GMP found for $need)
    ])
  ],[
    GMP=$GMP_DEFAULT
    AC_MSG_RESULT([unknwon, fallback to best guess: $GMP])
  ])
],[
  GMP=$GMP_DEFAULT
  AC_MSG_WARN([libyices not found! fallback to best guess: $GMP])
])

################################################################################

AC_ARG_WITH(destdir,
  [AS_HELP_STRING([--with-destdir=destdir],[force a dest dir])],
  [OCAMLDESTDIR=$with_destdir],
  [])

AC_ARG_WITH(gmp,
  [AS_HELP_STRING([--with-gmp], [Dynamically link GMP (you may precise the full path to the correct version of the shared library)])],
  [AS_IF([test "x$with_gmp" = xno],[GMP=''],
    [test "x$with_gmp" = xyes],[],
    [GMP="$with_gmp"])],
  [])

################################################################################

AC_ARG_ENABLE(custom,
  [AS_HELP_STRING([--enable-custom], [Custom compilation (ocamlc option)])],
  [CUSTOM=${enableval}],
  [CUSTOM=no])

AC_ARG_ENABLE(partial-linking,
  [AS_HELP_STRING([--enable-partial-linking], [Incremental compilation])],
  [PARTIAL_LINKING=${enableval}],
  [PARTIAL_LINKING=yes])
  
AC_ARG_ENABLE(force-static,
  [AS_HELP_STRING([--enable-force-static], [Force static linking of Yices (implies --enable-partial-linking)])],
  [FORCE_STATIC=${enableval}],
  [FORCE_STATIC=no; PARTIAL_LINKING=yes])

AS_IF([test "x$PARTIAL_LINKING" != xno], [PARTIAL_LINKING=yes])
AS_IF([test "x$CUSTOM" != xno], [CUSTOM=yes])
AS_IF([test "x$FORCE_STATIC" != xno], [FORCE_STATIC=yes])

#AC_MSG_CHECKING(for Yices shared library)
#AS_IF([ldconfig -p | grep -q libyices.so],[YICES_SHARED_LIB=yes],[YICES_SHARED_LIB=no])
#AC_MSG_RESULT($YICES_SHARED_LIB)
#AS_IF([test "$YICES_SHARED_LIB" = no],[
#  AC_MSG_WARN(Cannot find the shared library of Yices, forcing static linking)
#  FORCE_STATIC=yes
#])

AS_IF([test "$FORCE_STATIC" = yes -a "$PARTIAL_LINKING" = no],[
  AC_MSG_WARN(Partial linking disabling overriden by forcing static)
  PARTIAL_LINKING=yes
])

################################################################################

AC_SUBST(PARTIAL_LINKING)
AC_SUBST(CUSTOM)
AC_SUBST(FORCE_STATIC)

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
AC_SUBST(GMP)

AC_CONFIG_FILES([Makefile],[chmod a-w Makefile])
AC_OUTPUT
