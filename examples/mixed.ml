

let ctx = Yices.mk_context () in
let light = Yices.get_lite_context ctx in
  Yicesl.read light ("(define x::int)");
  Yicesl.read light ("(assert (and (< x 3)(> x 1)))");
  begin match Yices.check ctx with
  | Yices.True -> prerr_endline "true";
    let model = Yices.get_model ctx in
    let var = Yices.get_var_decl_from_name ctx "x" in
    let value = Yices.get_int_value model var in
      Printf.eprintf "x = %nd\n" value
  | Yices.False -> prerr_endline "false"
  | Yices.Undef -> prerr_endline "unknown"
  end;
(* Don't do that! Yicesl.del_context light;*)
  Yices.del_context ctx


