#!/bin/bash

failwith() {
  echo ERROR: "$*"
  exit 1
}

if [[ $# -ne 1 ]]; then
  echo usage: $0 yices.tar.gz
  exit 1
fi

if [[ "$(id -u)" -ne 0 ]]; then
  echo ERROR: $0 must be ran as root
  exit 1
fi

ARCHIVE="$1"
TEMPDIR="/tmp/yices-install"
INSTALL="/usr/local"

mkdir -p "$TEMPDIR"
cd "$TEMPDIR"
echo tar xzf "$ARCHIVE"
tar -xzf "$ARCHIVE" || failwith cannot untar $ARCHIVE

cd yices*

echo Install libraries...
install lib/* "$INSTALL"/lib || failwith "cannot install libraries"
ldconfig -n "$INSTALL"/lib || failwith "ldconfig failed"

echo Install headers...
install -m 'a=r,u+w' include/*.h "$INSTALL"/include || failwith "cannot install headers"

echo Install executable...
install bin/yices "$INSTALL"/bin/ || failwith "cannot install executable"

cd /tmp

echo cleaning...
rm -rf "$TEMPDIR"

echo done




