Ocamlyices: An Ocaml binding for Yices 1, version 0.6.2
=======================================================
Mickaël Delahaye, 2009-2012

[Yices][1] is an efficient SMT solver developed at SRI International. Ocamlyices
lets you use this SMT solver inside your own program in OCaml.

Requirements
------------

* [Yices][1], version 1.0.34 or more recent, but not 2,
  preferably with GMP statically linked (except on Linux x86_64 for now).
  After downloading the tarball from their website, you can use:

        ./install-yices.sh yicesXYZ.tar.gz

  to install yices in `/usr/local` and
  register the DLL. You can change destination directories with parameters:

        ./install-yices yices.tar.gz /usr/local /usr/local/lib64

* GCC, Ocaml
* Findlib (optional)
* [Camlidl][2]
* GMP shared library (only for Yices without GMP statically linked)

For developers, to use the latest version from the repository:

* autoconf


WARNING
-------

Hardly tested! and only under Linux (32 and 64 bit platforms), but reported to
work under MacOS X…

Setup
-----

Warning! Please make sure to uninstall any previous version beforehand.

    autoconf # Only if there is no configure
    ./configure
    make

Build the Ocamlyices library (for ocamlopt and ocamlc).
Part of the linking is done by an incremental, aka partial, linking, the rest is
done by ocamlc or ocamlopt when you use the Ocamlyices library

    sudo make install

Install the library in ``DESTDIR/ocamlyices`` and possibly a DLL in
``DESTDIR/stublibs``. If you have Findlib installed on your system, it uses
Findlib default destination directory. Otherwise, it calls `ocamlc -where` and
uses the standard Ocaml directory.


### Configure options: `./configure [OPTIONS]`

    --enable-custom
    --disable-custom [DEFAULT]

Build the Ocamlyices for custom bytecode compilation (see ocamlc manual for
more information), rather than using a shared library. As a result, every
program using such a version of ocamlyices will be compiled with the
option `-custom`.

    --enable-partial-linking [DEFAULT]
    --disbable-partial-linking

Partial linking is used so as the `ocamlyices.cma/.cmxa` does not depend on
the camlidl library.

### GMP

Yices uses a library for arbitrary precision arithmetic, called GMP. Like any
other dependency, this dependency may lead to version incompatibilities.
Yices' website propose a special version cooked with “GMP statically linked”.
This version contains only a static library `libyices.a`, which includes GMP.
However, using a static library leads to larger binaries and in case of
multi-process programs to larger memory footprint.

That is why personnaly I prefer to stick with Yices without GMP. At the moment
(1.0.34), `libyices.so` is dependent on `libgmp.so.10` (that is, a GMP version
5.x). Most recent systems comes with packages for the version 5.x of GMP, called
for instance `libgmp10` and `libgmp10-dev` (with headers) on Debian and Ubuntu.

Since version 0.6, Ocamlyices does not need to know which one is in use, but
you need to have it on your system. You can know if `libyices.so` has any
problem with `ldd`. Indeed `ldd /pathto/libyices.so` should notably print the
full path of the GMP dynamic library used by Yices.

Usage
-----

With Ocamlfind:

    ocamlfind ocamlc/ocamlopt -package ocamlyices ...

Or without:

    ocamlc -I +ocamlyices nums.cma ocamlyices.cma ...
    ocamlopt -I +ocamlyices nums.cmxa ocamlyices.cmxa ...

_nums_ is required in order to handle GMP big integers as big_int, but recent
versions of Ocaml does include it automatically.

Documentation
-------------

A documentation of the OCaml APIs is available [online][3] or locally in
`doc/` provided you run this command:

    make doc

For the rest, see the [Yices' official website][1].

Also, three examples are also available in `examples/`.

Uninstall
---------

    sudo make uninstall

Uninstall the library


License
-------

Copyright (c) 2012, Mickaël Delahaye, mickael.delahaye@gmail.com

Permission to use, copy, modify, and/or distribute this software for any purpose
with or without fee is hereby granted, provided that the above copyright notice
and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED “AS IS” AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF
THIS SOFTWARE.

[1]: http://yices.csl.sri.com/
[2]: http://caml.inria.fr/pub/old_caml_site/camlidl/
[3]: http://polazarus.github.com/ocamlyices/api
