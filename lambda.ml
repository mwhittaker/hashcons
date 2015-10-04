open Core.Std
open HashCons

type term = term_node hash_consed
and term_node =
  | Var of int
  | Lam of term
  | App of term * term
  with sexp, compare

module TermNode = struct
  type t = term_node with sexp, compare

  let equal a b =
    match a, b with
    | Var x, Var y -> x = y
    | Lam x, Lam y -> phys_equal x y
    | App (a, x), App (b, y) -> phys_equal a b && phys_equal x y
    | _ -> false

  let hash t =
    match t with
    | Var x -> x
    | Lam t -> abs (19 * t.hkey + 1)
    | App (a, b) -> abs (19 * (19 * a.hkey * b.hkey) + 2)
end

module Hterm = Make(TermNode)
let ht = Hterm.create 251

let var x     = Hterm.hashcons ht (Var x)
let lam t     = Hterm.hashcons ht (Lam t)
let app t1 t2 = Hterm.hashcons ht (App (t1, t2))
