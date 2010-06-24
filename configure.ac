AC_INIT(ocamlyices,0.3)

AC_PROG_CC
AC_PROG_RANLIB

AC_CHECK_PROG(OCAMLC,ocamlc,ocamlc,no)
if test "$OCAMLC" = no ; then
	AC_MSG_ERROR(Cannot find ocamlc.)
fi

OCAMLVERSION=`$OCAMLC -version`
echo "ocaml version is $OCAMLVERSION"
OCAMLLIB=`$OCAMLC -where`
echo "ocaml library path is $OCAMLLIB"

OCAMLDESTDIR=$OCAMLLIB
AC_ARG_WITH(destdir,[AS_HELP_STRING([--with-destdir=destdir],[force a dest dir])],[OCAMLDESTDIR=$with_destdir],[])


AC_CHECK_PROG(OCAMLOPT,ocamlopt,ocamlopt,no)
OCAMLBEST=byte
if test "$OCAMLOPT" = no ; then
	AC_MSG_WARN(Cannot find ocamlopt; bytecode compilation only.)
else
	AC_MSG_CHECKING(ocamlopt version)
	TMPVERSION=`$OCAMLOPT -version`
	if test "$TMPVERSION" != "$OCAMLVERSION" ; then
		AC_MSG_RESULT(differs from ocamlc; ocamlopt discarded.)
		OCAMLOPT=no
	else
		AC_MSG_RESULT(ok)
		OCAMLBEST=opt
	fi
fi

AC_CHECK_PROG(OCAMLCDOTOPT,ocamlc.opt,ocamlc.opt,no)
if test "$OCAMLCDOTOPT" != no ; then
	AC_MSG_CHECKING(ocamlc.opt version)
	TMPVERSION=`$OCAMLCDOTOPT -version`
	if test "$TMPVERSION" != "$OCAMLVERSION" ; then
		AC_MSG_RESULT(differs from ocamlc; ocamlc.opt discarded.)
	else
		AC_MSG_RESULT(ok)
		OCAMLC=$OCAMLCDOTOPT
	fi
fi

# checking for ocamlopt.opt
if test "$OCAMLOPT" != no ; then
	AC_CHECK_PROG(OCAMLOPTDOTOPT,ocamlopt.opt,ocamlopt.opt,no)
	if test "$OCAMLOPTDOTOPT" != no ; then
	AC_MSG_CHECKING(ocamlc.opt version)
	TMPVER=`$OCAMLOPTDOTOPT -version`
	if test "$TMPVER" != "$OCAMLVERSION" ; then
		AC_MSG_RESULT(differs from ocamlc; ocamlopt.opt discarded.)
	else
		AC_MSG_RESULT(ok)
		OCAMLOPT=$OCAMLOPTDOTOPT
	fi
	fi
fi

AC_CHECK_PROG(OCAMLDOC,ocamldoc,ocamldoc,no)
if test "$OCAMLDOC" = no ; then
	AC_MSG_ERROR(Cannot find ocamldoc.)
fi

AC_CHECK_PROG(OCAMLDOCDOTOPT,ocamldoc.opt,ocamldoc.opt,no)
if test "$OCAMLDOCDOTOPT" != no ; then
  OCAMLDOC=$OCAMLDOCDOTOPT
fi

AC_CHECK_PROG(OCAMLDEP,ocamldep,ocamldep,no)
if test "$OCAMLDEP" = no ; then
	AC_MSG_ERROR(Cannot find ocamldep.)
fi
AC_CHECK_PROG(OCAMLDEPDOTOPT,ocamldep.opt,ocamldep.opt,no)
if test "$OCAMLDEPDOTOPT" = no ; then
	OCAMLDEP=$OCAMLDEPDOTOPT
fi

AC_CHECK_PROG(CAMLIDL,camlidl,camlidl,no)
if test "$CAMLIDL" = no ; then
	AC_MSG_ERROR(Cannot find camlidl.)
fi

AC_MSG_CHECKING(platform)
if echo "let _ = Sys.os_type" | ocaml | grep -q Win32; then
	AC_MSG_RESULT(Win32)
	OCAMLWIN32=yes
	EXEEXT=.exe
else
  AC_MSG_RESULT(*nix)
	OCAMLWIN32=no
	EXEEXT=
fi



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

AC_MSG_CHECKING(for Yices shared library)
AS_IF([ldconfig -p | grep -q libyices.so],[YICES_SHARED_LIB=yes],[YICES_SHARED_LIB=no])
AC_MSG_RESULT($YICES_SHARED_LIB)
AS_IF([test "$YICES_SHARED_LIB" = no],[
  AC_MSG_WARN(Cannot find the shared library of Yices, forcing static linking)
  FORCE_STATIC=yes
])

AS_IF([test "$FORCE_STATIC" = yes -a "$PARTIAL_LINKING" = no],[
  AC_MSG_WARN(Partial linking disabling overriden by forcing static)
  PARTIAL_LINKING=yes
])

################################################################################

AC_SUBST(PARTIAL_LINKING)
AC_SUBST(CUSTOM)
AC_SUBST(FORCE_STATIC)

AC_SUBST(YICES_SHARED_LIB)
AC_SUBST(OCAMLC)
AC_SUBST(CAMLIDL)
AC_SUBST(OCAMLOPT)
AC_SUBST(OCAMLDOC)
AC_SUBST(OCAMLDEP)
AC_SUBST(OCAMLBEST)
AC_SUBST(OCAMLVERSION)
AC_SUBST(OCAMLLIB)
AC_SUBST(OCAMLDESTDIR)
AC_SUBST(OCAMLWIN32)
AC_SUBST(EXEEXT)

AC_CONFIG_FILES([Makefile],[chmod a-w Makefile])
AC_OUTPUT
