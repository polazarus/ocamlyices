open OUnit2

let mk_implies ctx a b = Yices.mk_or ctx [|Yices.mk_not ctx  a; b|]

let with_context f =
  let ctx = Yices.mk_context () in
  let a = f ctx in
  Yices.del_context ctx; a

let test_version _ = assert_equal  (String.sub (Yices.version ()) 0 2) "1."

let test_context _ =
  with_context (fun ctx -> ())

let test_boolean_sat _ =
  with_context (fun ctx ->
    let a = Yices.mk_bool_var ctx "a"
    and b = Yices.mk_bool_var ctx "b"
    and c = Yices.mk_bool_var ctx "c" in
    let a_implies_b = mk_implies ctx a b
    and b_implies_c = mk_implies ctx b c in
    Yices.assert_simple ctx a_implies_b;
    Yices.assert_simple ctx b_implies_c;
    Yices.assert_simple ctx a;
    assert_equal (Yices.check ctx) Yices.True;
  )

let test_boolean_sat_model _ =
  with_context (fun ctx ->
    let a = Yices.mk_bool_var ctx "a"
    and b = Yices.mk_bool_var ctx "b"
    and c = Yices.mk_bool_var ctx "c" in
    let a_implies_b = mk_implies ctx a b
    and b_implies_c = mk_implies ctx b c in
    Yices.assert_simple ctx a_implies_b;
    Yices.assert_simple ctx b_implies_c;
    Yices.assert_simple ctx a;
    ignore (Yices.check ctx);
    let model = Yices.get_model ctx in
    assert_equal ~msg:"Check a" (Yices.get_value model (Yices.get_var_decl a)) Yices.True;
    assert_equal ~msg:"Check b" (Yices.get_value model (Yices.get_var_decl b)) Yices.True;
    assert_equal ~msg:"Check c" (Yices.get_value model (Yices.get_var_decl c)) Yices.True
  )

let test_boolean_unsat _ =
  with_context (fun ctx ->
    let a = Yices.mk_bool_var ctx "a"
    and b = Yices.mk_bool_var ctx "b"
    and c = Yices.mk_bool_var ctx "c" in
    let a_implies_b = mk_implies ctx a b
    and b_implies_c = mk_implies ctx b c in
    Yices.assert_simple ctx (Yices.mk_not ctx b);
    Yices.assert_simple ctx a_implies_b;
    Yices.assert_simple ctx b_implies_c;
    Yices.assert_simple ctx a;
    assert_equal (Yices.check ctx) Yices.False
  )

let test_boolean_unsat_core _ =
  with_context (fun ctx ->
    let a = Yices.mk_bool_var ctx "a"
    and b = Yices.mk_bool_var ctx "b"
    and c = Yices.mk_bool_var ctx "c" in
    let a_implies_b = mk_implies ctx a b
    and b_implies_c = mk_implies ctx b c in
    let c1 = Yices.assert_retractable ctx (Yices.mk_not ctx b) in
    let c2 = Yices.assert_retractable ctx a_implies_b in
    let _c3 = Yices.assert_retractable ctx b_implies_c in
    let c4 = Yices.assert_retractable ctx a in
    ignore (Yices.check ctx);
    let core = Yices.get_unsat_core ctx in
    assert_equal (Array.length core) 3;
    let expected = [| c1 ; c2 ; c4 |] in
    Array.sort compare core;
    Array.sort compare expected;
    assert_equal core expected
  )


let alltests = [
	"version" >:: test_version;
	"context" >:: test_context;
	"boolean sat" >:: test_boolean_sat;
	"boolean sat model" >:: test_boolean_sat_model;
	"boolean unsat" >:: test_boolean_unsat
]

let () = run_test_tt_main ("all tests" >::: alltests)
