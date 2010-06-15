/*
Copyright (c) 2010, Mickaël Delahaye <mickael.delahaye@gmail.com>

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

#include <gmp.h>
#include <yices_c.h>

// Given on yices-help by Bruno Dutertre (2009-12-16)
extern void yices_interrupt(yices_context ctx);

typedef void* yicesl_context;

// Given on yices-help by Bruno Dutertre (2010-06-01)
extern yicesl_context yices_get_lite_context(yices_context ctx);

// Guessed from nm
extern yices_expr yices_mk_function_update(yices_context ctx, yices_expr f, yices_expr args[], unsigned int n, yices_expr val);
extern yices_expr yices_mk_tuple_literal(yices_context ctx, yices_expr args[], unsigned int n);


#define yicesl yicesl_context
#define expr yices_expr
#define typ yices_type
#define var_decl yices_var_decl
#define context yices_context
#define model yices_model
#define var_decl_iterator yices_var_decl_iterator

#define True l_true
#define False l_false
#define Undef l_undef

#define value_error int
#define ptyp yices_type*


struct unsat_core {
  int length;
  assertion_id* array;
};

struct unsat_core get_unsat_core(yices_context ctx);
char* get_rational_value_as_string(model m, var_decl d);
char* get_integer_value_as_string(model m, var_decl d);

#define check_value_error(e) if (!e) failwith("error: cannot get a value")

#define CHECKNOTNULL(p,m) if (p == 0) failwith("error :" m)

#define check_expr(e) CHECKNOTNULL(e,"returns null expression")
#define check_type(e) CHECKNOTNULL(e,"returns null type")
#define check_var_decl(e) CHECKNOTNULL(e,"returns null variable declaration")
#define check_context(e) CHECKNOTNULL(e,"returns null context")
#define check_model(e) CHECKNOTNULL(e,"returns null model")
#define check_var_decl_iterator(e) CHECKNOTNULL(e,"returns null iterator")


