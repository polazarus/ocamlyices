open Yices;;

print_endline (version ());;

let ex1 =
  let ctx = mk_context () in
  let a = mk_bool_var ctx "a"
  and b = mk_bool_var ctx "b" 
  and c = mk_bool_var ctx "c" in
  let aandb = mk_and ctx [| a ; b |]
  and cimpliesnotb = mk_or ctx [| mk_not ctx c ; mk_not ctx b |] in
  let _ = assert_retractable ctx aandb
  and _ = assert_retractable ctx cimpliesnotb
  in begin
  match check ctx with
  | True ->
    print_endline "true";
    let m = get_model ctx
    and print_value m v = 
      match get_value m v with
      | True -> print_endline ((get_var_decl_name v)^": true")
      | False -> print_endline ((get_var_decl_name v)^": false")
      | Undef -> print_endline ((get_var_decl_name v)^": undef")
    in iter_var_decl (print_value m) ctx
  | False -> print_endline "false"
  | Undef -> print_endline "undef"
  end; del_context ctx
  
  
  
