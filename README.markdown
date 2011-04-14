Ocamlyices: An Ocaml binding for Yices 1, version 0.5
=====================================================
Mickaël Delahaye, 2009-2011

[Yices][1] is an efficient SMT solver developed at SRI International. This
piece of software lets you use this SMT solver inside your own program in OCaml.

Requirements
------------

* Yices >= 1.0.29 < 2, http://yices.csl.sri.com,
  preferably without GMP statically linked.
  libyices.a or libyices.a must be installed on the system.

  After downloading the tarball from their website,
  You can use `./install-yices.sh yicesXYZ.tar.gz` to install yices in
  `/usr/local` and register the DLL. If a warning appears about the
  absence of `libyices.so`, you may have to use configure with
  `--enable-custom`. You can change destination directories with
  `./install-yices yices.tar.gz /usr/local /usr/local/lib64`

* GCC, Ocaml
* Findlib (optional)
* [Camlidl][2]

* GMP shared library and header <gmp.h>


* For developers, to use the latest version from the repository: autoconf


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
    sudo make install

Build and install Ocamlyices (native and bytecode libraries).

Part of the linking is done by an incremental linking, a.k.a , aka partial
linking, the rest is done by ocamlc or ocamlopt when you use Ocamlyices.

Install the library in `` `ocamlc -where`/ocamlyices`` and possibly a DLL in
`` `ocamlc -where`/stublibs``.


### Configure options: `./configure [OPTIONS]`

    --enable-custom
    --disable-custom [DEFAULT]

Build the Ocamlyices for custom bytecode compilation (see ocamlc manual for
more information), rather than using a shared library. As a result, every
program using such a version of ocamlyices will be compiled with the
option `-custom`.

    --enable-force-static
    --disable-force-static [DEFAULT]

Embed the static version of the Yices library into the ocamlyices library.
Force `--enable-partial-linking`.

    --enable-partial-linking [DEFAULT]
    --disbable-partial-linking

Partial linking is mostly needed to the second option (force static). Also,
with this option the `ocamlyices.cma/.cmxa` does not depend on camlidl.

### GMP

Yices uses a library for arbitrary precision arithmetic, called GMP. Like any
other dependency, this dependency may leads to version incompatibilities.
You may believe the "GMP statically linked" version of Yices answer this
problem. But, for our purpose, it does not (it could but it is another story).
Although the executable is statically linked to GMP, it is not the same for the
shared library or the static library (you can see it with `nm`).

At the moment (1.0.29), `libyices.so` is dependent on `libgmp.so.3`. If you
have a more recent system, `libgmp.so` may actually point to a newer version
(e.g. libgmp.so.10). However, the older version is usually kept for
compatibility you just need its full path to link with it. If you do not have
the correct version, you can always compile yourself GMP, but it will not be my
first choice.

The solution adopted in the configure:
- First, it tries to guess what `libyices.so` needs with `ldd`. If it's
  available (it is `ldd` job after all), it selects this version of GMP.
- Second, it tries to select `libgmp.so.3` (you cheat!) if it's available.
- Third, it fallbacks to the default `libgmp.so`.

You can also force a particular version with:

    --with-gmp=/usr/local/lib/libgmp.so.3

Usage
-----

With Ocamlfind:

	ocamlfind ocamlc/ocamlopt -package ocamlyices ...

Or without:

	ocamlc -I +ocamlyices nums.cma ocamlyices.cma ...
	ocamlopt -I +ocamlyices nums.cmxa ocamlyices.cmxa ...

_nums_ is required in order to handle GMP big integers as big_int.

Documentation
-------------

A documentation of the OCaml APIs is available in `doc/` provided you run this
command:

	make doc

For the rest, see the [official website][1].


Also, three examples are also available in `examples/`.

Uninstall
---------

	sudo make uninstall

Uninstall the library


License
-------

Copyright (c) 2011, Mickaël Delahaye, mickael.delahaye@gmail.com

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
