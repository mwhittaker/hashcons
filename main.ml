open Lambda

let main () =
  let id1 = lam (var 1) in
  let id2 = lam (var 1) in
  assert (id1.tag = id2.tag)

let () =
  main ()
