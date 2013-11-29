open OUnit2
open Util

let test_mk_and2 test_ctxt =
  let ctx = bracket_mk_context test_ctxt in
  let t = Yices.mk_true ctx and f = Yices.mk_false ctx in
  Yices.push ctx;
  Yices.assert_simple ctx (Yices.mk_and2 ctx t t);
  assert_equal Yices.True (Yices.check ctx);
  Yices.pop ctx;
  Yices.push ctx;
  Yices.assert_simple ctx (Yices.mk_and2 ctx t f);
  assert_equal Yices.False (Yices.check ctx);
  Yices.pop ctx;
  Yices.push ctx;
  Yices.assert_simple ctx (Yices.mk_and2 ctx f t);
  assert_equal Yices.False (Yices.check ctx);
  Yices.pop ctx;
  Yices.push ctx;
  Yices.assert_simple ctx (Yices.mk_and2 ctx f f);
  assert_equal Yices.False (Yices.check ctx)

let test_mk_or2 test_ctxt =
  let ctx = bracket_mk_context test_ctxt in
  let t = Yices.mk_true ctx and f = Yices.mk_false ctx in
  Yices.push ctx;
  Yices.assert_simple ctx (Yices.mk_or2 ctx t t);
  assert_equal Yices.True (Yices.check ctx);
  Yices.pop ctx;
  Yices.push ctx;
  Yices.assert_simple ctx (Yices.mk_or2 ctx t f);
  assert_equal Yices.True (Yices.check ctx);
  Yices.pop ctx;
  Yices.push ctx;
  Yices.assert_simple ctx (Yices.mk_or2 ctx f t);
  assert_equal Yices.True (Yices.check ctx);
  Yices.pop ctx;
  Yices.push ctx;
  Yices.assert_simple ctx (Yices.mk_or2 ctx f f);
  assert_equal Yices.False (Yices.check ctx)

let test_mk_nand2 test_ctxt =
  let ctx = bracket_mk_context test_ctxt in
  let t = Yices.mk_true ctx and f = Yices.mk_false ctx in
  Yices.push ctx;
  Yices.assert_simple ctx (Yices.mk_nand2 ctx t t);
  assert_equal Yices.False (Yices.check ctx);
  Yices.pop ctx;
  Yices.push ctx;
  Yices.assert_simple ctx (Yices.mk_nand2 ctx t f);
  assert_equal Yices.True (Yices.check ctx);
  Yices.pop ctx;
  Yices.push ctx;
  Yices.assert_simple ctx (Yices.mk_nand2 ctx f t);
  assert_equal Yices.True (Yices.check ctx);
  Yices.pop ctx;
  Yices.push ctx;
  Yices.assert_simple ctx (Yices.mk_nand2 ctx f f);
  assert_equal Yices.True (Yices.check ctx)

let test_mk_nand test_ctxt =
  let ctx = bracket_mk_context test_ctxt in
  let t = Yices.mk_true ctx and f = Yices.mk_false ctx in
  Yices.push ctx;
  Yices.assert_simple ctx (Yices.mk_nand ctx [|t;t;t;t|]);
  assert_equal Yices.False (Yices.check ctx);
  Yices.pop ctx;
  Yices.push ctx;
  Yices.assert_simple ctx (Yices.mk_nand ctx [|t;t;f;t;f|]);
  assert_equal Yices.True (Yices.check ctx);
  Yices.pop ctx;
  Yices.push ctx;
  Yices.assert_simple ctx (Yices.mk_nand ctx [|f;t;t;t|]);
  assert_equal Yices.True (Yices.check ctx);
  Yices.pop ctx;
  Yices.push ctx;
  Yices.assert_simple ctx (Yices.mk_nand ctx [|f;f;f;f;f;f|]);
  assert_equal Yices.True (Yices.check ctx)

let test_mk_nand_nil test_ctxt =
  let ctx = bracket_mk_context test_ctxt in
  Yices.assert_simple ctx (Yices.mk_nand ctx [||]);
  assert_equal Yices.False (Yices.check ctx)

let test_mk_and_nil test_ctxt =
  let ctx = bracket_mk_context test_ctxt in
  Yices.assert_simple ctx (Yices.mk_and ctx [||]);
  assert_equal Yices.True (Yices.check ctx)

let test_mk_or_nil test_ctxt =
  let ctx = bracket_mk_context test_ctxt in
  Yices.assert_simple ctx (Yices.mk_or ctx [||]);
  assert_equal Yices.False (Yices.check ctx)

let tests = [
    "mk_and2" >:: test_mk_and2;
    "mk_or2" >:: test_mk_or2;
    "mk_nand2" >:: test_mk_nand2;
    "mk_nand" >:: test_mk_nand;
    "mk_nand with zero-length array" >:: test_mk_nand_nil;
    "mk_and with zero-length array" >:: test_mk_and_nil;
    "mk_or with zero-length array" >:: test_mk_or_nil;
  ]
