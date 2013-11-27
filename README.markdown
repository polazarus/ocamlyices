Ocamlyices 0.7.0
================
An Ocaml binding for Yices 1

Mickaël Delahaye

[Yices][1] is an efficient SMT solver developed at SRI International. Ocamlyices
lets you use this SMT solver inside your own program in OCaml.

*Warning!* Only tested under Linux (32 and 64 bit platforms), but reported to
work under MacOS X…


First requirement: Yices
------------------------

[Yices][1] 1.0.34 or more recent (but not 2)  needs to be *installed* on your system.
It can be done in two steps:

1.  First download the latest tarball of Yices 1 from SRI website, 
    Prefer the version with GMP statically linked, except on Linux x86_64 (see note below).

2.  Install Yices on your system as follow:

        wget -q -O- http://git.io/sWxMmg | sh -s <yices-XYZ.tar.gz>

    where <yices-XYZ.tar.gz> should be replaced with the path to the downloaded
    tarball. The script (available in the repository) installs Yices in `/usr/local`
    and register the shared library.
    Optionally you can set installation directories (root and library):
    wget -q -O- http://git.io/sWxMmg | sh -s <yices-XYZ.tar.gz> /opt /opt/lib64


**N.B.:** On Linux x86_64 (and possibly other 64 bit platform), only “Yices with
GMP dynamically linked” is supported at the moment. Indeed, `libyices.a`
(provided in “Yices with GMP statically linked”) is not compiled with the
`-fPIC` flag and cannot be compiled with Ocamlyices.


Easy install (requires OPAM)
----------------------------

Once Yices is installed, use OPAM:

    opam update
    opam install ocamlyices

Done.


Usage
-----

With Ocamlfind:

    ocamlfind ocamlc/ocamlopt -package ocamlyices ...

Or without:

    ocamlc -I +ocamlyices nums.cma ocamlyices.cma ...
    ocamlopt -I +ocamlyices nums.cmxa ocamlyices.cmxa ...

_nums_ is required in order to handle GMP big integers as `big_int`, but recent
versions of Ocaml should infer it automatically.


Documentation
-------------

A documentation of the OCaml APIs is available [online][3] or locally in
`doc/` provided you run this command:

    make doc

For the rest, see the [Yices' official website][1].

Also, three examples are also available in `examples/`.


Manual install
--------------

### Additional requirements

* GCC, Ocaml
* Findlib
* [Camlidl][2]
* GMP shared library (only for Yices without GMP statically linked)
* and optionally autoconf if you wish to tinker with the configuration file.

### Step by step

1.  Download and extract the last release from
    [Github](https://github.com/polazarus/ocamlyices/releases)
    or clone the last version from the repository (at your own risk).

2.  Please make sure to uninstall any previous version beforehand.

2.  Configure and build the Ocamlyices library (bytecode and native version):

        autoconf # Only if there is no configure
        ./configure
        make

    Part of the linking is done by an incremental, aka partial, linking, the rest is
    done by ocamlc or ocamlopt when you use the Ocamlyices library

3.  Install the library using ocamlfind's (Findlib) default destination directory:

        make install

    Depending on your Ocaml installation you may need admin rights or to `sudo`
    this last command.

### (Expert) Configure options: `./configure [OPTIONS]`

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

### (Expert) About GMP

Yices uses a library for arbitrary precision arithmetic, called GMP. Like any
other dependency, this dependency may lead to version incompatibilities.
Yices' website proposes a special version cooked with “GMP statically linked”.
This version contains only a static library `libyices.a`, which includes GMP.
However, using a static library leads to larger binaries and in case of
multi-process programs to larger memory footprint.

That is why personnally I prefer to stick with Yices without GMP. At the moment
(1.0.34), `libyices.so` is dependent on `libgmp.so.10` (that is, a GMP version
5.x). Most recent systems come with packages for the version 5.x of GMP, called
for instance `libgmp10` and `libgmp10-dev` (with headers) on Debian and Ubuntu.

Since version 0.6, Ocamlyices does not need to know which one is in use, but
you need to have it on your system. You can know if `libyices.so` has any
problem with `ldd`. Indeed `ldd /pathto/libyices.so` should notably print the
full path of the GMP dynamic library used by Yices.


Uninstall
---------

If you used opam to install it:

    opam remove ocamlyices

Otherwise:

    ocamlfind remove ocamlyices


License
-------

Copyright (c) 2009-2013, Mickaël Delahaye, http://micdel.fr

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
[3]: http://micdel.fr/ocamyices-api
