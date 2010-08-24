#!/bin/bash

# Copyright (c) 2010, Mickaël Delahaye <mickael.delahaye@gmail.com>
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
  echo ERROR: "$*"
  exit 1
}

if [[ $# -lt 1 ]]; then
  echo usage: $0 yices.tar.gz '[PREFIX [LIBDIR]]'

  echo   PREFIX /usr/local by default
  echo   LIBDIR ${PREFIX}/lib by default
  exit 1
fi

if [[ "$(id -u)" -ne 0 ]]; then
  echo ERROR: $0 must be ran as root
  exit 1
fi

ARCHIVE="$(readlink -f "$1")"
TEMPDIR="/tmp/yices-install"
INSTALL="${2:-/usr/local}"
LIBDIR="${3:-${INSTALL}/lib}"

mkdir -p "$TEMPDIR"
cd "$TEMPDIR"
echo tar xzf "$ARCHIVE"
tar -xzf "$ARCHIVE" || failwith cannot untar $ARCHIVE

cd yices*

if [[ ! -e lib/libyices.so ]]; then
  echo "WARNING No shared libary present"
fi

echo Install libraries...
install lib/* "$LIBDIR" || failwith "cannot install libraries"
ldconfig || failwith "ldconfig failed"

echo Install headers...
install -m 'a=r,u+w' include/*.h "$INSTALL"/include || failwith "cannot install headers"

echo Install executable...
install bin/yices "$INSTALL"/bin/ || failwith "cannot install executable"

cd /tmp

echo cleaning...
rm -rf "$TEMPDIR"

echo done




