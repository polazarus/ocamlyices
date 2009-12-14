#include <stddef.h>
#include <string.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include <caml/callback.h>
#ifdef Custom_tag
#include <caml/custom.h>
#include <caml/bigarray.h>
#endif
#include "yices.h"

struct unsat_core get_unsat_core(yices_context ctx) {
  struct unsat_core res;
  res.length = yices_get_unsat_core_size(ctx);
  res.array = malloc(sizeof(assertion_id[res.length]));
  if (res.array) {
    int put = yices_get_unsat_core(ctx,res.array);
    if (res.length != put) {
      free(res.array);
      res.array = 0;
    }
  }
  return res;
}

char* get_rational_value_as_string(model m, var_decl d) {
  mpq_t q;
  mpq_init(q);
  int base = 10;
  char* res;
  check_value_error(yices_get_mpq_value(m,d,q));
  res = malloc(sizeof(char[mpz_sizeinbase (mpq_numref(q), base) + mpz_sizeinbase (mpq_denref(q), base) + 3]));
  if (res) {
    char* rres = mpq_get_str(res,base,q);
    if(rres != res) {
      free(res);
      res = 0;
    }
  }
  return res;
}

char* get_integer_value_as_string(model m, var_decl d) {
  mpz_t z;
  mpz_init(z);
  int base = 10;
  char* res;
  check_value_error(yices_get_mpz_value(m,d,z));
  res = malloc(sizeof(char[mpz_sizeinbase (z, base) + 2]));
  if (res) {
    char* rres = mpz_get_str(res,base,z);
    if(rres != res) {
      free(res);
      res = 0;
    }
  }
  return res;
}
