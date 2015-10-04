open Core.Std
open HashCons

type term = term_node hash_consed
and term_node =
  | Var of int
  | Lam of term
  | App of term * term
  with sexp, compare

val var : int -> term
val lam : term -> term
val app : term -> term -> term
