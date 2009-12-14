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

echo install libraries...
mv lib/libyices.so lib/libyices.a "$INSTALL"/lib || failwith "cannot install libraries"
chmod a+r,g-wx "$INSTALL"/lib/libyices.* || failwith "cannot set libraries' rights"
ldconfig -n "$INSTALL"/lib || failwith "ldconfig failed"

echo install headers...
mv include/yices*.h "$INSTALL"/include || failwith "cannot install headers"
chmod a+r,g-wx "$INSTALL"/include/yices*.h || failwith "cannot set headers' rights"

echo install executable...
mv bin/yices "$INSTALL"/bin/ || failwith "cannot install executable"
chmod a+rx,g-w "$INSTALL"/bin/yices || failwith "cannot set yices executable's rights"

cd /tmp

echo cleaning...
rm -rf "$TEMPDIR"

echo done




