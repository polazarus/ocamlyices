/*
Copyright (c) 2012, Mickaël Delahaye <mickael.delahaye@gmail.com>

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
*/

#include <stdio.h>
#include <yices_c.h>

/* Yices_c additional functions */

// Given on yices-help by Bruno Dutertre (2009-12-16)
extern void yices_interrupt(yices_context ctx);

typedef void* yicesl_context;

// Given on yices-help by Bruno Dutertre (2010-06-01)
extern yicesl_context yices_get_lite_context(yices_context ctx);


/* Virtual types and names*/

#define yices_error int
#define yices_error_with_message int
#define yices_type_ptr yices_type*
#define srec_p srec_t*

#define True l_true
#define False l_false
#define Undef l_undef


/* srec handler */

#define srec2string(s) copy_string((*(s))->str)


/* Unsat core array */

struct unsat_core {
  int length;
  assertion_id* array;
};


/* Check macros */

#define check_yices_error(e) if (e == 0) caml_failwith("cannot get a value")
#define check_yices_error_with_message(e) if (e == 0) \
  caml_failwith(yices_get_last_error_message())

#define CHECKNOTNULL(p,m) if (p == (void*)0) caml_failwith("null return value (" m ")")
#define check_expr(e) CHECKNOTNULL(e,"expression")
#define check_type(e) CHECKNOTNULL(e,"type")
#define check_var_decl(e) CHECKNOTNULL(e,"variable declaration")
#define check_context(e) CHECKNOTNULL(e,"context")
#define check_model(e) CHECKNOTNULL(e,"model")
#define check_var_decl_iterator(e) CHECKNOTNULL(e,"iterator")

/* Yicesl macros */
#define yicesl_error int
#define check_yicesl_error(res) if (!res) caml_failwith(yicesl_get_last_error_message())
#define check_yicesl_context(res) if (res == 0) caml_failwith("null return value (Yicesl context)")

