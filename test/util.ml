open OUnit2

let bracket_mk_context test_ctxt = 
  bracket
    (fun _ -> Yices.mk_context ())
    (fun ctx _ -> Yices.del_context ctx) test_ctxt
