#!/bin/sh

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

failwith() {
  echo [YI] Fatal error! "$*"
  exit 1
}

if [ $# -lt 1 -o "x$1" = "x--help" -o "x$1" = "x-h" ]; then
	echo "Usage: $0 yices.tar.gz '[PREFIX [LIB]]"
	echo 'Install Yices binary and DLL, given a tarball'
	echo
	echo 'Options:'
	echo '  PREFIX  Installation prefix, /usr/local by default'
	echo '  LIB     Library installation, $PREFIX/lib by default'
	echo '          (useful on some 64-bit platform)'
	exit 1
fi

## Not compatible with Cygwin
#if [ `id -u` -ne 0 ]; then
#	echo '[YI] Need super-user rights to install Yices, try sudo'
#	exec sudo $0 "$@"
#fi

ARCHIVE="`readlink -f "$1"`"
TEMPDIR=`mktemp -dt yices-install.XXXXXX`
INSTALL="${2:-/usr/local}"
LIBDIR="${3:-${INSTALL}/lib}"
BINDIR="${INSTALL}/bin"

mkdir -p "$TEMPDIR"
cd "$TEMPDIR"
echo tar -xzf "$ARCHIVE"
tar -xzf "$ARCHIVE" || failwith "cannot untar $ARCHIVE"

cd yices*

if [ ! -f lib/libyices.so ]; then
	echo "[YI] Warning! No shared libary present -> libgmp not needed"
fi

LIBS=`find lib/ \( -name '*.a' -o -name '*.so' \) -not -name 'cyg*.dll'`
LIBS_CYG=`find lib/ -name 'cyg*.dll'`

echo '[YI] Install libraries'
mkdir -p "$LIBDIR"
install -t "$LIBDIR" $LIBS || failwith "cannot install libraries"
if [ -n "$LIBS_CYG" ]; then
  mkdir -p "$BINDIR"
  install -t "$BINDIR" $LIBS_CYG || failwith "cannot install libraries"
fi
if which ldconfig > /dev/null; then
  ldconfig || failwith "ldconfig failed"
else
  echo "[YI] ldconfig not found"
fi

echo '[YI] Install headers'
mkdir -p "$INSTALL/include"
install -t "$INSTALL/include" -m 'a=r,u+w' include/*.h || failwith "cannot install headers"

echo '[YI] Install executable'
mkdir -p "$BINDIR"
install -t "$BINDIR" bin/yices || failwith "cannot install executable"

cd
echo '[YI] Cleaning up'
rm -rf "$TEMPDIR"

echo '[YI] Done'




